//
//  PathStruct.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2019/08/24.
//

import Foundation

struct MaskPath {
    static func path(from elements:[MaskPathElement], path: CGMutablePath) -> CGMutablePath {
        return elements.reduce(path) { (path, element) -> CGMutablePath in
            return element.add(to: path)
        }
    }
}

struct MaskMove: MaskPathElement {
    let pt:CGPoint
    init(x:CGFloat, y:CGFloat) {
        pt = CGPoint(x: x,y: y)
    }
    init(pt:CGPoint) {
        self.pt = pt
    }
    
    public func add(to path:CGMutablePath) -> CGMutablePath {
        path.move(to: pt)
        return path
    }
}

struct MaskLine: MaskPathElement {
    let pt:CGPoint
    init(x:CGFloat, y:CGFloat) {
        pt = CGPoint(x: x,y: y)
    }
    init(pt:CGPoint) {
        self.pt = pt
    }
    
    public func add(to path:CGMutablePath) -> CGMutablePath {
        path.addLine(to: pt)
        return path
    }
}

struct MaskQuadCurve: MaskPathElement {
    let cp:CGPoint
    let pt:CGPoint
    init(cpx: CGFloat, cpy: CGFloat, x: CGFloat, y: CGFloat) {
        cp = CGPoint(x: cpx, y: cpy)
        pt = CGPoint(x: x, y: y)
    }

    init(cp:CGPoint, pt:CGPoint) {
        self.cp = cp
        self.pt = pt
    }

    func add(to path:CGMutablePath) -> CGMutablePath {
        path.addQuadCurve(to: pt, control: cp)
        return path
    }
}
