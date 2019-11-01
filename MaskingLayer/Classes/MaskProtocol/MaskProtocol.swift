//
//  MaskProtocol.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2019/08/24.
//

import Foundation

protocol CViewProtocol {
    func maskPathBegan(position: CGPoint, imageView: UIImageView)
    func maskAddLine(position: CGPoint, imageView: UIImageView)
    func maskPathEnded(position: CGPoint,view: UIView)
    func maskGif()
    func setURL()
}

protocol MaskPathElement {
    func add(to path:CGMutablePath) -> CGMutablePath
    func addAsPolygon(to path:CGMutablePath) -> CGMutablePath
}

public protocol Observer {
    func observe<O>(for observable: MaskObservable<O>, with: @escaping (O) -> Void)
}
