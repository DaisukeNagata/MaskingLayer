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
            maskLayer.maskImagePicker.photoSegue(vc: self, mo: mo,bool: false)
        }
        let videoRoll = UIAlertAction(title: NSLocalizedString("VideoRoll ", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            maskLayer.maskImagePicker.photoSegue(vc: self, mo: mo, bool: true)
        }
        let trimUI = UIAlertAction(title: NSLocalizedString("TrimUI", comment: ""), style: .default) {
            action in
            maskLayer.trimLayer(mo: mo)
            alertController.dismiss(animated: true, completion: nil)
        }
        
        let trimMask = UIAlertAction(title: NSLocalizedString("TrimMask", comment: ""), style: .default) {
            action in
            guard let imageView = mo.imageView else { return }
            mo.imageMask(imageView: imageView)
            alertController.dismiss(animated: true, completion: nil)
        }
        let dyeHair = UIAlertAction(title: NSLocalizedString("DyeHair", comment: ""), style: .default) {
            action in            
            alertController.dismiss(animated: true, completion: { maskLayer.cameraSelect(mo: mo) })
        }
        let reset = UIAlertAction(title: NSLocalizedString("ReSet ", comment: ""), style: .default) {
            action in
            maskLayer.maskLayer()
            maskLayer.mutablePathSet(mo: mo)
            alertController.dismiss(animated: true, completion: nil)
        }
        mo.imageView?.setNeedsLayout()
        alertController.addAction(cameraRoll)
        alertController.addAction(videoRoll)
        alertController.addAction(trimUI)
        alertController.addAction(trimMask)
        alertController.addAction(dyeHair)
        alertController.addAction(reset)
        self.present(alertController, animated: true, completion: nil)
    }
}
