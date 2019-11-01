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

struct CommonStructure {
    static var panGesture = UIPanGestureRecognizer()
    static var longGesture = UILongPressGestureRecognizer()
}

class ViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    var mO = MaskingLayerViewModel(minSegment: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CommonStructure.panGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.panGesture.delegate = self
        view.addGestureRecognizer(CommonStructure.panGesture)
        
        CommonStructure.longGesture = UILongPressGestureRecognizer(target: self, action:#selector(longTapeed))
        CommonStructure.longGesture.delegate = self
        view.addGestureRecognizer(CommonStructure.longGesture)
        mO.frameResize(images: UIImage(named: "IMG_4011")!)
        view.addSubview(mO.imageView)
        view.layer.addSublayer(mO.maskLayer.clipLayer)

        mO.maskLayer.maskColor = .clear
        mO.maskPathEnded(position: CGPoint(), view: mO.imageView)
        mO.maskLayer.maskColor = .white

        mO.observe(for: mO.maskCount) { _ in
            guard self.mO.vm.setVideoURLView.dataArray.count == 0 else {  self.view.addSubview( self.mO.cView); return }

            let defo = UserDefaults.standard
            guard defo.object(forKey: "url") == nil else {

                self.mO.maskPortraitMatte(minSegment: 15)
                if self.mO.imageBackView.image != nil {  self.mO.gousei() }
                return
            }
        }
    }

    @objc func panTapped(sender: UIPanGestureRecognizer) { mO.panTapped(sender: sender) }

    @objc func longTapeed(sender:UILongPressGestureRecognizer) { mO.longTapeed(bind: binding, sender: sender) }
    
    func binding() { mO.maskLayer.alertSave(views: self,mo: mO) }
}
