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

        mo.maskLayer.strokeColor = .red
        mo.maskLayer.strokeALpha = 0.5

        mo.windowSizeWidth = 100
        mo.windowSizeHeight = 50
        mo.windowColor = UIColor.red
        mo.windowAlpha = 0.5

        mv.cameraObserve {
            let storyboard: UIStoryboard = UIStoryboard(name: "Camera", bundle: nil)
            let next: UIViewController = storyboard.instantiateInitialViewController() as! CameraViewController
            self.navigationController?.pushViewController(next, animated: true)
        }

        cView.collectionView.delegate = self
        view.addSubview(cView)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "color", style: .done, target: self, action: #selector(addTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Alert", style: .done, target: self, action: #selector(callAlert))
    }

    @objc func addTapped() {
        self.navigationController?.navigationBar.isHidden = true
        self.cView.animation()
    }

    @objc func callAlert() {
        guard let maskLayer = mo?.maskLayer, let mo = mo, let mv = mv else { return }
        self.alertSave(maskLayer, mo: mo, mv: mv)
    }
}

// MARK: UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {

    func observe(index: Int) {
        mv?.collectionTappedCount { maskLayer in
            maskLayer.colorSet(imageView: self.mo?.imageView ?? UIImageView(),
                               color    : self.cView.vm.imagesRows[index].imageSet)
            self.cView.transform = .identity
            self.cView.collectionView.transform = .identity
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        observe(index: indexPath.row)
        mv?.mLViewModel?.collectionTapped()
        self.navigationController?.navigationBar.isHidden = false
    }
}
