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

    override func viewDidLoad() {
        super.viewDidLoad()

        CommonStructure.panGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.panGesture.delegate = self
        view.addGestureRecognizer(CommonStructure.panGesture)
        
        CommonStructure.longGesture = UILongPressGestureRecognizer(target: self, action:#selector(longTapeed))
        CommonStructure.longGesture.delegate = self
        view.addGestureRecognizer(CommonStructure.longGesture)
        
        mO.imageResize(images: UIImage(named: "IMG_4011")!)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        view.addSubview(mO.imageView)
        view.layer.addSublayer(mO.maskLayer.clipLayer)
        mO.tapped(view: mO.imageView)
    
        guard mO.vm.setVideoURLView.dataArray.count == 0 else { view.addSubview(mO.cView); return }

        let defo = UserDefaults.standard
        guard defo.object(forKey: "url") == nil else { mO.maskPortraitMatte(); return }
    }

    @objc func panTapped(sender: UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: mO.imageView)
        switch sender.state {
        case .ended:
            mO.tapped(view: mO.imageView)
            break
        case .possible:
            break
        case .began:
            mO.maskPath(position: position, imageView: mO.imageView)
            break
        case .changed:
            mO.maskAddLine(position: position, imageView: mO.imageView)
            break
        case .cancelled:
            break
        case .failed:
            break
        }
    }

    @objc func longTapeed(sender:UILongPressGestureRecognizer) {
        mO.maskLayer.alertSave(views: self, imageView: mO.imageView, image: mO.image)
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        let defo = UserDefaults.standard
        defo.set(info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.imageURL)] as? URL, forKey: "url")

        SVProgressHUD.show()
        mO.resetCView()

        let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as! NSString
        if mediaType == kUTTypeMovie {
            defo.set(info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? URL, forKey: "url")
            self.mO.setURL()

            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.mO.maskGif()
                SVProgressHUD.dismiss()
                picker.dismiss(animated: true, completion: nil)
                return
            }
        } else {
            guard let images = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage) else { return }
            mO.imageResize(images: images)
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
