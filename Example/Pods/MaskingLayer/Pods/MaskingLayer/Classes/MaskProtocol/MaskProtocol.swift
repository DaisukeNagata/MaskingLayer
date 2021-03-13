//
//  MaskProtocol.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2019/08/24.
//

import Foundation

protocol CViewProtocol {
    func maskPathBegan(position: CGPoint)
    func maskAddLine(position: CGPoint)
    func maskPathEnded(position: CGPoint, model: MaskingLayerModel?)
}

protocol MaskPathElement {
    func add(to path:CGMutablePath) -> CGMutablePath
    func addAsPolygon(to path:CGMutablePath) -> CGMutablePath
}

protocol Observer {
    func observe<O>(for observable: MaskObservable<O>, with: @escaping (O) -> Void)
}
