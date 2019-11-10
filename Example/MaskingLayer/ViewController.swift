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

    static func identifier() -> String { return String(describing: ViewController.self) }

    static func viewController() -> ViewController {

        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! ViewController
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let mO = MaskingLayerViewModel(minSegment: 15)
        let MV = MaskGestureViewModel(mO: mO, vc: self)
        MV.maskGestureView?.frame = view.frame
        view.addSubview(MV.maskGestureView ?? UIView())
        
        // this is navi+tab - view.frame
        var rect = view.frame
        rect.origin.y = 84
        rect.size.height -= 184
        
        mO.frameResize(images: UIImage(named: "IMG_4011")!, rect: rect)
        
        MV.cameraObserve {
            let storyboard: UIStoryboard = UIStoryboard(name: "Camera", bundle: nil)
            let next: UIViewController = storyboard.instantiateInitialViewController() as! CameraViewController
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
}
