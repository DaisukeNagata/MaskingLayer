//
//  MaskCollectionView.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/08/30.
//

import UIKit

final class MaskCollectionView: UIView {

    let viewOrigin: CGFloat = 120
    let viewHeight: CGFloat = 100
    let collectionItemSize: CGFloat = 88

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.itemSize = CGSize(width: collectionItemSize, height: collectionItemSize)
        layout.scrollDirection = .horizontal
        collectionView.register(MaskCustomCell.identifier, forCellWithReuseIdentifier: "MaskCustomCell")
        collectionView.register(MaskCustomCell.self, forCellWithReuseIdentifier: "MaskCustomCell")
        collectionView.register(MaskDismissCell.identifier, forCellWithReuseIdentifier: "MaskDismissCell")
        collectionView.register(MaskDismissCell.self, forCellWithReuseIdentifier: "MaskDismissCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.frame.size = CGSize(width: UIScreen.main.bounds.width, height: viewHeight)

        addSubview(scrollView)
        scrollView.addSubview(collectionView)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.frame = self.frame
        scrollView.frame = self.frame
        scrollView.contentSize.height = self.frame.height
        self.frame.origin.y = UIScreen.main.bounds.height - (self.frame.height/2 + viewOrigin)
    }
}
