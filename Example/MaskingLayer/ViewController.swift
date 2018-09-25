//
//  ViewController.swift
//  MaskingLayer
//
//  Created by daisukenagata on 08/04/2018.
//  Copyright (c) 2018 daisukenagata. All rights reserved.
//

import UIKit
import MaskingLayer
import SVProgressHUD
import MobileCoreServices

struct CommonStructure {
    static var panGesture = UIPanGestureRecognizer()
    static var longGesture = UILongPressGestureRecognizer()
}

class ViewController: UIViewController,UIGestureRecognizerDelegate, UIScrollViewDelegate {

    var mO = MaskNavigationObject()

    let defo = UserDefaults.standard
    var url: URL?
    override func viewDidLoad() {
        super.viewDidLoad()

        CommonStructure.panGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.panGesture.delegate = self
        view.addGestureRecognizer(CommonStructure.panGesture)

        CommonStructure.longGesture = UILongPressGestureRecognizer(target: self, action:#selector(longTapeed))
        CommonStructure.longGesture.delegate = self
        view.addGestureRecognizer(CommonStructure.longGesture)

        mO.image = UIImage(named: "IMG_4011")!.ResizeUIImage(width: view.frame.width, height: view.frame.height)
        mO.imageView.image = UIImage(named: "IMG_4011")!.ResizeUIImage(width: view.frame.width, height: view.frame.height)
        mO.imageView.frame = view.frame
        view.addSubview(mO.imageView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        view.addSubview(mO.imageView)
        view.layer.addSublayer(mO.maskLayer.clipLayer)
        guard mO.vm.setVideoURLView.dataArray.count == 0 else {
            view.addSubview(mO.cView)
            return
        }
        if #available(iOS 12.0, *) {
            guard defo.object(forKey: "url") == nil else {
                let maskPortraitMatte = MaskPortraitMatte()
                maskPortraitMatte.portraitMatte(imageV: mO.imageView, vc: self)
                mO.imageView.image! = mO.imageView.image!.ResizeUIImage(width: view.frame.width, height: view.frame.height)
                mO.image = mO.imageView.image!
                return
            }
        }
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
    @objc func longTapeed(sender:UILongPressGestureRecognizer) { mO.maskLayer.alertSave(views: self, imageView: mO.imageView, image: mO.image) }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if #available(iOS 12.0, *) {
            url = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.imageURL)] as? URL
            defo.set(url, forKey: "url")
        }
        SVProgressHUD.show()

        let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as! NSString
        if mediaType == kUTTypeMovie {
            self.mO.setURL(url: info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as! URL, vc: self)

            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                self.mO.maskGif()
                SVProgressHUD.dismiss()
                picker.dismiss(animated: true, completion: nil)
                return
            }
        } else {
            guard let images = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage) else { return }
            mO.image = images.ResizeUIImage(width: view.frame.width, height: view.frame.height)
            SVProgressHUD.dismiss()
            picker.dismiss(animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        mO.imageView = UIImageView()
        picker.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
