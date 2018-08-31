//
//  CustomDissmissCell.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/08/31.
//

import UIKit

public class CustomDissmissCell :UICollectionViewCell {
    
    var customCell = UIImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        customCell.frame.size = CGSize(width: 88, height: 88)
        self.addSubview(customCell)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    static let identifier: UINib = UINib(nibName: "CustomDissmissCell", bundle: nil)
    public func imageSet(imageSet: UIImage){ customCell.image = imageSet }
}

