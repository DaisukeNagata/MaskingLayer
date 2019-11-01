//
//  ViewController.swift
//  MaskingLayer
//
//  Created by daisukenagata on 08/04/2018.
//  Copyright (c) 2018 daisukenagata. All rights reserved.
//

import UIKit
import MaskingLayer
import MobileCoreServices

class ViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    var mO = MaskingLayerViewModel(minSegment: 15)

    override func viewDidLoad() {
        super.viewDidLoad()

        let maskGestureView = MaskGestureView(mO: mO)
        maskGestureView.frame = view.frame
        mO.frameResize(images: UIImage(named: "IMG_4011")!)

        view.addSubview(maskGestureView)
        view.addSubview(mO.imageView)
        view.layer.addSublayer(mO.maskLayer.clipLayer)

        mO.masPathSet()

        mO.observe(for: mO.maskCount) { _ in
            self.mO.maskCount.initValue()
            guard self.mO.vm.setVideoURLView.dataArray.count == 0 else {  self.view.addSubview( self.mO.cView); return }

            let defo = UserDefaults.standard
            guard defo.object(forKey: "url") == nil else {

                self.mO.maskPortraitMatte(minSegment: 15)
                if self.mO.imageBackView.image != nil { self.mO.gousei() }
                return
            }
        }

        mO.observe(for: mO.longTappedCount) { _ in
            self.mO.longTappedCount.initValue()
            self.mO.maskLayer.alertSave(views: self,mo: self.mO)
        }

        mO.observe(for: mO.backImageCount) { _ in
            self.mO.backImageCount.initValue()
            self.mO.imageBackView.image = self.mO.imageView.image
            self.mO.imageBackView.frame = self.mO.imageView.frame
            self.mO.imageBackView.setNeedsLayout()
        }
    }
}
