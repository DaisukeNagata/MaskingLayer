//
//  MaskCollectionViewModel.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/08/30.
//

import UIKit

final class MaskCollectionViewModel: NSObject {

    var rotate: CGFloat = 0
    var checkLabel: UILabel?
    var checkArray: NSMutableArray = []
    var setVideoURLView = MaskVideoURLView()

    private var image: UIImage?

    private let editCount: Int = 1
    private let collectionLabel: CGFloat = 30
    private let checkLabelItemSize: CGFloat = 10
    private let collectionItemSize: CGFloat = 88
    let imageList = ["IMG_4011.jpg"]
    
    private var transRotate = CGAffineTransform()
}

// MARK: UICollectionViewDataSource
extension MaskCollectionViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return 1 }

    func numberOfSections(in collectionView: UICollectionView) -> Int { return setVideoURLView.dataArray.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaskCustomCell", for: indexPath) as! MaskCustomCell

        if indexPath.section < editCount {
            image = UIImage(named: imageList[indexPath.section]) ?? UIImage()
            image = image?.ResizeUIImage(width:  collectionItemSize, height: collectionItemSize)

            let angle = rotate * CGFloat.pi / 180
            transRotate = CGAffineTransform(rotationAngle: CGFloat(angle))
            cell.transform = transRotate
            cell.imageSet(imageSet: image ?? UIImage())
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaskDismissCell", for: indexPath) as! MaskDismissCell
            for subview in cell.contentView.subviews{ subview.removeFromSuperview() }

            checkLabel = nil
            if checkArray.contains(indexPath.section) {
                checkLabel = UILabel()
                checkLabel?.frame = CGRect(x:0,y:0,width:collectionLabel,height:collectionLabel)
                checkLabel?.layer.position = CGPoint(x: cell.layer.frame.width + checkLabelItemSize, y: checkLabelItemSize)
                checkLabel?.text = "✅"
                cell.contentView.addSubview(checkLabel!)
            }
            cell.imageSet(imageSet: setVideoURLView.dataArray[indexPath.section])
            return cell
        }
        return cell
    }
}
