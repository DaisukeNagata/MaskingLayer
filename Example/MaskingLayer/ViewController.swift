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
    static var tapPanGesture = UITapGestureRecognizer()
}

class ViewController: UIViewController,UIGestureRecognizerDelegate {

    let imageView = UIImageView()
    let maskLayer = MaskLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        CommonStructure.swipePanGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.swipePanGesture.delegate = self
        view.addGestureRecognizer( CommonStructure.swipePanGesture)
        CommonStructure.tapPanGesture = UITapGestureRecognizer(target: self, action:#selector(tapped))
        CommonStructure.tapPanGesture.delegate = self
        view.addGestureRecognizer( CommonStructure.tapPanGesture)
        view.backgroundColor = UIColor.black
        maskLayer.imageSet(view: self.view, imageView: imageView, name: "IMG_4011")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.addSubview(imageView)
        view.layer.addSublayer(maskLayer.clipLayer)
    }
    @objc func tapped(sender:UITapGestureRecognizer) {
        maskLayer.imageReSet(view: self.view, imageView: imageView, name: "IMG_4011")
    }

    @objc func panTapped(sender:UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: imageView)
        switch sender.state {
        case .ended:
            guard let size = imageView.image?.size else { return }
            imageView.image = maskLayer.maskImage(color: .white, size: size)
            guard let image = imageView.image else { return }
            imageView.image = maskLayer.mask(image: image, convertPath: maskLayer.convertPath)
            maskLayer.imageSet(view: self.view, imageView: imageView, name: "IMG_4011")
            break
        case .possible:
            break
        case .began:
            maskLayer.maskPath(position: position)
            maskLayer.maskConvertPointFromView(viewPoint: position, view: self.view,imageView: imageView,bool:true)
            break
        case .changed:
            maskLayer.maskAddLine(position: position)
            maskLayer.maskConvertPointFromView(viewPoint: position, view: self.view,imageView: imageView,bool:false)
            break
        case .cancelled:
            break
        case .failed:
            break
        }
    }

}
