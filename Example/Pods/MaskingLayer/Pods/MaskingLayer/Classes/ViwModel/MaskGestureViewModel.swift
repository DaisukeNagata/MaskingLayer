//
//  MaskGestureViewModel.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2019/11/01.
//

import UIKit

public class MaskGestureViewModel: NSObject, UIGestureRecognizerDelegate {

    public var mLViewModel: MaskingLayerViewModel?
    public var modelView: MaskingLayerModelView?

    public init(mo: MaskingLayerViewModel, modelView: MaskingLayerModelView?) {
        super.init()
        self.modelView = modelView
        mLViewModel = mo
        desgin(mo: mo)
    }

    public func cameraObserve(_ bind: @escaping () -> Void) {
        mLViewModel?.observe(for: mLViewModel?.cameraCount ?? MaskObservable()) { _ in
            self.mLViewModel?.cameraCount.initValue()
            bind()
        }
    }

    public func pinchAndTapGesture() {
        MaskGesture.pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(pinchTapeed))
        MaskGesture.pinchGesture.delegate = self
        modelView?.maskModel?.maskGestureView?.addGestureRecognizer(MaskGesture.pinchGesture)

        MaskGesture.taoGesture = UITapGestureRecognizer(target: self, action:#selector(tapeed))
        MaskGesture.taoGesture.delegate = self
        modelView?.maskModel?.maskGestureView?.addGestureRecognizer(MaskGesture.taoGesture)
    }

    private func desgin(mo: MaskingLayerViewModel) {
        mLViewModel = mo
        guard let modelView = modelView, let imageView = modelView.maskModel?.imageView else { return }
        modelView.maskModel?.maskGestureView?.addSubview(imageView)
        imageView.layer.addSublayer(mo.maskLayer?.clipLayer ?? CALayer())

        MaskGesture.panGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        MaskGesture.panGesture.delegate = self
        modelView.maskModel?.maskGestureView?.addGestureRecognizer(MaskGesture.panGesture)

        MaskGesture.longGesture = UILongPressGestureRecognizer(target: self, action:#selector(longTapeed))
        MaskGesture.longGesture.delegate = self
        modelView.maskModel?.maskGestureView?.addGestureRecognizer(MaskGesture.longGesture)
    }

    @objc private func panTapped(sender: UIPanGestureRecognizer) { modelView?.panTapped(sender: sender) }

    @objc private func longTapeed(sender: UILongPressGestureRecognizer) { modelView?.longTapeed(sender: sender) }

    @objc private func pinchTapeed(sender: UIPinchGestureRecognizer) { modelView?.pinchAction(sender: sender) }

    @objc private func tapeed(sender: UITapGestureRecognizer) { modelView?.tapAction(sender: sender) }

}
