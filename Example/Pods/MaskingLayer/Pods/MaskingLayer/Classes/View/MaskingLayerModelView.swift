//
//  MaskingLayerModelView.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2021/03/13.
//

import AVFoundation
import MobileCoreServices

public final class MaskingLayerModelView: NSObject {

    public var mv: MaskGestureViewModel?
    public var maskModel: MaskingLayerModel?
    public var mLViewModel: MaskingLayerViewModel?
    private var trimFlag: Bool
    private var orignCenter: CGFloat = 0

    public init(trimFlag: Bool? = nil,
                minSegment: CGFloat,
                originPosition: CGFloat,
                windowSizeWidth: CGFloat,
                windowSizeHeight: CGFloat,
                windowAlpha: CGFloat,
                windowColor: UIColor,
                image: UIImage?,
                imageView: UIImageView,
                maskGestureView: UIView) {

        mLViewModel = MaskingLayerViewModel(minSegment: minSegment)
        maskModel = MaskingLayerModel(image: image,
                                      originPosition: originPosition,
                                      windowSizeWidth: windowSizeWidth,
                                      windowSizeHeight: windowSizeHeight,
                                      windowColor: windowColor,
                                      windowAlpha: windowAlpha,
                                      imageView: imageView,
                                      windowFrameView: maskModel?.windowFrameView,
                                      defaltImageView: imageView,
                                      maskGestureView: maskGestureView)
        self.trimFlag = trimFlag ?? false

        super.init()
        frameResize(images: image, rect: imageView.frame)    
        mv = MaskGestureViewModel(mo: mLViewModel ?? MaskingLayerViewModel(minSegment: minSegment), modelView: self)
        orignCenter = (maskModel?.defaltImageView.frame.height ?? 0)/2 + (maskModel?.defaltImageView.frame.origin.y ?? 0)
    }

    public func desginInit(color: UIColor) {
        guard let size = maskModel else { return }

        orignCenter = (maskModel?.defaltImageView.frame.height ?? 0)/2 + (maskModel?.defaltImageView.frame.origin.y ?? 0)
        maskModel?.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        maskModel?.imageView.center = CGPoint(x:(maskModel?.defaltImageView.frame.width ?? 0) / 2,
                                              y: orignCenter)
        maskModel?.windowFrameView?.isHidden = false
        mLViewModel?.maskLayer?.mutablePathSet(modelView: self)
        maskModel?.windowFrameView = UIView(frame: CGRect(x: 0,
                                                          y: 0,
                                                          width: size.windowSizeWidth,
                                                          height: size.windowSizeHeight))
        maskModel?.windowFrameView?.backgroundColor = maskModel?.windowColor
        maskModel?.windowFrameView?.alpha = maskModel?.windowAlpha ?? 0

        maskModel?.imageView.addSubview(maskModel?.windowFrameView ?? UIImageView())
    }

    public func frameResize(images: UIImage?, rect: CGRect) {
        guard let maskLayer = mLViewModel?.maskLayer, let model = maskModel, let images = images else { return }
        maskModel?.imageView.frame = rect
        maskModel?.image = images.ResizeUIImage(width: rect.width,
                                                height: rect.height)
        
        let imageSize = AVMakeRect(aspectRatio: images.size,
                                   insideRect: model.imageView.bounds)
        model.imageView.image = maskModel?.image
        model.imageView.frame.size = imageSize.size
        model.imageView.center = CGPoint(x: rect.width/2, y: rect.origin.y + rect.height/2)
        
        if model.defaltImageView.image == nil {
            maskModel?.defaltImageView.frame = maskModel?.imageView.frame ?? CGRect()
            mLViewModel?.maskPathSet(maskLayer: maskLayer, model: model)
        }

        maskModel?.defaltImageView.image = maskModel?.imageView.image
    }

    func imageResize() {
        maskModel?.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        maskModel?.imageView.center = CGPoint(x:(maskModel?.defaltImageView.frame.width ?? 0) / 2,
                                              y: orignCenter)
        maskModel?.windowFrameView?.removeFromSuperview()
        maskModel?.windowFrameView = nil
        maskModel?.imageView.layer.mask?.removeFromSuperlayer()
        maskModel?.imageView.frame = maskModel?.defaltImageView.frame ?? CGRect()
        maskModel?.imageView.image = maskModel?.image
    }

}

// MARK: UIPanGestureRecognizer

extension MaskingLayerModelView {

    func panTapped(sender: UIPanGestureRecognizer) {
        guard let maskGestureView = maskModel?.maskGestureView,
              let imageView = maskModel?.imageView,
              let originPosition = maskModel?.originPosition,
              let panGestureStartX = mLViewModel?.panGestureStartX,
              let panGestureStartY = mLViewModel?.panGestureStartY else { return }
        let position: CGPoint = sender.location(in: (maskModel?.windowFrameView?.isHidden ?? true) ? maskGestureView : imageView)

        switch sender.state {
        case .ended:
            switch maskModel?.windowFrameView {
            case nil:
                panGestureStartX > position.x ?
                    (mLViewModel?.panGestureRect = CGRect(x: position.x, y: panGestureStartY + imageView.frame.origin.y, width: panGestureStartX - position.x, height: mLViewModel?.maskLayer?.trimWith ?? 0.0)):
                    (mLViewModel?.panGestureRect = CGRect(x: panGestureStartX, y: panGestureStartY + imageView.frame.origin.y, width: position.x - panGestureStartX, height: mLViewModel?.maskLayer?.trimWith ?? 0.0))
                
                mLViewModel?.maskLayer?.clipLayer.name == "trimLayer" ?
                    mLViewModel?.endPangesture(position: CGPoint(x: position.x, y: panGestureStartY), imageView: imageView) :
                    mLViewModel?.maskPathEnded(position: CGPoint(x: position.x, y: position.y - originPosition), model: maskModel)
            case.some:
                guard let windowFrame = maskModel?.windowFrameView?.frame else { return }
                maskModel?.windowFrameView?.isHidden ?? false ?
                    (maskModel?.imageView.frame.origin = CGPoint(x: position.x + ( -(imageView.frame.width)/2),
                                                                 y: position.y + ( -(imageView.frame.height)/2))) :
                    (maskModel?.windowFrameView?.frame.origin = CGPoint(x: position.x + ( -(windowFrame.width)/2),
                                                                       y: position.y + ( -(windowFrame.height)*2)))
            }
            break
        case .possible: break
        case .began:
            switch maskModel?.windowFrameView {
            case nil:
                mLViewModel?.panGestureStartY = position.y + ( -(imageView.frame.height)/2)
                mLViewModel?.panGestureStartX = position.x
                mLViewModel?.maskLayer?.clipLayer.name == "trimLayer" ?
                    mLViewModel?.maskPathBegan(position: CGPoint(x: position.x, y: mLViewModel?.panGestureStartY ?? 0.0)) :
                    mLViewModel?.maskPathBegan(position: CGPoint(x: position.x, y: position.y - originPosition))
            case.some:
                guard let windowFrame = maskModel?.windowFrameView?.frame else { return }
                maskModel?.windowFrameView?.isHidden ?? false ?
                    (maskModel?.imageView.frame.origin = CGPoint(x: position.x + ( -(imageView.frame.width)/2),
                                                                 y: position.y + ( -(imageView.frame.height)/2))) :
                    (maskModel?.windowFrameView?.frame.origin = CGPoint(x: position.x + ( -(windowFrame.width)/2),
                                                                       y: position.y + ( -(windowFrame.height)*2)))
            }
            break
        case .changed:
            switch maskModel?.windowFrameView {
            case nil:
                mLViewModel?.maskLayer?.clipLayer.name == "trimLayer" ?
                    mLViewModel?.maskAddLine(position: CGPoint(x: position.x, y: panGestureStartY)) :
                    mLViewModel?.maskAddLine(position: CGPoint(x: position.x, y: position.y - originPosition))
            case.some:
                guard let windowFrame = maskModel?.windowFrameView?.frame else { return }
                maskModel?.windowFrameView?.isHidden ?? false ?
                    (maskModel?.imageView.frame.origin = CGPoint(x: position.x + ( -(imageView.frame.width)/2),
                                                                 y: position.y + ( -(imageView.frame.height)/2))) :
                    (maskModel?.windowFrameView?.frame.origin = CGPoint(x: position.x + ( -(windowFrame.width)/2),
                                                                       y: position.y + ( -(windowFrame.height)*2)))
            }
            break
        case .cancelled: break
        case .failed: break
        @unknown default: break
        }
    }
    
    func pinchAction(sender: UIPinchGestureRecognizer) {
        let rate = sender.scale
        maskModel?.windowFrameView?.isHidden == true ?
        (maskModel?.imageView.transform = CGAffineTransform(scaleX: rate, y: trimFlag ? 1 : rate)):
            (maskModel?.windowFrameView?.transform = CGAffineTransform(scaleX: rate, y: trimFlag ? 1 : rate))
        
    }
    
    func tapAction(sender: UITapGestureRecognizer) {
        maskModel?.windowFrameView?.isHidden == true ?
            (maskModel?.windowFrameView?.isHidden = false) :
            (maskModel?.windowFrameView?.isHidden = true)
    }

}

// MARK: UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension MaskingLayerModelView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

            guard let images = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage) else { return }
            picker.dismiss(animated: true, completion: { [self] in
                frameResize(images: images, rect: self.maskModel?.imageView.frame ?? CGRect())
                mLViewModel?.maskPathBegan(position: CGPoint())
                mLViewModel?.maskCount.value = 0
            })
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    public func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    public func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}
