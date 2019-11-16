//
//  ColorPaletteViewModel.swift
//  MaskingLayer_Example
//
//  Created by 永田大祐 on 2019/11/16.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

enum Images {
    case maskWhite,maskLightGray,maskGray,maskDarkGray,maskLightBlack
    var imageSet: UIColor {
        switch self {
        case .maskWhite: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .maskLightGray: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        case .maskGray: return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        case .maskDarkGray:  return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case .maskLightBlack: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
}

class ColorPaletteViewModel: NSObject {
    let imagesRows: [Images] = [.maskWhite,.maskLightGray,.maskGray,.maskDarkGray,.maskLightBlack]
}

// MARK: UICollectionViewDataSource
extension ColorPaletteViewModel: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesRows.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorPaletteCell", for: indexPath) as! ColorPaletteCell
        cell.config(color: imagesRows[indexPath.row].imageSet)
        return cell
    }
}
