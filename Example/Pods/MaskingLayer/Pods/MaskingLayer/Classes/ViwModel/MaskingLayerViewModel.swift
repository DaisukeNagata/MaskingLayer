//
//  MaskingLayerViewModel.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/09/01.
//

import Foundation
import AVFoundation
import MobileCoreServices

public class MaskingLayerViewModel: NSObject, CViewProtocol {

    public var maskLayer: MaskLayer?

    var collectionTappedCount = MaskObservable<Int>()
    var backImageCount = MaskObservable<Int>()
    var cameraCount = MaskObservable<Int>()
    var maskCount = MaskObservable<Int>()
    var panGestureStartY = CGFloat()
    var panGestureStartX = CGFloat()
    var panGestureRect = CGRect()

    private var margin: CGFloat = 10
    private var defaultHight: CGFloat = 30

    // DyeHair Camera Setting
    private var maskPortraitMatte: MaskFilterBuiltinsMatte? = nil

    public init(minSegment: CGFloat? = nil) {
        maskLayer = MaskLayer(minSegment: minSegment ?? 0.0)
    }

    public func collectionTapped() {
        collectionTappedCount.value = 0
    }

    func maskPortraitMatte(minSegment: CGFloat, imageView: UIImageView) {
        DispatchQueue.main.async {
            let maskPortraitMatte = MaskPortraitMatteModel()
            maskPortraitMatte.portraitMatte(imageV    : imageView,
                                            minSegment: minSegment, mo: self)
        }
    }

    func maskPathSet(maskLayer: MaskLayer, model: MaskingLayerModel) {
        maskLayer.maskColor = .clear
        maskPathEnded(position: CGPoint(), model: model)
        maskLayer.clipLayer.name == "trimLayer" ? (maskLayer.maskColor = .black) : (maskLayer.maskColor = .white)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MaskingLayerViewModel: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
}

// MARK: Mask

extension MaskingLayerViewModel {

    public func imageMask(imageView: UIImageView) {
        guard let image = imageView.image, let trimWidth = maskLayer?.trimWith else { return }

        let layer = CALayer()
        layer.contents = image.cgImage
        layer.contentsScale = image.scale
        layer.contentsCenter = CGRect(
            x: ((image.size.width/2) - 1)/image.size.width,
            y: ((image.size.height/2) - 1)/image.size.height,
            width: 1 / image.size.width,
            height: 1 / image.size.height)
        layer.frame = imageView.bounds.insetBy(dx: panGestureRect.origin.x, dy: 0)
        layer.frame.size.height = trimWidth
        layer.frame.size.width = panGestureRect.width
        layer.frame.origin.y = panGestureRect.origin.y - (imageView.frame.origin.y + trimWidth/2)
        imageView.layer.mask = layer
        maskLayer?.clipLayer.strokeColor = UIColor.clear.cgColor
    }

    public func lockImageMask(imageView: UIImageView, windowFrameView: UIView) {
        guard let image = imageView.image else { return }

        let layer = CALayer()
        layer.contents = image.cgImage
        layer.contentsScale = image.scale
        layer.frame = windowFrameView.frame
        windowFrameView.removeFromSuperview()
        imageView.layer.mask = layer
        maskLayer?.clipLayer.strokeColor = UIColor.clear.cgColor
    }
    
    func longTapeed(sender: UILongPressGestureRecognizer) {
        guard let trimWidth = maskLayer?.trimWith else { return }

        maskLayer?.clipLayer.lineWidth += 1
        maskLayer?.trimWith += 1
        panGestureRect.size.height = trimWidth
    }

    func maskPathBegan(position: CGPoint) {
        guard let maskLayer = maskLayer else { return }

        maskLayer.clipLayer.name == "trimLayer" ? (maskLayer.clipLayer.lineWidth = maskLayer.trimWith) : (maskLayer.clipLayer.lineWidth = maskLayer.maskWidth)
        maskLayer.clipLayer.isHidden = false
        if let path = maskLayer.start(position) {
            maskLayer.clipLayer.path = path
        }
    }

    func maskAddLine(position: CGPoint) {
        guard let maskLayer = maskLayer else { return }

        if let path = maskLayer.move(position) {
            maskLayer.clipLayer.path = path
        }
    }

    func maskPathEnded(position: CGPoint, model: MaskingLayerModel?) {
        guard let maskLayer = maskLayer else { return }

        var elements = maskLayer.elements
        elements.insert(MaskMove(x: position.x, y: position.y), at: 0)
        elements.append(MaskLine(x: position.x, y: position.y))
        maskLayer.clipLayer.path = MaskPath.path(from: elements, path: maskLayer.convertPath)

        model?.imageView.image = maskLayer.maskImage(color: maskLayer.maskColor,
                                                     size: model?.imageView.frame.size ?? CGSize(),
                                                     convertPath:  MaskPath.path(from: elements, path: maskLayer.convertPath))
        maskLayer.imageSet(imageView: model?.imageView ?? UIImageView(),
                           image: model?.image ?? UIImage())
    }

    func endPangesture(position: CGPoint, imageView: UIImageView) {
        guard let maskLayer = maskLayer else { return }

        maskLayer.trimWith = defaultHight
        panGestureRect.size.height = maskLayer.trimWith
        maskLayer.clipLayer.lineWidth = maskLayer.trimWith
    }
}


// MARK: Observer
extension MaskingLayerViewModel: Observer {

    func observe<O>(for observable: MaskObservable<O>, with: @escaping (O) -> Void) { observable.bind(observer: with) }

    func call() {
        DispatchQueue.main.async {
            self.maskCount.value = 0
        }
    }
}

// MARK: cmareraLogic
extension MaskingLayerViewModel {
    // cmareraPreView
    public func cmareraPreView(_ view: UIView) {
        self.maskPortraitMatte = MaskFilterBuiltinsMatte()
        self.maskPortraitMatte?.setMaskFilter(view: view)
    }

    public func btAction(view: UIView) {
        maskPortraitMatte?.btAction(view: view, tabHeight:  0)
    }

    public func cameraAction() {
        maskPortraitMatte?.uIImageWriteToSavedPhotosAlbum()
    }

    public func cameraReset(view: UIView) {
        view.removeFromSuperview()
        maskPortraitMatte?.cameraReset()
    }
}
