//
//  ViewController+Extension.swift
//  MaskingLayer_Example
//
//  Created by 永田大祐 on 2019/11/15.
//  Copyright © 2019 CocoaPods. All rights reserved.
//
import UIKit
import MaskingLayer

extension ViewController {

    func alertSave(_ maskLayer: MaskLayer, mo: MaskingLayerViewModel) {
        let alertController = UIAlertController(title: NSLocalizedString("BackGround Color", comment: ""), message: "", preferredStyle: .alert)
        let cameraRoll = UIAlertAction(title: NSLocalizedString("CameraRoll ", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            maskLayer.mutablePathSet(mo: mo)
            maskLayer.maskImagePicker.photoSegue(vc: self, mo: mo,bool: false)
        }
        let backImage = UIAlertAction(title: NSLocalizedString("BackImage ", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            maskLayer.alertPortrait(views: self, mO: mo)
        }
        let videoRoll = UIAlertAction(title: NSLocalizedString("VideoRoll ", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            maskLayer.mutablePathSet(mo: mo)
            maskLayer.maskImagePicker.photoSegue(vc: self, mo: mo, bool: true)
        }
        let dyeHair = UIAlertAction(title: NSLocalizedString("DyeHair", comment: ""), style: .default) {
            action in
            maskLayer.mutablePathSet(mo: mo)
            
            alertController.dismiss(animated: true, completion: { maskLayer.cameraSelect(mo: mo) })
        }
        let reset = UIAlertAction(title: NSLocalizedString("ReSet ", comment: ""), style: .default) {
            action in
            maskLayer.mutablePathSet(mo: mo)
            alertController.dismiss(animated: true, completion: nil)
        }
        mo.imageView?.setNeedsLayout()
        alertController.addAction(cameraRoll)
        alertController.addAction(backImage)
        alertController.addAction(videoRoll)
        alertController.addAction(dyeHair)
        alertController.addAction(reset)
        self.present(alertController, animated: true, completion: nil)
    }
}

/*
 //        let stringAttributes: [NSAttributedString.Key : Any] = [
 //            .foregroundColor : UIColor(red: 0/255, green: 136/255, blue: 83/255, alpha: 1.0),
 //            .font : UIFont.systemFont(ofSize: 22.0)
 //        ]
 //        let string = NSAttributedString(string: alertController.title!, attributes:stringAttributes)
 //        alertController.setValue(string, forKey: "attributedTitle")
 // guard let imageView = mo.imageView else { return }
 alertController.addAction(maskWhite)
 alertController.addAction(maskLightGray)
 alertController.addAction(maskGray)
 alertController.addAction(maskDarkGray)
 alertController.addAction(maskLightBlack)
 let string = NSAttributedString(string: alertController.title!, attributes:stringAttributes)
 alertController.setValue(string, forKey: "attributedTitle")
 alertController.view.tintColor = UIColor(red: 0/255, green: 136/255, blue: 83/255, alpha: 1.0)
 
 let maskWhite = UIAlertAction(title: NSLocalizedString("MaskWhite", comment: ""), style: .default) {
 action in
 alertController.dismiss(animated: true, completion: nil)
 maskLayer.maskColor = .maskWhite; maskLayer.colorSet(imageView: imageView, image: mo.image, color: maskLayer.maskColor)
 }
 let maskLightGray = UIAlertAction(title: NSLocalizedString("MaskLightGray", comment: ""), style: .default) {
 action in
 alertController.dismiss(animated: true, completion: nil)
 maskLayer.maskColor = .maskLightGray; maskLayer.colorSet(imageView: imageView, image: mo.image, color: maskLayer.maskColor)
 }
 let maskGray = UIAlertAction(title: NSLocalizedString("MaskGray", comment: ""), style: .default) {
 action in
 alertController.dismiss(animated: true, completion: nil)
 maskLayer.maskColor = .maskGray; maskLayer.colorSet(imageView: imageView, image: mo.image, color: maskLayer.maskColor)
 }
 let maskDarkGray = UIAlertAction(title: NSLocalizedString("MaskDarkGray", comment: ""), style: .default) {
 action in
 alertController.dismiss(animated: true, completion: nil)
 maskLayer.maskColor = .maskDarkGray; maskLayer.colorSet(imageView: imageView, image: mo.image, color: maskLayer.maskColor)
 }
 let maskLightBlack = UIAlertAction(title: NSLocalizedString("MaskLightBlack", comment: ""), style: .default) {
 action in
 alertController.dismiss(animated: true, completion: nil)
 maskLayer.maskColor = .maskLightBlack; maskLayer.colorSet(imageView: imageView, image: mo.image, color: maskLayer.maskColor)
 }
 */
