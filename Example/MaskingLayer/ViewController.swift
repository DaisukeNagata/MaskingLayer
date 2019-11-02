//
//  ViewController.swift
//  MaskingLayer
//
//  Created by daisukenagata on 08/04/2018.
//  Copyright (c) 2018 daisukenagata. All rights reserved.
//

import UIKit
import MaskingLayer

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mO = MaskingLayerViewModel(minSegment: 15)
        let MV = MaskGestureViewModel(mO: mO, vc: self)
        MV.maskGestureView?.frame = view.frame
        view.addSubview(MV.maskGestureView ?? UIView())

        mO.frameResize(images: UIImage(named: "IMG_4011")!)
    }
}
