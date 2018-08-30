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
    static var tapGesture = UITapGestureRecognizer()
    static var longGesture = UILongPressGestureRecognizer()
}

class ViewController: UIViewController,UIGestureRecognizerDelegate {

    var data = Data()
    var image = UIImage()
    var imageView = UIImageView()
    let maskLayer = MaskLayer()
    var gifObject = GifObject()
    var setVideoURLView = SetVideoURLView()


    override func viewDidLoad() {
        super.viewDidLoad()

        CommonStructure.panGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.panGesture.delegate = self
        view.addGestureRecognizer(CommonStructure.panGesture)

        CommonStructure.tapGesture = UITapGestureRecognizer(target: self, action:#selector(tapped))
        CommonStructure.tapGesture.delegate = self
        view.addGestureRecognizer(CommonStructure.tapGesture)

        CommonStructure.longGesture = UILongPressGestureRecognizer(target: self, action:#selector(longTapeed))
        CommonStructure.longGesture.delegate = self
        view.addGestureRecognizer(CommonStructure.longGesture)

        image = UIImage(named: "IMG_4011")!
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

//        self.view.addSubview( self.imageView)
        self.imageView.animateGIF(data: data, duration: Double(2)) {
            guard let image = UIImage(data: self.data) else { return }
            self.imageView.image = image
        }
        maskLayer.imageSet(view: self.view, imageView: self.imageView, image: self.image)
    }

    @objc func panTapped(sender:UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: imageView)
        switch sender.state {
        case .ended:
            guard let size = imageView.image?.size else { return }
            imageView.image = maskLayer.maskImage(color: maskLayer.maskClor, size: size, convertPath: maskLayer.convertPath)
            maskLayer.imageSet(view: self.view, imageView: self.imageView, image: self.image)
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
    @objc func tapped(sender:UITapGestureRecognizer) {
        guard UIImage(data: self.data) == nil else {
            imageView.animateGIF(data: data, duration: Double(2)) { }
            return
        }
        maskLayer.imageReSet(view: self.view, imageView: imageView, image: image)
    }
    @objc func longTapeed(sender:UILongPressGestureRecognizer) { maskLayer.alertSave(views: self, imageView: imageView, image: image) }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        maskLayer.imageReSet(view: self.view, imageView: imageView, image: image)
        SVProgressHUD.show()
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType == kUTTypeMovie {
            setVideoURLView.setURL(url: info[UIImagePickerControllerMediaURL] as! URL, view: self)
            setVideoURLView.frame = CGRect(x:0,y:0,width: self.view.frame.width, height: self.view.frame.width/15)
            view.addSubview(setVideoURLView.imageView)
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                picker.dismiss(animated: true, completion: nil)
                for _ in 0..<self.setVideoURLView.thumbnailViews.count {
                    do {
                        self.data  = try Data(contentsOf: (self.gifObject.makeGifImageMovie(url: info[UIImagePickerControllerMediaURL] as! URL,frameY: 10.0, createBool: true, scale: 10.0, imageAr: (self.setVideoURLView.imageAr))))
                        self.image = UIImage()
                    } catch {
                    }
                }
                SVProgressHUD.dismiss()
                return
            }
        }
        data = Data()
        image = UIImage()
        imageView = UIImageView()
        guard let images = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        image = images
        SVProgressHUD.dismiss()
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageView = UIImageView()
        picker.dismiss(animated: true, completion: nil)
    }
}
