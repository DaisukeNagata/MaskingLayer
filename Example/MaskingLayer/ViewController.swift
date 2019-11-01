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

    var mO = MaskingLayerViewModel(minSegment: 15)

    override func viewDidLoad() {
        super.viewDidLoad()

        let maskGestureView = MaskGestureView(mO: mO)
        maskGestureView.frame = view.frame
        mO.frameResize(images: UIImage(named: "IMG_4011")!)

        view.addSubview(maskGestureView)
        view.addSubview(mO.imageView)
        view.layer.addSublayer(mO.maskLayer.clipLayer)

        mO.maskPathSet()

        maskGestureView.observe(self, mO: mO)
    }
}
