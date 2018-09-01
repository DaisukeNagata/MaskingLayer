//
//  MaskCollectionViewModel.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/08/30.
//

import UIKit

public final class MaskCollectionViewModel: NSObject {

    var image = UIImage()
    public var rotate: CGFloat = 0
    let collectionLabel: CGFloat = 30
    let checkLabelItemSize: CGFloat = 10
    let collectionItemSize: CGFloat = 88
    let imageList = ["IMG_4011.jpg","Reset"]
    public var checkLabel:UILabel!
    public var checkArray:NSMutableArray = []
    public var setVideoURLView = MaskVideoURLView()
}

// MARK: UICollectionViewDataSource
extension MaskCollectionViewModel: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return 1 }
    public func numberOfSections(in collectionView: UICollectionView) -> Int { return setVideoURLView.dataArray.count + 2 }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaskCustomCell", for: indexPath) as! MaskCustomCell
        if indexPath.section < 2 {
            image = UIImage(named: imageList[indexPath.section])!
            let resizeImage: UIImage = image.ResizeUIImage(width:  collectionItemSize, height: collectionItemSize)
            image = resizeImage
            var transRotate = CGAffineTransform()
            let angle = rotate * CGFloat.pi / 180
            transRotate = CGAffineTransform(rotationAngle: CGFloat(angle));
            cell.transform = transRotate
            cell.imageSet(imageSet: image)
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaskDismissCell", for: indexPath) as! MaskDismissCell
            let dataImages = setVideoURLView.dataArray.map { (images) -> UIImage in
                let resizeImage: UIImage = UIImage(data: images)!.ResizeUIImage(width: collectionItemSize, height:collectionItemSize)
                return  resizeImage
            }
            for subview in cell.contentView.subviews{ subview.removeFromSuperview() }
            checkLabel = nil
            if checkArray.contains(indexPath.section-2){
                checkLabel = UILabel()
                checkLabel.frame = CGRect(x:0,y:0,width:collectionLabel,height:collectionLabel)
                checkLabel.layer.position = CGPoint(x: cell.layer.frame.width + checkLabelItemSize, y: checkLabelItemSize)
                checkLabel.text = "✅"
                cell.contentView.addSubview(checkLabel)
            }
            cell.imageSet(imageSet: dataImages[indexPath.section-2])
            return cell
        }
        return cell
    }
}
