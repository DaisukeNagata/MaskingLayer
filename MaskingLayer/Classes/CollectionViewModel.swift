//
//  CollectionViewModel.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/08/30.
//

import UIKit

public final class CollectionViewModel: NSObject {
    public var checkArray:NSMutableArray = []
    var checkLabel:UILabel!
    let imageList = ["IMG_4011.jpg","IMG_4011.jpg"]
    var image = UIImage()
    public var setVideoURLView = SetVideoURLView()
}

// MARK: UICollectionViewDataSource
extension CollectionViewModel: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return 1 }
    public func numberOfSections(in collectionView: UICollectionView) -> Int { return setVideoURLView.data.count + 2 }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomDissmissCell", for: indexPath) as! CustomDissmissCell
        if indexPath.section < 2 {
            image = UIImage(named: imageList[indexPath.section])!
            let resizeImage: UIImage = image.ResizeUIImage(width:  88, height: 88)
            image = resizeImage
            var transRotate = CGAffineTransform()
            let angle = -90 * CGFloat.pi / 180
            transRotate = CGAffineTransform(rotationAngle: CGFloat(angle));
            cell.transform = transRotate
            cell.imageSet(imageSet: image)
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
            let dataImages = setVideoURLView.data.map { (images) -> UIImage in
                let resizeImage: UIImage = UIImage(data: images)!.ResizeUIImage(width: 88, height:88)
                return  resizeImage
            }
            for subview in cell.contentView.subviews{ subview.removeFromSuperview() }
            if checkArray.contains(indexPath.section-2){
                checkLabel = UILabel()
                checkLabel.frame = CGRect(x:0,y:0,width:30,height:30)
                checkLabel.layer.position = CGPoint(x: cell.layer.frame.width - 10, y: 10)
                checkLabel.text = "✅"
                cell.contentView.addSubview(checkLabel)
            }
            cell.imageSet(imageSet: dataImages[indexPath.section-2])
            return cell
        }
        return cell
    }
}
