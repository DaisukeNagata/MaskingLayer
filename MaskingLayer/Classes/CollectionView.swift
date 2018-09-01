//
//  CollectionView.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/08/30.
//

import UIKit

public final class CollectionView: UIView {

    let sampleImageSize: CGFloat = 88
    let sampleImageView: CGFloat = 88

    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.itemSize = CGSize(width: sampleImageSize, height: sampleImageSize)
        layout.scrollDirection = .horizontal
        collectionView.register(CustomCell.identifier, forCellWithReuseIdentifier: "CustomCell")
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "CustomCell")
        collectionView.register(CustomDissmissCell.identifier, forCellWithReuseIdentifier: "CustomDissmissCell")
        collectionView.register(CustomDissmissCell.self, forCellWithReuseIdentifier: "CustomDissmissCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
   public var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 100)

        addSubview(scrollView)
        scrollView.addSubview(collectionView)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        collectionView.frame = self.frame
        scrollView.frame = self.frame
        scrollView.contentSize.height = self.frame.height
        self.frame.origin.y = UIScreen.main.bounds.height - 120
    }
}
