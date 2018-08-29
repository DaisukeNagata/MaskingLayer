//
//  RangeCollectionViewModel.swift
//  TalkingRecord
//
//  Created by 永田大祐 on 2018/07/08.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit
import AVKit
import SVProgressHUD

public final class RangeCollectionViewModel: NSObject {

    var setVideoURLView = SetVideoURLView2()
    var cells = RangeCollectionCell()
    var checkArray:NSMutableArray = []
    var checkLabel:UILabel!
    var imageList = ["Arrow","reload"]
    func design() {
        if RealmModel.realm.usersSet[ViewController.vc.index].urlData.count == 0 {
            setVideoURLView.setURL(url: URL(string: RealmModel.realm.usersSet[ViewController.vc.index].urlSet!)!, index: 0)
            setVideoURLView.frame = CGRect(x:0, y: 400, width: (UIScreen.main.bounds.width) , height: (UIScreen.main.bounds.width)/15)
        }
    }
}
// MARK: UICollectionViewDataSource
extension RangeCollectionViewModel: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return RealmModel.realm.usersSet[ViewController.vc.index].urlData.count + 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "RangeBackCollectionCell", for: indexPath) as! RangeBackCollectionCell
        if indexPath.section < 2 {
            var image = UIImage()
            image = UIImage(named: imageList[indexPath.section])!
            var transRotate = CGAffineTransform()
            let angle = -90 * CGFloat.pi / 180
            transRotate = CGAffineTransform(rotationAngle: CGFloat(angle));
            cells.transform = transRotate
            cells.imageSet(imageSet: image)
            SVProgressHUD.dismiss()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RangeCollectionCell", for: indexPath) as! RangeCollectionCell
            try! RealmModel.realm.realmTry.write {
                let dataImages = RealmModel.realm.usersSet[ViewController.vc.index].urlData.map { (images) -> UIImage in
                    let resizeImage: UIImage = UIImage(data: images)!.ResizeUIImage(width: 88, height:88)
                    return  resizeImage
                }
               
                for subview in cell.contentView.subviews{
                    subview.removeFromSuperview()
                }
                if checkArray.contains(indexPath.section-2){
                    checkLabel = UILabel()
                    checkLabel.frame = CGRect(x:0,y:0,width:30,height:30)
                    checkLabel.layer.position = CGPoint(x: cell.layer.frame.width - 10, y: 10)
                    checkLabel.text = "✅"
                    cell.contentView.addSubview(checkLabel)
                }
                cell.imageSet(imageSet: dataImages[indexPath.section-2])
            }
            SVProgressHUD.dismiss()
            self.cells = cell
            return cell
        }
        return cells
    }
}
