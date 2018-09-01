//
//  MaskNavigationObject.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/09/01.
//

import Foundation
import MobileCoreServices

public class MaskNavigationObject: NSObject {
    
    public var index = Int()
    public var image = UIImage()
    public var margin: CGFloat = 10
    public var seArray = Array<Int>()
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
    
    
    public func resetCView(views: UIViewController, imageView: UIImageView, image: UIImage) {
        vm.setVideoURLView.thumbnailViews.removeAll()
        vm.setVideoURLView.dataArray.removeAll()
        cView.removeFromSuperview()
        cView = {
            let cView = MaskCollectionView()
            cView.collectionView.delegate = self
            cView.collectionView.dataSource = self.vm
            cView.backgroundColor = .clear
            return cView
        }()
    }
    public func maskPath(position: CGPoint,view: UIView,imageView:UIImageView,bool: Bool) {
        maskLayer.clipLayer.isHidden = false
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
            vm.setVideoURLView.imageAr[index] = (imageView.image?.cgImage?.resize(imageView.image!.cgImage!))!
            if !seArray.contains(index) {
                seArray.append(index)
                vm.checkArray.add(index)
                cView.collectionView.reloadData()
            }
            return
        }
    }
    public func setURL(url: URL,vc: UIViewController) {
        vm.setVideoURLView.setURL(url: url, view: vc)
        vm.setVideoURLView.frame = CGRect(x:0,y:0,width: vc.view.frame.width, height: vc.view.frame.width/15)
    }
    
    public func maskGif(url: URL) {
        gifObject.makeGifImageMovie(url: url,frameY: 1, createBool: true, scale: 1, imageAr: (vm.setVideoURLView.imageAr))
    }
}

// MARK: UICollectionViewDelegate
extension MaskNavigationObject: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let defo = UserDefaults.standard
        let url = defo.url(forKey: "url")
        if indexPath.section == 0 {
            do {
                let data = try Data(contentsOf: url!)
                vm.rotate = -90
                self.imageView.animateGIF(data: data, duration: Double(4)) { }
            }catch{ print("error") }
        } else if indexPath.section == 1 {
            vm.rotate = 90
            self.gifObject.makeGifImageMovie(url: url!,frameY: 1, createBool: true, scale: 1, imageAr: (self.vm.setVideoURLView.imageAr))
        } else {
            vm.rotate = 0
            cView.collectionView.reloadData()
            image = UIImage(data: vm.setVideoURLView.dataArray[indexPath.section-2])!
            imageView.image = image
            maskLayer.imageReSet(view: vc.view, imageView: imageView, image: image)
            index = indexPath.section-2
            if seArray.contains(indexPath.section-2) {
                let index = seArray.index(of: indexPath.section-2)
                seArray.remove(at: index!)
                vm.checkArray.remove(index!)
            }
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
