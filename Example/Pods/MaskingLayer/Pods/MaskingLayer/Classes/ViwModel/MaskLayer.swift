//
//  MaskLayer.swift
//  MaskingLayer
//
//  Created by daisukenagata on 2018/08/04.
//  Copyright © 2018年 daisukenagata. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
public final class MaskLayer: NSObject {

    public var maskColor = UIColor()
    public var path = CGMutablePath()
    public var clipLayer = CAShapeLayer()
    public var minSegment: CGFloat
    public var maskImagePicker = MaskImagePicker()
    public var trimWith: CGFloat = 10
    public var maskWidth: CGFloat = 1
    public var strokeColor = UIColor()
    public var strokeALpha = CGFloat()

    var elements:[MaskPathElement]
    var convertPath = CGMutablePath()
    var length = 0 as CGFloat
    var anchor = CGPoint.zero // last anchor point
    var last = CGPoint.zero // last touch point
    var delta = CGPoint.zero // last movement to compare against to detect a sharp turn
    var fEdge = true //either the begging or the turning point

    init(minSegment: CGFloat) {
        self.elements = [MaskPathElement]()
        self.minSegment = minSegment
        super.init()
        self.maskLayer()
    }
    
    public func colorSet(imageView: UIImageView, color: UIColor) { maskColor = color }

    public func mutablePathSet(mo: MaskingLayerViewModel? = nil) {

        mo?.imageResize()
        mo?.vm.setVideoURLView.removeFromSuperview()
        mo?.cView.removeFromSuperview()
        convertPath = CGMutablePath()
        path = CGMutablePath()
        clipLayer.path = nil
    }

    public func cameraSelect(mo: MaskingLayerViewModel? = nil) { mo?.cameraCount.value = 0 }

    public func maskLayer() {
        maskColor = .white
        clipLayer.name = "clipLayer"
        clipLayer.lineCap = .round
        clipLayer.lineJoin = .round
        clipLayer.fillColor = UIColor.clear.cgColor
        clipLayer.strokeColor = UIColor.white.cgColor
        clipLayer.backgroundColor = UIColor.clear.cgColor
        clipLayer.contentsScale = UIScreen.main.scale
        clipLayer.lineWidth = maskWidth
    }

    public func trimLayer(mo: MaskingLayerViewModel? = nil) {
        mutablePathSet(mo: mo)
        maskColor = .white
        clipLayer.name = "trimLayer"
        clipLayer.lineCap = .butt
        clipLayer.lineJoin = .bevel
        clipLayer.fillColor = UIColor.clear.cgColor
        clipLayer.strokeColor = strokeColor.cgColor.copy(alpha: strokeALpha)
        clipLayer.backgroundColor = UIColor.clear.cgColor
        clipLayer.lineWidth = trimWith
    }

    func longtappedSelect(mo: MaskingLayerViewModel) -> MaskLayer { return self }


    func maskImage(color: UIColor, size: CGSize,convertPath: CGMutablePath) -> UIImage {
        return mask(image: image(color: color, size: size), convertPath: convertPath)
    }

    func imageSet(view:UIView, imageView: UIImageView, image: UIImage) {
        view.layer.addSublayer(clipLayer)
        imageView.image = image.mask(image: imageView.image)
        imageView.image = imageView.image?.ResizeUIImage(width: imageView.frame.width, height: imageView.frame.height)

        guard clipLayer.strokeEnd == 0 else {
            path = CGMutablePath()
            return
        }
    }

    func start(_ pt:CGPoint) -> CGPath? {
        path = CGMutablePath()
        path.move(to: pt)
        elements = [MaskMove(x: pt.x, y: pt.y)]
        anchor = pt
        last = pt
        fEdge = true
        length = 0.0
        return path
    }

    func move(_ pt: CGPoint) -> CGPath? {
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

        return reImage ?? UIImage ()
    }
}
