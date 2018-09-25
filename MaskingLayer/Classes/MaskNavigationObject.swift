//
//  MaskNavigationObject.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/09/01.
//

import Foundation
import MobileCoreServices

public protocol CViewProtocol {
    func maskPath(position: CGPoint, view: UIView, imageView:UIImageView, bool: Bool)
    func maskAddLine(position: CGPoint,view: UIView,imageView:UIImageView,bool: Bool)
    func tappedEnd(view: UIView)
    func maskGif()
    func setURL()
}

public class MaskNavigationObject: NSObject,CViewProtocol {

    public var index = Int()
    public var image = UIImage()
    public var margin: CGFloat = 10
    public var vc = UIViewController()
    public var imageView = UIImageView()
    public var maskLayer = MaskLayer()
    public var gifObject = MaskGifObject()
    public var vm = MaskCollectionViewModel()
    public lazy var cView: MaskCollectionView = {
        let cView = MaskCollectionView()
        cView.collectionView.delegate = self
        cView.collectionView.dataSource = self.vm
        cView.backgroundColor = .clear
        return cView
    }()

    public func imageResize(images: UIImage){
        image = images.ResizeUIImage(width: vc.view.frame.width, height: vc.view.frame.height)
        imageView.image = images.ResizeUIImage(width: vc.view.frame.width, height: vc.view.frame.height)
        imageView.frame = vc.view.frame
    }

    public func resetCView() {
        vm.setVideoURLView.thumbnailViews.removeAll()
        vm.setVideoURLView.dataArray.removeAll()
        vm.checkArray.removeAllObjects()
        cView.removeFromSuperview()
        cView = {
            let cView = MaskCollectionView()
            cView.collectionView.delegate = self
            cView.collectionView.dataSource = self.vm
            cView.backgroundColor = .clear
            return cView
        }()
    }
    public func maskPortraitMatte() {
        if #available(iOS 12.0, *) {
            let maskPortraitMatte = MaskPortraitMatte()
            maskPortraitMatte.portraitMatte(imageV: imageView, vc: vc)
        }
    }
    public func maskPath(position: CGPoint, view: UIView, imageView:UIImageView, bool: Bool) {
        maskLayer.clipLayer.isHidden = false
        maskLayer.imageSet(view: view,imageView: imageView, image: image)
        maskLayer.path.move(to: CGPoint(x: position.x, y: position.y))
        maskLayer.maskConvertPointFromView(viewPoint: position, view: view,imageView: imageView,bool:bool)
    }
    public func maskAddLine(position: CGPoint,view: UIView,imageView:UIImageView,bool: Bool) {
        maskLayer.path.addLine(to: CGPoint(x: position.x, y: position.y))
        maskLayer.maskConvertPointFromView(viewPoint: position, view: view,imageView: imageView,bool:bool)
    }
    public func tappedEnd(view: UIView) {
        guard let size = imageView.image?.size else { return }
        imageView.image = maskLayer.maskImage(color: maskLayer.maskColor, size: size, convertPath: maskLayer.convertPath)
        maskLayer.imageSet(view: view,imageView: imageView, image: image)
        guard vm.setVideoURLView.dataArray.count == 0 else {
            vm.setVideoURLView.imageAr[0] = (imageView.image?.cgImage?.resize(imageView.image!.cgImage!))!
            vm.setVideoURLView.imageAr[index] = (imageView.image?.cgImage?.resize(imageView.image!.cgImage!))!
            if !vm.checkArray.contains(index) {
                vm.checkArray.add(index)
                cView.collectionView.reloadData()
            }
            return
        }
    }
    public func setURL() {
        vm.setVideoURLView.setURL()
        vm.setVideoURLView.frame = CGRect(x:0,y:0,width: vc.view.frame.width, height: vc.view.frame.width/15)
    }
    public func maskGif() {
        let defo = UserDefaults.standard
        guard let url  = defo.url(forKey: "url") else { return }
        gifObject.makeGifImageMovie(url: url,frameY: 1, createBool: true, scale: UIScreen.main.scale, imageAr: (vm.setVideoURLView.imageAr))
    }
}

// MARK: UICollectionViewDelegate
extension MaskNavigationObject: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let defo = UserDefaults.standard
        let url = defo.url(forKey: "url")
        if indexPath.section == 0 {
            do {
                vm.rotate = 90
                maskGif()
                let data = try Data(contentsOf: url!)
                self.imageView.animateGIF(data: data, duration: Double(4)) { }
            }catch{ print("error") }
        } else {
            vm.rotate = 0
            image = UIImage(data: vm.setVideoURLView.dataArray[indexPath.section-vm.editCount])!
            imageView.image = image
            maskLayer.imageReSet(view: vc.view, imageView: imageView, image: image)
            index = indexPath.section-vm.editCount
            if vm.checkArray.contains(index) { vm.checkArray.remove(index) }
        }
        collectionView.reloadData()
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MaskNavigationObject: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
}
