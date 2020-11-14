//
//  MaskGestureViewModel.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2019/11/01.
//

import UIKit

public class MaskGestureViewModel: NSObject, UIGestureRecognizerDelegate {

    public var maskGestureView: UIView?
    public var mLViewModel: MaskingLayerViewModel?

    private var vController: UIViewController?

    public init(mO: MaskingLayerViewModel, vc: UIViewController) {
        super.init()
        maskGestureView = UIView()
        mLViewModel = mO
        vController = vc
        observe(mO)
        desgin(mO: mO)
    }
    
    public func collectionTappedCount(_ bind: @escaping (_ maskLayer: MaskLayer) -> Void) {
        mLViewModel?.observe(for: mLViewModel?.collectionTappedCount ?? MaskObservable()) { _ in
            self.mLViewModel?.collectionTappedCount.initValue()
            bind((self.mLViewModel?.maskLayer.longtappedSelect(mo: self.mLViewModel ?? MaskingLayerViewModel())) ?? MaskLayer(minSegment: 0.0) )
        }
    }

    public func longTappedCount(_ bind: @escaping (_ maskLayer: MaskLayer) -> Void) {
        mLViewModel?.observe(for: mLViewModel?.longTappedCount ?? MaskObservable()) { _ in
            self.mLViewModel?.longTappedCount.initValue()
            bind((self.mLViewModel?.maskLayer.longtappedSelect(mo: self.mLViewModel ?? MaskingLayerViewModel())) ?? MaskLayer(minSegment: 0.0) )
        }
    }

    public func cameraObserve(_ bind: @escaping () -> Void) {
        mLViewModel?.observe(for: mLViewModel?.cameraCount ?? MaskObservable()) { _ in
            self.mLViewModel?.cameraCount.initValue()
            bind()
        }
    }

    private func desgin(mO: MaskingLayerViewModel) {
        mLViewModel = mO
        maskGestureView?.addSubview(mO.imageView ?? UIImageView())
        maskGestureView?.layer.addSublayer(mO.maskLayer.clipLayer)

        MaskGesture.panGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        MaskGesture.panGesture.delegate = self
        maskGestureView?.addGestureRecognizer(MaskGesture.panGesture)

        MaskGesture.longGesture = UILongPressGestureRecognizer(target: self, action:#selector(longTapeed))
        MaskGesture.longGesture.delegate = self
        maskGestureView?.addGestureRecognizer(MaskGesture.longGesture)
    }

    private func observe(_ mO: MaskingLayerViewModel) {
        mLViewModel?.observe(for: mLViewModel?.maskCount ?? MaskObservable()) { _ in
            self.mLViewModel?.maskCount.initValue()
            guard self.mLViewModel?.vm.setVideoURLView.dataArray.count == 0 else {
                self.vController?.view.addSubview( self.mLViewModel?.cView ?? UIView())
                return
            }

            let defo = UserDefaults.standard
            guard defo.object(forKey: "url") == nil else {

                self.mLViewModel?.maskPortraitMatte(minSegment: 15)
                if self.mLViewModel?.imageBackView?.image == nil {
                    mO.backImageCount.value = 0
                } else {
                    self.mLViewModel?.gousei()
                }
                return
            }
        }

        mLViewModel?.observe(for: mLViewModel?.backImageCount ?? MaskObservable()) { _ in
            self.mLViewModel?.backImageCount.initValue()
            self.mLViewModel?.imageBackView = UIImageView()
            self.mLViewModel?.imageBackView?.image = self.mLViewModel?.imageView?.image
            self.mLViewModel?.imageBackView?.frame = self.mLViewModel?.imageView?.frame ?? CGRect()
            self.mLViewModel?.imageBackView?.setNeedsLayout()
        }
    
    }

    @objc func panTapped(sender: UIPanGestureRecognizer) { mLViewModel?.panTapped(sender: sender) }

    @objc func longTapeed(sender:UILongPressGestureRecognizer) { mLViewModel?.longTapeed(sender: sender) }

}
