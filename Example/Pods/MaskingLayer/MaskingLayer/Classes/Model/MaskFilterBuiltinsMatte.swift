//
//  MaskFilterBuiltinsMatte.swift
//  MaskMatte
//
//  Created by 永田大祐 on 2019/11/05.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage.CIFilterBuiltins

final class MaskFilterBuiltinsMatte: NSObject {

    lazy var context = CIContext()

    var xibView                 : SliiderObjects? = nil
    var photos                  : AVCapturePhoto?
    var semanticSegmentationType: AVSemanticSegmentationMatte.MatteType?

    private var call                    = { (_ image: UIImage?) -> Void in }

    private var videoDeviceInput        : AVCaptureDeviceInput!
    private var captureDeviceInput      : AVCaptureDeviceInput!
    private var based                   : CIImage?
    private var currentDevice           : AVCaptureDevice?
    private var captureSession          : AVCaptureSession?
    private var photoOutput             : AVCapturePhotoOutput?
    private var settings                : AVCapturePhotoSettings?
    private var cameraPreviewLayer      : AVCaptureVideoPreviewLayer?
    private var photoQualityPrioritizationMode: AVCapturePhotoOutput.QualityPrioritization = .balanced
    private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
                                                                                  mediaType: .video, position: .unspecified)

    func setMaskFilter(view: UIView) {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSession.Preset.photo
        setupInputOutput()
        setupPreviewLayer(view)
        captureSession?.startRunning()
        self.xibView?.removeFromSuperview()
    }

    func returnAnimation(height: CGFloat) {
        xibView?.returnAnimation()
    }

    func btAction(view: UIView, tabHeight: CGFloat) {
        if self.xibView?.sliderImageView.image == nil {
            cameraAction { image in
                self.xibView = SliiderObjects(frameHight: 100)
                self.xibView?.frame = view.frame
                self.xibView?.sliderImageView.contentMode = .scaleAspectFit
                self.xibView?.sliderImageView.image = image
                view.addSubview(self.xibView ?? SliiderObjects(frameHight: tabHeight))
            }
        } else {
            maskFilterBuiltinsChanges(value    : xibView?.sliderInputRVector.value,
                                      value2   : xibView?.sliderInputGVector.value,
                                      value3   : xibView?.sliderInputBVector.value,
                                      value4   : xibView?.sliderInputAVector.value,
                                      photo    : photos,
                                      ssmType  : semanticSegmentationType,
                                      imageView: xibView?.sliderImageView ?? UIImageView())
        }
    }

    func cameraAction(_ callBack: @escaping (_ image: UIImage?) -> Void){
        settings = AVCapturePhotoSettings()
        settings? = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        settings?.flashMode = .auto
        settings?.isHighResolutionPhotoEnabled = true
        settings?.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: settings?.__availablePreviewPhotoPixelFormatTypes.first ?? NSNumber()]
        settings?.isDepthDataDeliveryEnabled = true
        settings?.isDepthDataDeliveryEnabled = true
        settings?.isPortraitEffectsMatteDeliveryEnabled = true
        if !(self.photoOutput?.enabledSemanticSegmentationMatteTypes.isEmpty)! {
            settings?.enabledSemanticSegmentationMatteTypes = self.photoOutput?.enabledSemanticSegmentationMatteTypes ?? [AVSemanticSegmentationMatte.MatteType]()
        }

        settings?.photoQualityPrioritization = self.photoQualityPrioritizationMode
        photoOutput?.capturePhoto(with: settings ?? AVCapturePhotoSettings(), delegate: self)

        call = callBack
    }

    func cameraReset() {
        based = nil
        photos = nil
        settings = nil
        photoOutput = nil
        currentDevice = nil

        captureSession?.stopRunning()
        // メモリ解放
        for output in (self.captureSession?.outputs)! {
            self.captureSession?.removeOutput(output as AVCaptureOutput)
        }
        for input in (self.captureSession?.inputs)! {
            self.captureSession?.removeInput(input as AVCaptureInput)
        }

        context.clearCaches()
        xibView?.removeFromSuperview()
        xibView?.sliderView.removeFromSuperview()
        cameraPreviewLayer?.removeFromSuperlayer()
        xibView?.sliderImageView.removeFromSuperview()
    }

    func uIImageWriteToSavedPhotosAlbum() { UIImageWriteToSavedPhotosAlbum(xibView?.sliderImageView.image ?? UIImage(), nil,nil,nil) }

    private func matteSetting(value    : Float? = nil,
                              value2   : Float? = nil,
                              value3   : Float? = nil,
                              value4   : Float? = nil,
                              base     : CIImage,
                              ssm      : AVSemanticSegmentationMatte) -> Data {
        let maxcomp1 = CIFilter.maximumComponent()
        maxcomp1.inputImage = base
        var makeup1 = maxcomp1.outputImage
        let gamma1 = CIFilter.gammaAdjust()
        gamma1.inputImage = base
        gamma1.power = value ?? 0.65
        makeup1 = gamma1.outputImage

        let maxcomp = CIFilter.maximumComponent()
        maxcomp.inputImage = makeup1
        var makeup = maxcomp.outputImage
        let gamma = CIFilter.colorMatrix()
        gamma.inputImage = makeup1
        gamma.setValue(CIVector(x: 0, y: CGFloat(value2 ?? 1), z: 0, w: 0), forKey: "inputRVector")
        gamma.setValue(CIVector(x: 0, y: CGFloat(value3 ?? 1), z: 0, w: 0), forKey: "inputGVector")
        gamma.setValue(CIVector(x: 0, y: CGFloat(value4 ?? 1), z: 0, w: 0), forKey: "inputBVector")
        gamma.setValue(CIVector(x: 0, y: 0, z: 0, w: 1), forKey: "inputAVector")
        makeup = gamma.outputImage

        var matte = CIImage(cvImageBuffer: ssm.mattingImage, options: [.auxiliarySemanticSegmentationHairMatte : true])

        let scale = CGAffineTransform(scaleX: base.extent.size.width / matte.extent.size.width,
                                      y: base.extent.size.height / matte.extent.size.height)
        matte = matte.transformed( by: scale )

        let blend = CIFilter.blendWithMask()
        blend.backgroundImage = base
        blend.inputImage = makeup
        blend.maskImage = matte
        let result = blend.outputImage
        guard let outputImage = result else { return Data()}
        guard let perceptualColorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return Data()}

        let ciImage = CIImage( cvImageBuffer: ssm.mattingImage,
                               options: [.auxiliarySemanticSegmentationHairMatte: true,
                                         .colorSpace: perceptualColorSpace])

        guard let linearColorSpace = CGColorSpace(name: CGColorSpace.linearSRGB),
            let imagedata = context.pngRepresentation(of: outputImage,
                                                  format: .RGBA8,
                                                  colorSpace: linearColorSpace,
                                                  options: [.semanticSegmentationHairMatteImage : ciImage,]) else { return Data()}

        return imagedata
    }

    private func maskFilterBuiltins(_ bind : @escaping (_ image: UIImage?) -> Void,
                                    value  : Float? = nil,
                                    value2 : Float? = nil,
                                    value3 : Float? = nil,
                                    value4 : Float? = nil,
                                    photo  : AVCapturePhoto,
                                    ssmType: AVSemanticSegmentationMatte.MatteType,
                                    image  : UIImage) {

        guard var segmentationMatte = photo.semanticSegmentationMatte(for: ssmType),
            let base = CIImage(image: image.updateImageOrientionUpSide()) else { return }
        if let orientation = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
            let exifOrientation = CGImagePropertyOrientation(rawValue: orientation) {

            segmentationMatte = segmentationMatte.applyingExifOrientation(exifOrientation)
        }
        based = base
        photos = photo
        let imagedata = matteSetting(base: base, ssm: segmentationMatte)
        bind(UIImage(data: imagedata))
    }

    private func maskFilterBuiltinsChanges(value    : Float? = nil,
                                           value2   : Float? = nil,
                                           value3   : Float? = nil,
                                           value4   : Float? = nil,
                                           photo    : AVCapturePhoto?,
                                           ssmType  : AVSemanticSegmentationMatte.MatteType?,
                                           imageView: UIImageView) {

        guard let ssmType = ssmType else { return }
        guard var segmentationMatte = photo?.semanticSegmentationMatte(for: ssmType) else { return }
        if let orientation = photo?.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
            let exifOrientation = CGImagePropertyOrientation(rawValue: orientation) {
            
            segmentationMatte = segmentationMatte.applyingExifOrientation(exifOrientation)
        }
        let base = based
        let imagedata = matteSetting(value: value, value2: value2, value3: value3, value4: value4, base: base ?? CIImage(), ssm: segmentationMatte)
        imageView.image = UIImage(data: imagedata)
    }

    private func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let deviceDescoverySession =

            AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                                                  mediaType: AVMediaType.video,
                                                  position: AVCaptureDevice.Position.unspecified)

        for device in deviceDescoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }

    private func setupPreviewLayer(_ view: UIView) {
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession ?? AVCaptureSession())
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.cameraPreviewLayer?.frame = view.frame
        view.layer.insertSublayer(self.cameraPreviewLayer ?? AVCaptureVideoPreviewLayer(), at: 0)
    }

    private func setupInputOutput() {
        photoOutput = AVCapturePhotoOutput()
        guard let captureSession = captureSession  else { return }
        guard let photoOutput = photoOutput else { return }
        do {
            captureSession.beginConfiguration()
            captureSession.sessionPreset = .photo
            let devices = self.videoDeviceDiscoverySession.devices
            currentDevice = devices.first(where: { $0.position == .front && $0.deviceType == .builtInTrueDepthCamera })

            guard let videoDevice = currentDevice else { return }
            videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)

            if captureSession.canAddInput(videoDeviceInput) { captureSession.addInput(videoDeviceInput) }

            currentDevice = AVCaptureDevice.default(for: .audio)
            captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)

            if captureSession.canAddInput(captureDeviceInput) {
                captureSession.addInput(captureDeviceInput)
            } else {
                print("Could not add audio device input to the session")
            }
        } catch {
            print(error)
        }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)

            photoOutput.isHighResolutionCaptureEnabled = true
            photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported
            photoOutput.isDepthDataDeliveryEnabled = photoOutput.isDepthDataDeliverySupported
            photoOutput.isPortraitEffectsMatteDeliveryEnabled = photoOutput.isPortraitEffectsMatteDeliverySupported
            photoOutput.enabledSemanticSegmentationMatteTypes = photoOutput.availableSemanticSegmentationMatteTypes
            photoOutput.maxPhotoQualityPrioritization = .balanced
            captureSession.commitConfiguration()
        }
    }
}

//MARK: AVCapturePhotoCaptureDelegate
extension MaskFilterBuiltinsMatte: AVCapturePhotoCaptureDelegate{

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        var uiImage: UIImage?
        if let imageData = photo.fileDataRepresentation() {

            uiImage = UIImage(data: imageData)

            for semanticSegmentationTypes in output.enabledSemanticSegmentationMatteTypes {
                if semanticSegmentationTypes == .hair {
                    semanticSegmentationType = semanticSegmentationTypes
                    maskFilterBuiltins(callBack(image:), photo: photo, ssmType: semanticSegmentationType!, image: uiImage ?? UIImage())
                }
            }
        }
    }
    func callBack(image: UIImage?) { call(image) }
}
