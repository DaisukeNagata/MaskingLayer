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

    func alertSave(modelView: MaskingLayerModelView) {
        let alertController = UIAlertController(title: NSLocalizedString("Camera Option", comment: ""), message: "", preferredStyle: .alert)
        let cameraRoll = UIAlertAction(title: NSLocalizedString("CameraRoll ", comment: ""), style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            modelView.mLViewModel?.maskLayer?.maskImagePicker.photoSegue(vc: self, mo: modelView, bool: false)
        }
        let trimUI = UIAlertAction(title: NSLocalizedString("TrimUI", comment: ""), style: .default) {
            action in
            modelView.mLViewModel?.maskLayer?.strokeColor = .red
            modelView.mLViewModel?.maskLayer?.strokeALpha = 0.5
            modelView.mLViewModel?.maskLayer?.trimLayer(modelView: modelView)
            alertController.dismiss(animated: true, completion: nil)
        }
        
        let trimUIWindow = UIAlertAction(title: NSLocalizedString("TrimUIWindow", comment: ""), style: .default) {
            action in
            modelView.mv?.pinchAndTapGesture()
            modelView.desginInit()
            alertController.dismiss(animated: true, completion: nil)
        }

        let trimMask = UIAlertAction(title: NSLocalizedString("TrimMask", comment: ""), style: .default) {
            action in
            guard let imageView = modelView.maskModel?.imageView else { return }
            modelView.maskModel?.windowFrameView == nil ?
                modelView.mLViewModel?.imageMask(imageView: imageView) :
                modelView.mLViewModel?.lockImageMask(imageView: imageView,
                                                     windowFrameView: modelView.maskModel?.windowFrameView ?? UIImageView())
            alertController.dismiss(animated: true, completion: nil)
        }
        let dyeHair = UIAlertAction(title: NSLocalizedString("DyeHair", comment: ""), style: .default) {
            action in            
            alertController.dismiss(animated: true, completion: { modelView.mLViewModel?.maskLayer?.cameraSelect(mo: modelView.mLViewModel) })
        }
        let reset = UIAlertAction(title: NSLocalizedString("ReSet ", comment: ""), style: .default) {
            action in
            modelView.mLViewModel?.maskLayer?.maskLayer()
            modelView.mLViewModel?.maskLayer?.mutablePathSet(modelView: modelView)
            alertController.dismiss(animated: true, completion: nil)
        }
        modelView.maskModel?.imageView.setNeedsLayout()
        alertController.addAction(cameraRoll)
        alertController.addAction(trimUI)
        alertController.addAction(trimUIWindow)
        alertController.addAction(trimMask)
        alertController.addAction(dyeHair)
        alertController.addAction(reset)
        self.present(alertController, animated: true, completion: nil)
    }
}
