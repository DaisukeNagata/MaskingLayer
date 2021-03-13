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
    

    private var maskingModelView: MaskingLayerModelView?
    private var mo: MaskingLayerViewModel?
    private var mv: MaskGestureViewModel?
    private var masklayer: MaskLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        maskingModelView = MaskingLayerModelView(windowSizeWidth: 100,
                                          windowSizeHeight: 50,
                                          windowColor: UIColor.red,
                                          windowAlpha: 0.5,
                                          imageView: UIImageView(frame: view.frame),
                                          image: UIImage(named: "IMG_4011")!,
                                          minSegment: 15)
        
        maskingModelView?.mv?.maskGestureView?.frame = view.frame
        view.addSubview(maskingModelView?.mv?.maskGestureView ?? UIView())

        maskingModelView?.mv?.cameraObserve {
            let storyboard: UIStoryboard = UIStoryboard(name: "Camera", bundle: nil)
            let next: UIViewController = storyboard.instantiateInitialViewController() as! CameraViewController
            self.navigationController?.pushViewController(next, animated: true)
        }

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Alert", style: .done, target: self, action: #selector(callAlert))
    }

    @objc func callAlert() {
        guard let modelView = maskingModelView else { return }
        self.alertSave(modelView: modelView)
    }
}
