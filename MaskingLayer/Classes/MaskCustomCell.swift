//
//  MaskCustomCell.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/08/30.
//

import UIKit

public class MaskCustomCell: UICollectionViewCell {

    var customCell = UIImageView()
    let collectionItemSize: CGFloat = 88

    public override init(frame: CGRect) {
        super.init(frame: frame)

        customCell.frame.size = CGSize(width: collectionItemSize, height: collectionItemSize)
        self.addSubview(customCell)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    static let identifier: UINib = UINib(nibName: "MaskCustomCell", bundle: nil)
    public func imageSet(imageSet: UIImage){ customCell.image = imageSet }
}
