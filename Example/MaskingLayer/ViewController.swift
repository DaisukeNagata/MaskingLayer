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
    static var longGesture = UILongPressGestureRecognizer()
}

class ViewController: UIViewController,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var imageView = UIImageView()
    let maskLayer = MaskLayer()
    var image = UIImage()


    override func viewDidLoad() {
        super.viewDidLoad()

        CommonStructure.panGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.panGesture.delegate = self
        view.addGestureRecognizer( CommonStructure.panGesture)

        CommonStructure.tapGesture = UITapGestureRecognizer(target: self, action:#selector(tapped))
        CommonStructure.tapGesture.delegate = self
        view.addGestureRecognizer( CommonStructure.tapGesture)

        CommonStructure.longGesture = UILongPressGestureRecognizer(target: self, action:#selector(longTapeed))
        CommonStructure.longGesture.delegate = self
        view.addGestureRecognizer( CommonStructure.longGesture)

        image = UIImage(named: "IMG_4011")!
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        view.addSubview(imageView)
        maskLayer.imageSet(view: self.view, imageView: self.imageView, image: self.image)
    }

    @objc func panTapped(sender:UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: imageView)
        switch sender.state {
        case .ended:
            guard let size = imageView.image?.size else { return }
            imageView.image = maskLayer.maskImage(color: maskLayer.maskClor, size: size, convertPath: maskLayer.convertPath)
            maskLayer.imageSet(view: self.view, imageView: imageView, image: image)
            break
        case .possible:
            break
        case .began:
            maskLayer.maskPath(position: position)
            maskConerPath(position: position, bool: true)
            break
        case .changed:
            maskLayer.maskAddLine(position: position)
            maskConerPath(position: position, bool: false)
            break
        case .cancelled:
            break
        case .failed:
            break
        }
    }

    func maskConerPath(position: CGPoint, bool: Bool) { maskLayer.maskConvertPointFromView(viewPoint: position, view: self.view,imageView: imageView,bool:bool) }

    @objc func tapped(sender:UITapGestureRecognizer) { maskLayer.imageReSet(view: self.view, imageView: imageView, image: image) }
    @objc func longTapeed(sender:UILongPressGestureRecognizer) { maskLayer.alertSave(views: self, imageView: imageView, image: image) }
}

extension ViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        maskLayer.imageReSet(view: self.view, imageView: imageView, image: image)
        image = UIImage()
        imageView = UIImageView()
        guard let images = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        image = images
        picker.dismiss(animated: true, completion: nil)
    }
}
