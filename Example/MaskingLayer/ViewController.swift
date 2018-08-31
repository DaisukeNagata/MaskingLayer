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
   
    let vm = CollectionViewModel()
    lazy var cView: CollectionView = {
        let cView = CollectionView()
        cView.collectionView.delegate = self
        cView.collectionView.dataSource = self.vm
        view.addSubview(cView.imageView)
        view.addSubview(cView)
        return cView
    }()
    var margin: CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        CommonStructure.panGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.panGesture.delegate = self
        view.addGestureRecognizer(CommonStructure.panGesture)

        CommonStructure.longGesture = UILongPressGestureRecognizer(target: self, action:#selector(longTapeed))
        CommonStructure.longGesture.delegate = self
        view.addGestureRecognizer(CommonStructure.longGesture)

        image = UIImage(named: "IMG_4011")!
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        self.view.addSubview( self.imageView)
        guard vm.setVideoURLView.data.count == 0 else {
            for i in 0..<self.vm.setVideoURLView.thumbnailViews.count {
                self.imageView.animateGIF(data: vm.setVideoURLView.data[i], duration: Double(2)) {
                    guard let image = UIImage(data: self.vm.setVideoURLView.data[i]) else { return }
                    self.imageView.image = image
                }
            }
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
    @objc func longTapeed(sender:UILongPressGestureRecognizer) { maskLayer.alertSave(views: self, imageView: imageView, image: image) }
    
}
    
    // MARK: UICollectionViewDelegate
    extension ViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if indexPath.section == 0 {
                self.dismiss(animated: true, completion: nil)
            } else if indexPath.section == 1 {
                if  seArray.count == 0 {
                  //  alertView.alertVcNotEdit(view: self)
                } else {
                    vm.checkArray.removeAllObjects()
//                    alertView.gifEdit(view: self)
                }
            } else if indexPath.section == 2 {
                //alertView.alertVcNotEdit(view: self)
            } else {
//                try! RealmModel.realm.realmTry.write {
//                    let image = UIImage(data: RealmModel.realm.usersSet[ViewController.vc.index].urlData[indexPath.section-2])
//                let resizeImage: UIImage = image.ResizeUIImage(width:  imageView.frame.width, height:imageView.frame.height)
//                    imageView.image = resizeImage
//                    if RealmModel.realm.usersSet[ViewController.vc.index].urlData.count == 2 {
//                        alertView.alertVcNotEdit(view: self)
//                    }
//                }
                if seArray.contains(indexPath.section-2) {
                    let index = seArray.index(of: indexPath.section-2)
                    seArray.remove(at: index!)
                    vm.checkArray.remove(indexPath.section-2)
                } else {
                    seArray.append(indexPath.section-2)
                    vm.checkArray.add(indexPath.section-2)
                }
//                print(seArray)
//                collectionView.reloadData()
        }
    }

}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        maskLayer.imageReSet(view: self.view, imageView: imageView, image: image)
        SVProgressHUD.show()
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType == kUTTypeMovie {
            vm.setVideoURLView.setURL(url: info[UIImagePickerControllerMediaURL] as! URL, view: self)
            vm.setVideoURLView.frame = CGRect(x:0,y:0,width: self.view.frame.width, height: self.view.frame.width/15)
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                picker.dismiss(animated: true, completion: nil)
                for _ in 0..<self.vm.setVideoURLView.thumbnailViews.count {
                    self.gifObject.makeGifImageMovie(url: info[UIImagePickerControllerMediaURL] as! URL, vm: self.vm,frameY: 10.0, createBool: true, scale: 10.0, imageAr: (self.vm.setVideoURLView.imageAr))
                    self.cView.backgroundColor = .clear
                }
                SVProgressHUD.dismiss()
                return
            }
        }
        vm.setVideoURLView.data.removeAll()
        image = UIImage()
        imageView = UIImageView()
        guard let images = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        image = images
        SVProgressHUD.dismiss()
        picker.dismiss(animated: true, completion: nil)
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
