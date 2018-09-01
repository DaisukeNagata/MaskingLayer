//
//  ViewController.swift
//  MaskingLayer
//
//  Created by daisukenagata on 08/04/2018.
//  Copyright (c) 2018 daisukenagata. All rights reserved.
//

import UIKit
import SVProgressHUD
import MaskingLayer
import MobileCoreServices

struct CommonStructure {
    static var panGesture = UIPanGestureRecognizer()
    static var longGesture = UILongPressGestureRecognizer()
}

class ViewController: UIViewController,UIGestureRecognizerDelegate, UIScrollViewDelegate {

    var seArray = Array<Int>()
    var image = UIImage()
    var imageView = UIImageView()
    let maskLayer = MaskLayer()
    var gifObject = GifObject()
    var vm = CollectionViewModel()
    lazy var cView: CollectionView = {
        let cView = CollectionView()
        cView.collectionView.delegate = self
        cView.collectionView.dataSource = self.vm
        cView.backgroundColor = .clear
        return cView
    }()
    var margin: CGFloat = 10
    var index = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CommonStructure.panGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.panGesture.delegate = self
        view.addGestureRecognizer(CommonStructure.panGesture)
        
        CommonStructure.longGesture = UILongPressGestureRecognizer(target: self, action:#selector(longTapeed))
        CommonStructure.longGesture.delegate = self
        view.addGestureRecognizer(CommonStructure.longGesture)
        
        image = UIImage(named: "IMG_4011")!
        view.addSubview(self.imageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        guard vm.setVideoURLView.dataArray.count == 0 else {
            view.addSubview(cView)
            return
        }
        maskLayer.imageSet(view: self.view, imageView: self.imageView, image: self.image)
    }
    
    
    @objc func panTapped(sender:UIPanGestureRecognizer) {
        let position: CGPoint = sender.location(in: imageView)
        switch sender.state {
        case .ended:
            guard let size = imageView.image?.size else { return }
            imageView.image = maskLayer.maskImage(color: maskLayer.maskClor, size: size, convertPath: maskLayer.convertPath)
            maskLayer.imageSet(view: self.view, imageView: self.imageView, image: self.image)
            guard vm.setVideoURLView.dataArray.count == 0 else {
            vm.setVideoURLView.imageAr[index] = (imageView.image?.cgImage?.resize(imageView.image!.cgImage!)!)!
                if seArray.contains(self.index) {
                    seArray.remove(at: self.index)
                    vm.checkArray.remove(self.index)
                } else {
                    seArray.append(self.index)
                    vm.checkArray.add(self.index)
                }
                cView.collectionView.reloadData()
            return
            }
            break
        case .possible:
            break
        case .began:
            maskLayer.maskPath(position: position)
            maskConerPath(position: position, bool: true)
            break
        case .changed:
            maskLayer.maskAddLine(position: position)
            maskConerPath(position: position, bool: false)
            break
        case .cancelled:
            break
        case .failed:
            break
        }
    }
    func maskConerPath(position: CGPoint, bool: Bool) { maskLayer.maskConvertPointFromView(viewPoint: position, view: self.view,imageView: imageView,bool:bool) }
    @objc func longTapeed(sender:UILongPressGestureRecognizer) {
        vm = CollectionViewModel()
        maskLayer.alertSave(views: self, imageView: imageView, image: image) }
}

// MARK: UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let defo = UserDefaults.standard
        let url = defo.url(forKey: "url")
        if indexPath.section == 0 {
                do {
                    let data = try Data(contentsOf: url!)
                    self.imageView.animateGIF(data: data, duration: Double(2)) {
                    }
                }catch{
            }
        } else if indexPath.section == 1 {
           self.gifObject.makeGifImageMovie(url: url!,frameY: 1, createBool: true, scale: 1, imageAr: (self.vm.setVideoURLView.imageAr))
            if  seArray.count == 0 {
            } else {
                vm.checkArray.removeAllObjects()
            }
        } else if indexPath.section == 2 {
        } else {
            maskLayer.imageSet(view: self.view, imageView: self.imageView, image: self.image)
            image = UIImage(data: vm.setVideoURLView.dataArray[indexPath.section-2])!
            imageView.image = image
            maskLayer.imageReSet(view: self.view, imageView: imageView, image: image)
            index = indexPath.section-2
            if seArray.contains(indexPath.section-2) {
                let index = seArray.index(of: indexPath.section-2)
                seArray.remove(at: index!)
                vm.checkArray.remove(indexPath.section-2)
            }
            collectionView.reloadData()
        }
    }

}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        SVProgressHUD.show()
        vm.setVideoURLView.thumbnailViews.removeAll()
        vm.setVideoURLView.dataArray.removeAll()
        cView.removeFromSuperview()
        cView = {
            let cView = CollectionView()
            cView.collectionView.delegate = self
            cView.collectionView.dataSource = self.vm
            cView.backgroundColor = .clear
            return cView
        }()
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType == kUTTypeMovie {
            vm.setVideoURLView.setURL(url: info[UIImagePickerControllerMediaURL] as! URL, view: self)
            vm.setVideoURLView.frame = CGRect(x:0,y:0,width: self.view.frame.width, height: self.view.frame.width/15)
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                    self.gifObject.makeGifImageMovie(url: info[UIImagePickerControllerMediaURL] as! URL,frameY: 1, createBool: true, scale: 1, imageAr: (self.vm.setVideoURLView.imageAr))
                SVProgressHUD.dismiss()
                picker.dismiss(animated: true, completion: nil)
                return
            }
        } else {
            guard let images = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
            image = images
            SVProgressHUD.dismiss()
            picker.dismiss(animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageView = UIImageView()
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
}
