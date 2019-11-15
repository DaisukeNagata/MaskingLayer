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
    
    private var mO: MaskingLayerViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        mO = MaskingLayerViewModel(minSegment: 15)
        guard let mO = mO else { return }
        let MV = MaskGestureViewModel(mO: mO, vc: self)
        MV.maskGestureView?.frame = view.frame
        view.addSubview(MV.maskGestureView ?? UIView())

        mO.frameResize(images: UIImage(named: "IMG_4011")!, rect: view.frame)

        MV.cameraObserve {
            let storyboard: UIStoryboard = UIStoryboard(name: "Camera", bundle: nil)
            let next: UIViewController = storyboard.instantiateInitialViewController() as! CameraViewController
            self.navigationController?.pushViewController(next, animated: true)
        }

        MV.longTappedCount { maskLayer in
            self.alertSave(maskLayer, mo: mO)
        }
    }
}
