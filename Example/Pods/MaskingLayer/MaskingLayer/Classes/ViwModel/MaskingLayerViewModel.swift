//
//  MaskingLayerViewModel.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/09/01.
//

import Foundation
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
    
    private var url: URL?
    private var defo = UserDefaults.standard
    private var index = Int()
    private var margin: CGFloat = 10
    private var vc = UIViewController()
    private var gifObject = MaskGifObject()

    public init(minSegment: CGFloat) {
        imageView = UIImageView()
        defaltImageView = UIImageView()
        imageBackView = UIImageView()

        maskLayer = MaskLayer(minSegment: minSegment)
    }

    public func frameResize(images: UIImage) {
        image = images.ResizeUIImage(width: Margin.current.width, height: Margin.current.height)
        imageView?.image = image
        imageView?.frame = CGRect(x: Margin.current.xOrigin, y: Margin.current.yOrigin, width: Margin.current.width, height: Margin.current.height)
        defaltImageView?.image = imageView?.image
        defaltImageView?.frame = imageView?.frame ?? CGRect()
        maskPathSet()
    }

    func maskPortraitMatte(minSegment: CGFloat) {
        if #available(iOS 12.0, *) {
            DispatchQueue.main.async {
                let maskPortraitMatte = MaskPortraitMatteModel()
                maskPortraitMatte.portraitMatte(imageV    : self.imageView ?? UIImageView(),
                                                vc        : self.vc,
                                                minSegment: minSegment, mo: self)
            }
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
        self.vm.setVideoURLView.frame = CGRect(x: 0,y:0,width: self.vc.view.frame.width, height: self.vc.view.frame.width/15)
    }

    func imageResize() {
        imageView?.image = defaltImageView?.image
        imageBackView?.image = nil
    }

    func maskPathBegan(position: CGPoint, imageView: UIImageView) {
        maskLayer.clipLayer.isHidden = false
        if let path = maskLayer.start(position) {
             maskLayer.clipLayer.path = path
        }
        imageView.image = imageView.image?.ResizeUIImage(width: imageView.frame.width, height: imageView.frame.height)
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
        guard let size = imageView?.image?.size else { return }

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

    func maskGif() {
        defo = UserDefaults.standard
        guard let url  = defo.url(forKey: "url") else { return }
        gifObject.makeGifImageMovie(imageView ?? UIImageView(), url: url, frameY: 1, imageAr: (vm.setVideoURLView.imageAr ?? Array<CGImage>()))
    }

    private func selfResize(images: UIImage, view: UIView) {
        image = images.ResizeUIImage(width: view.frame.width, height: view.frame.height)
        imageView?.image = image
        imageView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        defaltImageView?.image = imageView?.image
        defaltImageView?.frame = imageView?.frame ?? CGRect()
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
    
    private func call() {
        DispatchQueue.main.async {
            self.maskCount.value = 0
        }
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

    public func longTapeed(sender:UILongPressGestureRecognizer) { longTappedCount.value = 0 }
}

// MARK: UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension MaskingLayerViewModel: UIImagePickerControllerDelegate & UINavigationControllerDelegate, Observer {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        let defo = UserDefaults.standard
        if #available(iOS 11.0, *) { defo.set(info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.imageURL)] as? URL, forKey: "url") }

        resetCView()

        let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as? NSString
        if mediaType == kUTTypeMovie {
            defo.set(info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? URL, forKey: "url")
            setURL()
            picker.dismiss(animated: true, completion: nil)

        } else {
            guard let images = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage) else { return }
            picker.dismiss(animated: true, completion: {
                self.frameResize(images: images)
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

    func observe<O>(for observable: MaskObservable<O>, with: @escaping (O) -> Void) { observable.bind(observer: with) }
}
