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
        let alertController = UIAlertController(title: NSLocalizedString("Camera Option", comment: ""), message: "", preferredStyle: .alert)
        let cameraRoll = UIAlertAction(title: NSLocalizedString("CameraRoll ", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            maskLayer.mutablePathSet(mo: mo)
            maskLayer.maskImagePicker.photoSegue(vc: self, mo: mo,bool: false)
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
        alertController.addAction(videoRoll)
        alertController.addAction(dyeHair)
        alertController.addAction(reset)
        self.present(alertController, animated: true, completion: nil)
    }
}
