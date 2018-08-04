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
        imageView.image = imageView.image?.ResizeUIImage(width: view.frame.width/2, height: view.frame.height/2)
        imageView.image =  UIImage(named: "IMG_4011")?.mask(image: imageView.image)
        imageView.frame = self.view.frame
        imageView.contentMode = .scaleAspectFit
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.addSubview(imageView)
        view.layer.addSublayer(maskLayer.clipLayer)
    }

    @objc func panTapped(sender:UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: imageView)
        switch sender.state {
        case .ended:
            guard let size = imageView.image?.size else { return }
            imageView.image = maskLayer.maskImage(color: .white, size: size)
            guard let image = imageView.image else { return }
            imageView.image = maskLayer.mask(image: image, convertPath: maskLayer.convertPath)
            imageView.image =  UIImage(named: "IMG_4011")?.mask(image: imageView.image)
            maskLayer.clipLayer.isHidden = true
            break
        case .possible:
            break
        case .began:
            maskLayer.clipLayer.isHidden = false
            maskLayer.path.move(to: CGPoint(x: position.x, y: position.y))
            let convertLocation = maskLayer.convertPointFromView(position, view: self.view,imageView: imageView)
            maskLayer.convertPath.move(to: CGPoint(x: convertLocation.x, y: convertLocation.y))
            break
        case .changed:
            maskLayer.path.addLine(to: CGPoint(x: position.x, y: position.y))
            let convertLocation = maskLayer.convertPointFromView(position, view: self.view,imageView: imageView)
            maskLayer.convertPath.addLine(to: CGPoint(x: convertLocation.x, y: convertLocation.y))
            maskLayer.clipLayer.path = maskLayer.path
            break
        case .cancelled:
            break
        case .failed:
            break
        }
    }
}
