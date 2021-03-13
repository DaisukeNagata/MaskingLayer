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
    public var modelView: MaskingLayerModelView?

    public init(mo: MaskingLayerViewModel, modelView: MaskingLayerModelView?) {
        super.init()
        maskGestureView = UIView()
        self.modelView = modelView
        mLViewModel = mo
//        self.modelView?.observe(mo)
        desgin(mo: mo)
    }
    
    public func collectionTappedCount(_ bind: @escaping (_ maskLayer: MaskLayer) -> Void) {
        guard let mLViewModel = mLViewModel else { return }
        mLViewModel.observe(for: mLViewModel.collectionTappedCount) { _ in
            self.mLViewModel?.collectionTappedCount.initValue()
            bind((self.mLViewModel?.maskLayer?.longtappedSelect(mo: mLViewModel)) ?? MaskLayer(minSegment: 0.0) )
        }
    }

    public func cameraObserve(_ bind: @escaping () -> Void) {
        mLViewModel?.observe(for: mLViewModel?.cameraCount ?? MaskObservable()) { _ in
            self.mLViewModel?.cameraCount.initValue()
            bind()
        }
    }
    
    public func pinchGesture() {
        MaskGesture.pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(pinchTapeed))
        MaskGesture.pinchGesture.delegate = self
        maskGestureView?.addGestureRecognizer(MaskGesture.pinchGesture)
    }

    private func desgin(mo: MaskingLayerViewModel) {
        mLViewModel = mo
        guard let modelView = modelView, let imageView = modelView.maskModel?.imageView else { return }
        maskGestureView?.addSubview(imageView)
        imageView.layer.addSublayer(mo.maskLayer?.clipLayer ?? CALayer())

        MaskGesture.panGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        MaskGesture.panGesture.delegate = self
        maskGestureView?.addGestureRecognizer(MaskGesture.panGesture)

        MaskGesture.longGesture = UILongPressGestureRecognizer(target: self, action:#selector(longTapeed))
        MaskGesture.longGesture.delegate = self
        maskGestureView?.addGestureRecognizer(MaskGesture.longGesture)
    }

    @objc func panTapped(sender: UIPanGestureRecognizer) { modelView?.panTapped(sender: sender) }

    @objc func longTapeed(sender: UILongPressGestureRecognizer) { mLViewModel?.longTapeed(sender: sender) }

    @objc func pinchTapeed(sender: UIPinchGestureRecognizer) {modelView?.pinchAction(sender: sender) }

}
