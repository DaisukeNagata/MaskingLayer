//
//  MaskPortraitMatteModel.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/09/23.
//

import ImageIO
import AVFoundation

final class MaskPortraitMatteModel: NSObject {

    func portraitMatte(imageV: UIImageView,vc: UIViewController, minSegment: CGFloat, mo: MaskingLayerViewModel) {

        let defo = UserDefaults.standard
        let url = defo.url(forKey: "url")
        guard let urlSet = url else { return }
        var mattePixelBuffer: CVPixelBuffer?

        guard let source = CGImageSourceCreateWithURL(urlSet as CFURL, nil) else { return }

        var matteData: [String : AnyObject]? {
            return CGImageSourceCopyAuxiliaryDataInfoAtIndex(source, 0, kCGImageAuxiliaryDataTypePortraitEffectsMatte) as? [String : AnyObject]
        }

        do {
            guard let matte = matteData else {
                let image = UIImage(contentsOfFile: url?.path ?? "")
                imageV.image = image
                return
            }
            mattePixelBuffer = try AVPortraitEffectsMatte(fromDictionaryRepresentation: matte).mattingImage
            guard let pixelBuffer = mattePixelBuffer else { return }
            guard let image = UIImage(contentsOfFile: url!.path) else { return }
            guard let cgOriginalImage = image.cgImage else { return }

            let orgImage = CIImage(cgImage: cgOriginalImage)
            let transform = CGAffineTransform (scaleX: orgImage.extent.width / CIImage(cvPixelBuffer: pixelBuffer).extent.size.width, y: orgImage.extent.height / CIImage(cvPixelBuffer: pixelBuffer).extent.size.height)
            let maskImage = CIImage(cvPixelBuffer: pixelBuffer).transformed(by: transform)

            let filter = CIFilter(name: "CIBlendWithMask")
            filter?.setValue(orgImage, forKey: kCIInputImageKey)
            filter?.setValue(maskImage, forKey: kCIInputMaskImageKey)

            guard let outputImage = filter?.outputImage else { return }
            imageV.image = UIImage(ciImage: outputImage)
            imageV.setNeedsLayout()
        } catch { print(error) }
    }
}
