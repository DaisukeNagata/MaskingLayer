//
//  ColorPaletteCell.swift
//  MaskingLayer_Example
//
//  Created by 永田大祐 on 2019/11/16.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

final class ColorPaletteCell: UICollectionViewCell {

    var paletteLabel = UILabel() 

    let identifier: UINib = UINib(nibName: "ColorPaletteCell", bundle: nil)

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 44
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 44

        paletteLabel.frame.size = CGSize(width: 88, height: 88)
        self.addSubview(paletteLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func config(color: UIColor) { paletteLabel.backgroundColor = color }
}
