//
//  ViewController.swift
//  MaskingLayer
//
//  Created by daisukenagata on 08/04/2018.
//  Copyright (c) 2018 daisukenagata. All rights reserved.
//

import UIKit
import MaskingLayer

struct CommonStructure {
    static var swipePanGesture = UIPanGestureRecognizer()
}

class ViewController: UIViewController,UIGestureRecognizerDelegate {

    let imageView = UIImageView()
    let maskLayer = MaskLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        CommonStructure.swipePanGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.swipePanGesture.delegate = self
        view.addGestureRecognizer( CommonStructure.swipePanGesture)
        view.backgroundColor = UIColor.black
        imageSet()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.addSubview(imageView)
        view.layer.addSublayer(maskLayer.clipLayer)
    }

    func imageSet() {
        imageView.image =  UIImage(named: "IMG_4011")?.mask(image: imageView.image)
        imageView.image = imageView.image?.ResizeUIImage(width: view.frame.width, height: view.frame.height)
        imageView.frame = self.view.frame
    }

    @objc func panTapped(sender:UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: imageView)
        switch sender.state {
        case .ended:
            guard let size = imageView.image?.size else { return }
            imageView.image = maskLayer.maskImage(color: .white, size: size)
            guard let image = imageView.image else { return }
            imageView.image = maskLayer.mask(image: image, convertPath: maskLayer.convertPath)
            imageSet()
            maskLayer.clipLayer.isHidden = true
            break
        case .possible:
            break
        case .began:
            maskLayer.clipLayer.isHidden = false
            maskLayer.maskPath(position: position)
            maskLayer.maskConvertPointFromView(viewPoint: position, view: self.view,imageView: imageView,bool:true)
            break
        case .changed:
            maskLayer.path.addLine(to: CGPoint(x: position.x, y: position.y))
            maskLayer.maskConvertPointFromView(viewPoint: position, view: self.view,imageView: imageView,bool:false)
            maskLayer.clipLayer.path = maskLayer.path
            break
        case .cancelled:
            break
        case .failed:
            break
        }
    }

}
