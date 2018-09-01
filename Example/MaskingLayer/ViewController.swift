//
//  ViewController.swift
//  MaskingLayer
//
//  Created by daisukenagata on 08/04/2018.
//  Copyright (c) 2018 daisukenagata. All rights reserved.
//

import UIKit
import SVProgressHUD
import MaskingLayer
import MobileCoreServices

struct CommonStructure {
    static var panGesture = UIPanGestureRecognizer()
    static var longGesture = UILongPressGestureRecognizer()
}

class ViewController: UIViewController,UIGestureRecognizerDelegate, UIScrollViewDelegate {

    var mO = MaskNavigationObject()

    override func viewDidLoad() {
        super.viewDidLoad()

        CommonStructure.panGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.panGesture.delegate = self
        view.addGestureRecognizer(CommonStructure.panGesture)

        CommonStructure.longGesture = UILongPressGestureRecognizer(target: self, action:#selector(longTapeed))
        CommonStructure.longGesture.delegate = self
        view.addGestureRecognizer(CommonStructure.longGesture)

        mO.image = UIImage(named: "IMG_4011")!
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        view.addSubview(mO.imageView)
        guard mO.vm.setVideoURLView.dataArray.count == 0 else {
            view.addSubview(mO.cView)
            view.layer.addSublayer(mO.maskLayer.clipLayer)
            return
        }
        mO.maskLayer.imageSet(view: view, imageView: mO.imageView, image: mO.image)
    }

    @objc func panTapped(sender:UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: mO.imageView)
        switch sender.state {
        case .ended:
            mO.tappedEnd(view: view)
            break
        case .possible:
            break
        case .began:
            mO.maskPath(position: position, view: view, imageView: mO.imageView, bool: true)
            break
        case .changed:
            mO.maskAddLine(position: position, view: view, imageView: mO.imageView, bool: false)
            break
        case .cancelled:
            break
        case .failed:
            break
        }
    }

    @objc func longTapeed(sender:UILongPressGestureRecognizer) { mO.vm = MaskCollectionViewModel(); mO.maskLayer.alertSave(views: self, imageView: mO.imageView, image: mO.image) }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        SVProgressHUD.show()
        mO.resetCView(views: self, imageView: mO.imageView, image: mO.image)
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType == kUTTypeMovie {
            self.mO.setURL(url: info[UIImagePickerControllerMediaURL] as! URL, vc: self)
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                self.mO.maskGif(url: info[UIImagePickerControllerMediaURL] as! URL)
                SVProgressHUD.dismiss()
                picker.dismiss(animated: true, completion: nil)
                return
            }
        } else {
            mO.imageView = UIImageView()
            guard let images = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
            mO.image = images
            SVProgressHUD.dismiss()
            picker.dismiss(animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        mO.imageView = UIImageView()
        picker.dismiss(animated: true, completion: nil)
    }
}
