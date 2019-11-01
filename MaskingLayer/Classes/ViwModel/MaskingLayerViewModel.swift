//
//  MaskingLayerViewModel.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/09/01.
//

import Foundation
import MobileCoreServices

public class MaskingLayerViewModel: NSObject, CViewProtocol {

    public var maskLayer: MaskLayer
    public var imageView = UIImageView()
    public var defaltImageView = UIImageView()
    public var imageBackView = UIImageView()
    public var vm = MaskCollectionViewModel()
    public var maskCount = MaskObservable<Int>()
    public var longTappedCount = MaskObservable<Int>()
    public var backImageCount = MaskObservable<Int>()
    public lazy var cView: MaskCollectionView = {
        let cView = MaskCollectionView()
        cView.collectionView.delegate = self
        cView.collectionView.dataSource = self.vm
        cView.backgroundColor = .clear
        return cView
    }()

    var image = UIImage()

    private var index = Int()
    private var margin: CGFloat = 10
    private var vc = UIViewController()
    private var gifObject = MaskGifObject()

    public init(minSegment: CGFloat) {
        maskLayer = MaskLayer(minSegment: minSegment)
    }

    public func maskPortraitMatte(minSegment: CGFloat) {
        if #available(iOS 12.0, *) {
            DispatchQueue.main.async {
                let maskPortraitMatte = MaskPortraitMatteModel()
                maskPortraitMatte.portraitMatte(imageV    : self.imageView,
                                                vc        : self.vc,
                                                minSegment: minSegment, mo: self)
            }
        }
    }

    public func frameResize(images: UIImage) {
        image = images.ResizeUIImage(width: Margin.current.width, height: Margin.current.height)
        imageView.image = image
        imageView.frame = CGRect(x: Margin.current.xOrigin, y: Margin.current.yOrigin, width: Margin.current.width, height: Margin.current.height)
        defaltImageView.image = imageView.image
        defaltImageView.frame = imageView.frame
    }
    
    public func masPathSet() {
        maskLayer.maskColor = .clear
        maskPathEnded(position: CGPoint(), view: imageView)
        maskLayer.maskColor = .white
    }

    public func gousei() {
        DispatchQueue.main.async {
            let top: UIImage = self.imageView.image ?? UIImage()
            let bottom: UIImage = self.imageBackView.image ?? UIImage()
            let nSize = CGSize(width:bottom.size.width, height:bottom.size.height)
            UIGraphicsBeginImageContextWithOptions(nSize, false, bottom.scale)
            bottom.draw(in: CGRect(x:0,y:0,width:nSize.width,height:nSize.height))
            top.draw(in: CGRect(x:0,y:0,width:nSize.width,height:nSize.height),blendMode:CGBlendMode.normal, alpha:1.0)
            let nImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            self.imageView.image = nImage
            self.imageView.setNeedsLayout()
        }
    }

    func setURL() {
        vm.setVideoURLView.setURL()
        vm.setVideoURLView.frame = CGRect(x: 0,y:0,width: vc.view.frame.width, height: vc.view.frame.width/15)
    }

    func imageResize() {
        imageView.image = defaltImageView.image
        imageBackView.image = nil
    }

    func selfResize(images: UIImage, view: UIView) {
        image = images.ResizeUIImage(width: view.frame.width, height: view.frame.height)
        imageView.image = image
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        defaltImageView.image = imageView.image
        defaltImageView.frame = imageView.frame
    }

    func resetCView() {
        vm.setVideoURLView.thumbnailViews.removeAll()
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
        guard let size = imageView.image?.size else { return }

        imageView.image = maskLayer.maskImage(color: maskLayer.maskColor, size: size, convertPath:  MaskPath.path(from: elements, path: maskLayer.convertPath))
        maskLayer.imageSet(view: view, imageView: imageView, image: image)

        guard vm.setVideoURLView.imageAr.isEmpty else {
            vm.setVideoURLView.imageAr[index] = (imageView.image?.cgImage?.resize(imageView.image!.cgImage!))!

            if !vm.checkArray.contains(index) {
                vm.checkArray.add(index)
                cView.collectionView.reloadData()
            }
            return
        }
    }

    func maskGif() {
        let defo = UserDefaults.standard
        guard let url  = defo.url(forKey: "url") else { return }
        gifObject.makeGifImageMovie(url: url,frameY: 1, imageAr: (vm.setVideoURLView.imageAr))
    }
}

// MARK: UICollectionViewDelegate
extension MaskingLayerViewModel: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let defo = UserDefaults.standard
        let url = defo.url(forKey: "url")

        if indexPath.section == 0 {
            do {
                vm.rotate = 90
                maskGif()

                let data = try Data(contentsOf: url!)
                self.imageView.animateGIF(data: data, duration: Double(4)) { }

            } catch { print("error") }

        } else {
            vm.rotate = 0
            image = UIImage(data: vm.setVideoURLView.dataArray[indexPath.section])!
            imageView.image = image

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
            maskPathEnded(position: position, view: imageView)
            break
        case .possible:
            break
        case .began:
            maskPathBegan(position: position, imageView: imageView)
            break
        case .changed:
            maskAddLine(position: position, imageView: imageView)
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

extension MaskingLayerViewModel: UIImagePickerControllerDelegate & UINavigationControllerDelegate, Observer {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        let defo = UserDefaults.standard
        if #available(iOS 11.0, *) { defo.set(info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.imageURL)] as? URL, forKey: "url") }

        resetCView()
        let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as! NSString
        if mediaType == kUTTypeMovie {
            defo.set(info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? URL, forKey: "url")
            self.setURL()
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.maskGif()
                picker.dismiss(animated: true, completion: nil)
                self.maskCount.value = 0
            }
        } else {
            maskCount.value = 0
            guard let images = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage) else { return }
            picker.dismiss(animated: true, completion: nil)
            frameResize(images: images)
            maskPathBegan(position: CGPoint(), imageView: imageView)
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
    
    public func observe<O>(for observable: MaskObservable<O>, with: @escaping (O) -> Void) { observable.bind(observer: with) }
}
