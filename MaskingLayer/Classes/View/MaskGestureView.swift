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
    
   public func observe(_ vc: UIViewController, mO: MaskingLayerViewModel) {
        mLViewModel?.observe(for: mLViewModel?.maskCount ?? MaskObservable()) { _ in
            self.mLViewModel?.maskCount.initValue()
            guard self.mLViewModel?.vm.setVideoURLView.dataArray.count == 0 else { vc.view.addSubview( self.mLViewModel?.cView ?? UIView()); return }
            
            let defo = UserDefaults.standard
            guard defo.object(forKey: "url") == nil else {
                
                self.mLViewModel?.maskPortraitMatte(minSegment: 15)
                if self.mLViewModel?.imageBackView.image != nil { self.mLViewModel?.gousei() }
                return
            }
        }
        
        mLViewModel?.observe(for: mLViewModel?.longTappedCount ?? MaskObservable()) { _ in
            self.mLViewModel?.longTappedCount.initValue()
            self.mLViewModel?.maskLayer.alertSave(views: vc, mo: mO)
        }
        
        mLViewModel?.observe(for: mLViewModel?.backImageCount ?? MaskObservable()) { _ in
            self.mLViewModel?.backImageCount.initValue()
            self.mLViewModel?.imageBackView.image = self.mLViewModel?.imageView.image
            self.mLViewModel?.imageBackView.frame = self.mLViewModel?.imageView.frame ?? CGRect()
            self.mLViewModel?.imageBackView.setNeedsLayout()
        }
    }
    
    @objc func panTapped(sender: UIPanGestureRecognizer) { mLViewModel?.panTapped(sender: sender) }

    @objc func longTapeed(sender:UILongPressGestureRecognizer) { mLViewModel?.longTapeed(sender: sender) }

}
