//
//  MaskLayer.swift
//  MaskingLayer
//
//  Created by daisukenagata on 2018/08/04.
//  Copyright © 2018年 daisukenagata. All rights reserved.
//

import UIKit

public class MaskLayer: NSObject {

    public var maskColor = UIColor()
    public var path = CGMutablePath()
    public var clipLayer = CAShapeLayer()
    var convertPath = CGMutablePath()
    public var maskImagePicker = MaskImagePicker()


    public override init() {
        maskColor = .maskWhite
        clipLayer.lineCap = convertToCAShapeLayerLineCap("round")
        clipLayer.lineJoin = convertToCAShapeLayerLineJoin("round")
        clipLayer.name = "clipLayer"
        clipLayer.lineCap = CAShapeLayerLineCap.round
        clipLayer.lineJoin = CAShapeLayerLineJoin.round
        clipLayer.fillColor = UIColor.clear.cgColor
        clipLayer.strokeColor = UIColor.white.cgColor
        clipLayer.backgroundColor = UIColor.clear.cgColor
        clipLayer.lineWidth = 1
    }

    public func alertSave(views: UIViewController,imageView: UIImageView, image: UIImage) {
        let alertController = UIAlertController(title: NSLocalizedString("BackGround Color", comment: ""), message: "", preferredStyle: .alert)
        let stringAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor(red: 0/255, green: 136/255, blue: 83/255, alpha: 1.0),
            .font : UIFont.systemFont(ofSize: 22.0)
        ]
        let string = NSAttributedString(string: alertController.title!, attributes:stringAttributes)
        alertController.setValue(string, forKey: "attributedTitle")
        alertController.view.tintColor = UIColor(red: 0/255, green: 136/255, blue: 83/255, alpha: 1.0)

        let maskWhite = UIAlertAction(title: NSLocalizedString("MaskWhite", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            self.maskColor = .maskWhite; self.colorSet(views: views, imageView: imageView, image: image, color: self.maskColor)
        }
        let maskLightGray = UIAlertAction(title: NSLocalizedString("MaskLightGray", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            self.maskColor = .maskLightGray; self.colorSet(views: views, imageView: imageView, image: image, color: self.maskColor)
        }
        let maskGray = UIAlertAction(title: NSLocalizedString("MaskGray", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            self.maskColor = .maskGray; self.colorSet(views: views, imageView: imageView, image: image, color: self.maskColor)
        }
        let maskDarkGray = UIAlertAction(title: NSLocalizedString("MaskDarkGray", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            self.maskColor = .maskDarkGray; self.colorSet(views: views, imageView: imageView, image: image, color: self.maskColor)
        }
        let maskLightBlack = UIAlertAction(title: NSLocalizedString("MaskLightBlack", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            self.maskColor = .maskLightBlack; self.colorSet(views: views, imageView: imageView, image: image, color: self.maskColor)
        }
        let cameraRoll = UIAlertAction(title: NSLocalizedString("CameraRoll ", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            self.maskImagePicker.photeSegue(vc: views,bool: false)
            imageView.removeFromSuperview()
        }
        let videoRoll = UIAlertAction(title: NSLocalizedString("VideoRoll ", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            self.maskImagePicker.photeSegue(vc: views,bool: true)
        }
        let reset = UIAlertAction(title: NSLocalizedString("ReSet ", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
        }
        self.imageReSet(view: views.view, imageView: imageView, image: image)
        alertController.addAction(maskWhite)
        alertController.addAction(maskLightGray)
        alertController.addAction(maskGray)
        alertController.addAction(maskDarkGray)
        alertController.addAction(maskLightBlack)
        alertController.addAction(cameraRoll)
        alertController.addAction(videoRoll)
        alertController.addAction(reset)
        views.present(alertController, animated: true, completion: nil)
    }

    func alertPortrait(views: UIViewController) {
        let alertController = UIAlertController(title: NSLocalizedString("Prease Portrait Library", comment: ""), message: "", preferredStyle: .alert)
        let stringAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor(red: 0/255, green: 136/255, blue: 83/255, alpha: 1.0),
            .font : UIFont.systemFont(ofSize: 22.0)
        ]
        let string = NSAttributedString(string: alertController.title!, attributes:stringAttributes)
        alertController.setValue(string, forKey: "attributedTitle")
        alertController.view.tintColor = UIColor(red: 0/255, green: 136/255, blue: 83/255, alpha: 1.0)
        
        let reset = UIAlertAction(title: NSLocalizedString("ReSet ", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(reset)
        views.present(alertController, animated: true, completion: nil)
    }

    func maskConvertPointFromView(viewPoint: CGPoint,view: UIView, imageView: UIImageView, bool: Bool) {
        clipLayer.path = path
        guard bool == false else {
            convertPath.move(to: CGPoint(x: convertPointFromView(viewPoint, view: view, imageView: imageView).x, y: convertPointFromView(viewPoint, view: view, imageView: imageView).y))
            return
        }
        convertPath.addLine(to: CGPoint(x: convertPointFromView(viewPoint, view: view, imageView: imageView).x, y: convertPointFromView(viewPoint, view: view, imageView: imageView).y))
    }

    func convertPath(convertLocation: CGPoint) { convertPath.move(to: CGPoint(x: convertLocation.x, y: convertLocation.y)) }

    func mask(image: UIImage,convertPath: CGMutablePath) -> UIImage { clipLayer.isHidden = true; return clipedMotoImage(image,convertPath:convertPath) }

    func maskImage(color: UIColor, size: CGSize,convertPath: CGMutablePath) -> UIImage { return mask(image: image(color: color, size: size), convertPath: convertPath) }

    func imageSave(imageView: UIImageView, name: String) {
        let pngImageData = imageView.image!.pngData()
        let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(name)
        do {
            try pngImageData!.write(to: fileURL)
            imageLoad(imageView: imageView, name: name)
        } catch {
        }
    }

    func imageReSet(view: UIView, imageView: UIImageView, image: UIImage) {
        imageView.image =  image
        imageView.image = imageView.image?.ResizeUIImage(width: view.frame.width, height: view.frame.height)
        imageView.frame = view.frame
        convertPath = CGMutablePath()
        path = CGMutablePath()
    }

    func imageSet(view:UIView, imageView: UIImageView, image: UIImage) {
        view.layer.addSublayer(clipLayer)
        imageView.image = image.mask(image: imageView.image)
        imageView.image = imageView.image?.ResizeUIImage(width: view.frame.width, height: view.frame.height)
        imageView.frame = view.frame
        guard clipLayer.strokeEnd == 0 else {
            path = CGMutablePath()
            return
        }
    }

    private func colorSet(views: UIViewController,imageView: UIImageView,image: UIImage, color: UIColor) {
        imageView.image = self.mask(image: self.image(color: self.maskColor, size: views.view.frame.size), convertPath: self.convertPath)
        self.imageSet(view: views.view, imageView: imageView, image: image)
    }

    private func imageLoad(imageView: UIImageView, name: String) {
        let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(name)
        let image = UIImage(contentsOfFile: fileURL.path)
        guard image == nil else {
            imageView.image! = image!
            path = CGMutablePath()
            return
        }
    }

    private func image(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    private func clipedMotoImage(_ img: UIImage,convertPath: CGMutablePath) -> UIImage {
        let motoImage = img

        UIGraphicsBeginImageContextWithOptions((motoImage.size), false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()

        motoImage.draw(in: CGRect(x: 0, y: 0, width: (motoImage.size.width), height: (motoImage.size.height)))
        context?.addPath(convertPath)

        context?.setFillColor(UIColor.black.cgColor)
        context?.drawPath(using: CGPathDrawingMode.fillStroke)

        let reImage = UIGraphicsGetImageFromCurrentImageContext()
        context?.restoreGState()
        UIGraphicsEndImageContext()

        return reImage!
    }

    private func convertPointFromView(_ viewPoint: CGPoint,view: UIView, imageView: UIImageView) -> CGPoint {
        var imagePoint : CGPoint = viewPoint
        let imageSize = imageView.image?.size
        let viewSize = view.frame.size

        let ratioX : CGFloat = viewSize.width / imageSize!.width
        let ratioY : CGFloat = viewSize.height / imageSize!.height
        let scale : CGFloat = min(ratioX, ratioY)

        imagePoint.x -= (viewSize.width  - imageSize!.width  * scale) / 2
        imagePoint.y -= (viewSize.height - imageSize!.height * scale) / 2

        imagePoint.x /= scale
        imagePoint.y /= scale

        return imagePoint
    }
}

public extension UIColor {
    class var maskWhite: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
    class var maskLightGray: UIColor { return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
    class var maskGray: UIColor { return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) }
    class var maskDarkGray: UIColor { return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) }
    class var maskLightBlack: UIColor { return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) }
}

public extension UIImage {
    func ResizeUIImage(width : CGFloat, height : CGFloat)-> UIImage! {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height),true,0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func mask(image: UIImage?) -> UIImage {
        if let maskRef = image?.cgImage,
            let ref = cgImage,
            let mask = CGImage(maskWidth: maskRef.width,
                               height: maskRef.height,
                               bitsPerComponent: maskRef.bitsPerComponent,
                               bitsPerPixel: maskRef.bitsPerPixel,
                               bytesPerRow: maskRef.bytesPerRow,
                               provider: maskRef.dataProvider!,
                               decode: nil,
                               shouldInterpolate: false),
            let output = ref.masking(mask) {
            return UIImage(cgImage: output)
        }
        return self
    }
}

public extension CGImage {
    func resize(_ image: CGImage) -> CGImage? {
        let maxWidth: CGFloat = CGFloat(UIScreen.main.bounds.width)
        let maxHeight: CGFloat = CGFloat(UIScreen.main.bounds.height)

        guard let colorSpace = image.colorSpace else { return nil }
        guard let context = CGContext(data: nil, width: Int(maxWidth), height: Int(maxHeight), bitsPerComponent: image.bitsPerComponent, bytesPerRow: image.bytesPerRow, space: colorSpace, bitmapInfo: image.alphaInfo.rawValue) else { return nil }

        context.interpolationQuality = .high
        context.draw(image, in: CGRect(x: 0, y: 0, width: Int(maxWidth), height: Int(maxHeight)))

        return context.makeImage()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAShapeLayerLineCap(_ input: String) -> CAShapeLayerLineCap {
	return CAShapeLayerLineCap(rawValue: input)
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAShapeLayerLineJoin(_ input: String) -> CAShapeLayerLineJoin {
	return CAShapeLayerLineJoin(rawValue: input)
}
