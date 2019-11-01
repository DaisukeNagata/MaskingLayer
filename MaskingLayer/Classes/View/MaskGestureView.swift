//
//  MaskGestureView.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2019/11/01.
//

import UIKit

public class MaskGestureView: UIView, UIGestureRecognizerDelegate {
    
    private var mLViewModel: MaskingLayerViewModel?

    public init(mO: MaskingLayerViewModel) {
        super.init(frame: .zero)
        mLViewModel = mO
        desgin(mO: mO)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func desgin(mO: MaskingLayerViewModel) {
        mLViewModel = mO
        MaskGesture.panGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        MaskGesture.panGesture.delegate = self
        self.addGestureRecognizer(MaskGesture.panGesture)
        
        MaskGesture.longGesture = UILongPressGestureRecognizer(target: self, action:#selector(longTapeed))
        MaskGesture.longGesture.delegate = self
        self.addGestureRecognizer(MaskGesture.longGesture)
    }
    
    @objc func panTapped(sender: UIPanGestureRecognizer) { mLViewModel?.panTapped(sender: sender) }

    @objc func longTapeed(sender:UILongPressGestureRecognizer) { mLViewModel?.longTapeed(sender: sender) }

}
