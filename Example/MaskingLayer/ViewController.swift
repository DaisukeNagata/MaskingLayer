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
    
    private lazy var cView: ColorPaletteView = {
        let cView = ColorPaletteView()
        return cView
    }()

    private var mo: MaskingLayerViewModel?
    private var mv: MaskGestureViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        mo = MaskingLayerViewModel(minSegment: 15)
        guard let mo = mo else { return }
        mv = MaskGestureViewModel(mO: mo, vc: self)
        guard let mv = mv else { return }
        mv.maskGestureView?.frame = view.frame
        view.addSubview(mv.maskGestureView ?? UIView())

        mo.frameResize(images: UIImage(named: "IMG_4011")!, rect: view.frame)

        mv.cameraObserve {
            let storyboard: UIStoryboard = UIStoryboard(name: "Camera", bundle: nil)
            let next: UIViewController = storyboard.instantiateInitialViewController() as! CameraViewController
            self.navigationController?.pushViewController(next, animated: true)
        }

        mv.longTappedCount { maskLayer in
            self.alertSave(maskLayer, mo: self.mo!)
        }

        cView.collectionView.delegate = self
        view.addSubview(cView)
        self.cView.isHidden = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "色", style: .done, target: self, action: #selector(addTapped))
    }

    @objc func addTapped() { self.cView.isHidden = false }
}

// MARK: UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {

    func ovserve(index: Int) {
        mv?.collectionTappedCount { maskLayer in
            self.cView.isHidden = true
            maskLayer.colorSet(imageView: self.mo?.imageView ?? UIImageView(),
                               color    : self.cView.vm.imagesRows[index].imageSet)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ovserve(index: indexPath.row)
        mv?.mLViewModel?.collectionTapped(index: indexPath.row)
    }
}
