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
    static var panGesture = UIPanGestureRecognizer()
    static var tapGesture = UITapGestureRecognizer()
    static var longPanGesture = UILongPressGestureRecognizer()
}

class ViewController: UIViewController,UIGestureRecognizerDelegate {

    let imageView = UIImageView()
    let maskLayer = MaskLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        CommonStructure.panGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.panGesture.delegate = self
        view.addGestureRecognizer( CommonStructure.panGesture)

        CommonStructure.tapGesture = UITapGestureRecognizer(target: self, action:#selector(tapped))
        CommonStructure.tapGesture.delegate = self
        view.addGestureRecognizer( CommonStructure.tapGesture)

        CommonStructure.longPanGesture = UILongPressGestureRecognizer(target: self, action:#selector(longtapped))
        CommonStructure.longPanGesture.delegate = self
        view.addGestureRecognizer( CommonStructure.longPanGesture)

        view.backgroundColor = UIColor.black
        maskLayer.imageSet(view: self.view, imageView: imageView, name: "IMG_4011")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(imageView)
        view.layer.addSublayer(maskLayer.clipLayer)
        btCreative()
    }

    func btCreative() {
        let bt = UIButton()
        bt.frame = CGRect(x: UIScreen.main.bounds.width/2 - 50, y: UIScreen.main.bounds.height-100,
                          width: 100, height: 100)
        view.addSubview(bt)
        bt.addTarget(self, action: #selector(loadBt), for: .touchUpInside)
        bt.setTitle("load", for: .normal)
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

    @objc func tapped(sender:UITapGestureRecognizer) {
        maskLayer.imageReSet(view: self.view, imageView: imageView, name: "IMG_4011")
    }

    @objc func longtapped(sender:UILongPressGestureRecognizer) {
        maskLayer.imageSave(views: self, image: imageView.image!, name: "IMG_4011")
    }

    @objc func loadBt(_ sender: UIButton) {
        maskLayer.imageLoad(imageView: imageView, name: "IMG_4011")
    }

}
