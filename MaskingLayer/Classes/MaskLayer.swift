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
    public var maskImagePicker = MaskImagePicker()

    public var minSegment: CGFloat
    var elements:[MaskPathElement]
    var convertPath = CGMutablePath()
    var length = 0 as CGFloat
    var anchor = CGPoint.zero // last anchor point
    var last = CGPoint.zero // last touch point
    var delta = CGPoint.zero // last movement to compare against to detect a sharp turn
    var fEdge = true //either the begging or the turning point

    
    public init(minSegment: CGFloat) {
        self.elements = [MaskPathElement]()
        self.minSegment = minSegment
        
        maskColor = .maskWhite
        clipLayer.name = "clipLayer"
        clipLayer.lineCap = CAShapeLayerLineCap.round
        clipLayer.lineJoin = CAShapeLayerLineJoin.round
        clipLayer.fillColor = UIColor.clear.cgColor
        clipLayer.strokeColor = UIColor.white.cgColor
        clipLayer.backgroundColor = UIColor.clear.cgColor
        clipLayer.contentsScale = UIScreen.main.scale
        clipLayer.lineWidth = 1
    }

    public func alertSave(views: UIViewController,mo: MaskNavigationObject) {
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
            self.mutablePathSet()
            self.maskColor = .maskWhite; self.colorSet(views: views, imageView: mo.imageView, image: mo.image, color: self.maskColor)
        }
        let maskLightGray = UIAlertAction(title: NSLocalizedString("MaskLightGray", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            self.mutablePathSet()
            self.maskColor = .maskLightGray; self.colorSet(views: views, imageView: mo.imageView, image: mo.image, color: self.maskColor)
        }
        let maskGray = UIAlertAction(title: NSLocalizedString("MaskGray", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            self.mutablePathSet()
            self.maskColor = .maskGray; self.colorSet(views: views, imageView: mo.imageView, image: mo.image, color: self.maskColor)
        }
        let maskDarkGray = UIAlertAction(title: NSLocalizedString("MaskDarkGray", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            self.mutablePathSet()
            self.maskColor = .maskDarkGray; self.colorSet(views: views, imageView: mo.imageView, image: mo.image, color: self.maskColor)
        }
        let maskLightBlack = UIAlertAction(title: NSLocalizedString("MaskLightBlack", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            self.mutablePathSet()
            self.maskColor = .maskLightBlack; self.colorSet(views: views, imageView: mo.imageView, image: mo.image, color: self.maskColor)
        }
        let cameraRoll = UIAlertAction(title: NSLocalizedString("CameraRoll ", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            self.maskImagePicker.photoSegue(vc: views,bool: false)
        }
        let backImage = UIAlertAction(title: NSLocalizedString("BackImage ", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            mo.imageBackView.image = mo.imageView.image
            mo.imageBackView.frame = mo.imageView.frame
            mo.imageBackView.setNeedsLayout()
            self.alertPortrait(views: views)
        }
        let videoRoll = UIAlertAction(title: NSLocalizedString("VideoRoll ", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            self.maskImagePicker.photoSegue(vc: views,bool: true)
        }
        let reset = UIAlertAction(title: NSLocalizedString("ReSet ", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            self.mutablePathSet(mO: mo)
        }
        mo.imageView.setNeedsLayout()
        alertController.addAction(maskWhite)
        alertController.addAction(maskLightGray)
        alertController.addAction(maskGray)
        alertController.addAction(maskDarkGray)
        alertController.addAction(maskLightBlack)
        alertController.addAction(cameraRoll)
        alertController.addAction(backImage)
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

        let reset = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            self.maskImagePicker.photoSegue(vc: views,bool: false)
        }
        alertController.addAction(reset)
        views.present(alertController, animated: true, completion: nil)
    }

    public func maskImage(color: UIColor, size: CGSize,convertPath: CGMutablePath) -> UIImage {
        return mask(image: image(color: color, size: size), convertPath: convertPath)
    }

    func mutablePathSet(mO: MaskNavigationObject? = nil) {

        mO?.imageResize(images: mO?.imageBackView.image ?? UIImage())
        convertPath = CGMutablePath()
        path = CGMutablePath()
    }

    public func imageSet(view:UIView, imageView: UIImageView, image: UIImage) {
        view.layer.addSublayer(clipLayer)
        imageView.image = image.mask(image: imageView.image)
        imageView.image = imageView.image?.ResizeUIImage(width: imageView.frame.width, height: imageView.frame.height)
    
        guard clipLayer.strokeEnd == 0 else {
            path = CGMutablePath()
            return
        }
    }

    public func start(_ pt:CGPoint) -> CGPath? {
        path = CGMutablePath()
        path.move(to: pt)
        elements = [MaskMove(x: pt.x, y: pt.y)]
        anchor = pt
        last = pt
        fEdge = true
        length = 0.0
        return path
    }
    
    public func move(_ pt:CGPoint) -> CGPath? {
        var pathToReturn:CGPath?
        let d = pt.delta(last)
        length += sqrt(d.dotProduct(d))
        if length > minSegment {
            // Detected enough movement. Add a quad segment, if we are not at the edge.
            if !fEdge {
                let ptMid = anchor.middle(pt)
                path.addQuadCurve(to: pt, control: anchor)
                elements.append(MaskQuadCurve(cpx: anchor.x, cpy: anchor.y, x: ptMid.x, y: ptMid.y))
                pathToReturn = path
            }
            delta = pt.delta(anchor)
            anchor = pt
            fEdge = false
            length = 0.0
        } else if !fEdge && delta.dotProduct(d) < 0 {
            pathToReturn = path
            anchor = last // matter for delta in "Neither" case (does not matter for QuadCurve, see above)
            fEdge = true
            length = 0.0
        } else {
            // Neigher. Return the path with a line to the current point as a transient path.
            if let pathTemp = path.mutableCopy() {
                pathTemp.addLine(to: pt)
                pathToReturn = pathTemp
                delta = pt.delta(anchor)
            } else {
                assertionFailure("SNPathBuilder: CGPathCreateMutableCopy should not fail.")
            }
        }
        last = pt
        return pathToReturn
    }

    private func convertPath(convertLocation: CGPoint) { convertPath.move(to: CGPoint(x: convertLocation.x, y: convertLocation.y)) }

    private func mask(image: UIImage,convertPath: CGMutablePath) -> UIImage {
        clipLayer.isHidden = true
        return clipedMotoImage(image,convertPath:convertPath)
    }

    private func colorSet(views: UIViewController,imageView: UIImageView,image: UIImage, color: UIColor) {
        imageView.image = self.mask(image: self.image(color: color, size: imageView.frame.size), convertPath: convertPath)
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
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAShapeLayerLineCap(_ input: String) -> CAShapeLayerLineCap {
	return CAShapeLayerLineCap(rawValue: input)
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAShapeLayerLineJoin(_ input: String) -> CAShapeLayerLineJoin {
	return CAShapeLayerLineJoin(rawValue: input)
}
