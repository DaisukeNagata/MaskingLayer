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

    var imageView: UIImageView?
    var defaltImageView: UIImageView?
    var imageBackView: UIImageView?

    var vm = MaskCollectionViewModel()
    lazy var cView: MaskCollectionView = {
        let cView = MaskCollectionView()
        cView.collectionView.delegate = self
        cView.collectionView.dataSource = self.vm
        cView.backgroundColor = .clear
        return cView
    }()

    var image = UIImage()
    var maskLayer: MaskLayer
    var maskCount = MaskObservable<Int>()
    var longTappedCount = MaskObservable<Int>()
    var backImageCount = MaskObservable<Int>()
    var cameraCount = MaskObservable<Int>()
    
    private var url: URL?
    private var defo = UserDefaults.standard
    private var index = Int()
    private var margin: CGFloat = 10
    private var vc:  UIViewController?
    private var gifObject = MaskGifObject()
    
    // DyeHair Camera Setting
    private var maskPortraitMatte: MaskFilterBuiltinsMatte? = nil

    public init(vc: UIViewController? = nil, minSegment: CGFloat? = nil) {
        imageView = UIImageView()
        defaltImageView = UIImageView()
        imageBackView = UIImageView()

        self.vc = vc ?? UIViewController()
        maskLayer = MaskLayer(minSegment: minSegment ?? 0.0)
    }

    public func frameResize(images: UIImage, rect: CGRect) {
        imageView?.frame = rect
        image = images.ResizeUIImage(width: imageView?.frame.width ?? 0.0, height: imageView?.frame.height ?? 0.0)
        imageView?.image = image
        imageView?.contentMode = .scaleAspectFit
        let imageSize = AVMakeRect(aspectRatio: imageView?.image?.size ?? CGSize(), insideRect: imageView?.bounds ?? CGRect()).size
        imageView?.frame.size = imageSize
        imageView?.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)

        if defaltImageView?.image == nil {
            defaltImageView?.frame = imageView?.frame ?? CGRect()
            maskPathSet()
        }

        defaltImageView?.image = imageView?.image
    }

    func maskPortraitMatte(minSegment: CGFloat) {
        DispatchQueue.main.async {
            let maskPortraitMatte = MaskPortraitMatteModel()
            maskPortraitMatte.portraitMatte(imageV    : self.imageView ?? UIImageView(),
                                            vc        : self.vc ?? UIViewController(),
                                            minSegment: minSegment, mo: self)
        }
    }

    func gousei() {
        DispatchQueue.main.async {
            let top: UIImage = self.imageView?.image ?? UIImage()
            let bottom: UIImage = self.imageBackView?.image ?? UIImage()
            let nSize = CGSize(width:bottom.size.width, height:bottom.size.height)
            UIGraphicsBeginImageContextWithOptions(nSize, false, bottom.scale)
            bottom.draw(in: CGRect(x:0,y:0,width:nSize.width,height:nSize.height))
            top.draw(in: CGRect(x:0,y:0,width:nSize.width,height:nSize.height),blendMode:CGBlendMode.normal, alpha:1.0)
            let nImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            self.imageView?.image = nImage
            self.imageView?.setNeedsLayout()
        }
    }

    func setURL() {
        vm.setVideoURLView.setURL { self.call() }
        self.vm.setVideoURLView.frame = CGRect(x: 0,y:0,width: self.vc?.view.frame.width ?? 0.0, height: (self.vc?.view.frame.width ?? 0.0)/15)
    }

    func imageResize() {
        frameResize(images: defaltImageView?.image ?? UIImage(), rect: defaltImageView?.frame ?? CGRect())
        imageBackView?.image = nil
    }

    func maskGif() {
        defo = UserDefaults.standard
        guard let url  = defo.url(forKey: "url") else { return }
        gifObject.makeGifImageMovie(imageView ?? UIImageView(), url: url, frameY: 1, imageAr: (vm.setVideoURLView.imageAr ?? Array<CGImage>()))
    }

    private func resetCView() {
        vm.setVideoURLView.thumbnailViews?.removeAll()
        vm.setVideoURLView.dataArray.removeAll()
        vm.checkLabel = UILabel()
        vm.checkArray.removeAllObjects()
        vm.rotate = 0
        cView.removeFromSuperview()
        cView = {
            let cView = MaskCollectionView()
            cView.collectionView.delegate = self
            cView.collectionView.dataSource = self.vm
            cView.backgroundColor = .clear
            return cView
        }()
    }

    private func maskPathSet() {
        maskLayer.maskColor = .clear
        maskPathEnded(position: CGPoint(), view: imageView ?? UIImageView())
        maskLayer.maskColor = .white
    }
}

// MARK: UICollectionViewDelegate
extension MaskingLayerViewModel: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            vm.rotate = 90
            maskGif()
        } else {
            vm.rotate = 0
            image = UIImage(data: vm.setVideoURLView.dataArray[indexPath.section])!
            imageView?.image = image
            
            maskLayer.mutablePathSet()

            index = indexPath.section
            if vm.checkArray.contains(index) { vm.checkArray.remove(index) }
        }
        collectionView.reloadData()
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

// MARK: UIPanGestureRecognizer
extension MaskingLayerViewModel {

    public func panTapped(sender: UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: imageView)
        switch sender.state {
        case .ended:
            maskPathEnded(position: position, view: imageView ?? UIImageView())
            break
        case .possible:
            break
        case .began:
            maskPathBegan(position: position, imageView: imageView ?? UIImageView())
            break
        case .changed:
            maskAddLine(position: position, imageView: imageView ?? UIImageView())
            break
        case .cancelled:
            break
        case .failed:
            break
        @unknown default: break
        }
    }

    func longTapeed(sender:UILongPressGestureRecognizer) { longTappedCount.value = 0 }

    func maskPathBegan(position: CGPoint, imageView: UIImageView) {
        maskLayer.clipLayer.isHidden = false
        if let path = maskLayer.start(position) {
             maskLayer.clipLayer.path = path
        }

        let imageSize = AVMakeRect(aspectRatio: imageView.image?.size ?? CGSize(), insideRect: imageView.bounds).size
        imageView.frame.size = imageSize
        imageView.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
    }

    func maskAddLine(position: CGPoint,imageView: UIImageView) {
        if let path = maskLayer.move(position) {
            maskLayer.clipLayer.path = path
        }
    }

    func maskPathEnded(position: CGPoint,view: UIView) {

        var elements = maskLayer.elements
        elements.insert(MaskMove(x: position.x, y: position.y), at: 0)
        elements.append(MaskLine(x: position.x, y: position.y))
        maskLayer.clipLayer.path = MaskPath.path(from: elements, path: maskLayer.convertPath)
        guard let size = imageView?.frame.size else { return }

        imageView?.image = maskLayer.maskImage(color: maskLayer.maskColor, size: size, convertPath:  MaskPath.path(from: elements, path: maskLayer.convertPath))
        maskLayer.imageSet(view: view, imageView: imageView ?? UIImageView(), image: image)

        guard vm.setVideoURLView.imageAr?.isEmpty ?? false else {
            vm.setVideoURLView.imageAr?[index] = ((imageView?.image?.cgImage?.resize((imageView?.image?.cgImage)!))!)

            if !vm.checkArray.contains(index) {
                vm.checkArray.add(index)
                cView.collectionView.reloadData()
            }
            return
        }
    }
}

// MARK: UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension MaskingLayerViewModel: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        let defo = UserDefaults.standard
        defo.set(info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.imageURL)] as? URL, forKey: "url")

        resetCView()

        let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as? NSString
        if mediaType == kUTTypeMovie {
            defo.set(info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? URL, forKey: "url")
            setURL()
            picker.dismiss(animated: true, completion: nil)

        } else {
            guard let images = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage) else { return }
            picker.dismiss(animated: true, completion: {
                self.frameResize(images: images, rect: self.imageView?.frame ?? CGRect())
                self.maskPathBegan(position: CGPoint(), imageView: self.imageView ?? UIImageView())
                self.maskCount.value = 0
            })
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    public func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    public func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}

// MARK: Observer
extension MaskingLayerViewModel: Observer {

    func observe<O>(for observable: MaskObservable<O>, with: @escaping (O) -> Void) { observable.bind(observer: with) }

    private func call() {
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

    public func btAction() { maskPortraitMatte?.btAction(view: vc?.view ?? UIView(), tabHeight:  vc?.tabBarController?.tabBar.frame.height ?? 0.0) }

    public func cameraAction() { maskPortraitMatte?.uIImageWriteToSavedPhotosAlbum() }
    
    public func cameraReset() {
        vc?.removeFromParent()
        imageView?.removeFromSuperview()
        maskPortraitMatte?.cameraReset()
    }
}
