//
//  ColorPaletteView.swift
//  MaskingLayer_Example
//
//  Created by 永田大祐 on 2019/11/16.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

final class ColorPaletteView: UIView {

    let vm = ColorPaletteViewModel()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 88, height: 88)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ColorPaletteCell().identifier, forCellWithReuseIdentifier: "ColorPaletteCell")
        collectionView.register(ColorPaletteCell.self, forCellWithReuseIdentifier: "ColorPaletteCell")
        collectionView.frame = UIScreen.main.bounds
        return collectionView
    }()

    public init() {
        super.init(frame: .zero)

        collectionView.dataSource = vm
        self.frame = UIScreen.main.bounds
        self.addSubview(collectionView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
