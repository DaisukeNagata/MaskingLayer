//
//  AcpectMargin.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/09/24.
//

import Foundation

struct Margin {

    let iPhoneSmall : CGFloat = 568.0
    let iPhone : CGFloat = 667.0
    let iPhonePlus : CGFloat = 736.0
    let iPhoneX : CGFloat = 812.0
    let iPhoneXR : CGFloat = 896.0
    let iPhoneXSMAX : CGFloat = 896.0


    static var current: MarginProtocol.Type {
        let deviceType = UIScreen.main.bounds.height

        switch deviceType {
        case Margin().iPhoneSmall:
            return iPhoneMargin.self

        case Margin().iPhone:
            return iPhoneMargin.self

        case Margin().iPhonePlus:
            return iPhonePlusMargin.self

        case Margin().iPhoneX:
            return iPhoneXMargin.self

        case Margin().iPhoneXR:
            return iPhoneXMargin.self

        case Margin().iPhoneXSMAX:
            return iPhoneXMargin.self

        default:
            break
        }
        return iPhoneMargin.self
    }
}

protocol MarginProtocol {
    static var xOrigin: CGFloat { get }
    static var yOrigin: CGFloat { get }
    static var width:   CGFloat { get }
    static var height:  CGFloat { get }
}
struct iPhoneSmallMargin: MarginProtocol {
    static var xOrigin: CGFloat { return 20 }
    static var yOrigin: CGFloat { return 80 }
    static var width:   CGFloat  { return UIScreen.main.bounds.width - xOrigin*2 }
    static var height:  CGFloat { return UIScreen.main.bounds.width*1.5 - yOrigin }
}
struct iPhoneMargin: MarginProtocol {
    static var xOrigin: CGFloat { return 20 }
    static var yOrigin: CGFloat { return 80 }
    static var width:   CGFloat  { return UIScreen.main.bounds.width - xOrigin*2 }
    static var height:  CGFloat { return UIScreen.main.bounds.width*1.5 - yOrigin }
}
struct iPhonePlusMargin: MarginProtocol {
    static var xOrigin: CGFloat { return 20 }
    static var yOrigin: CGFloat { return 80 }
    static var width:   CGFloat  { return UIScreen.main.bounds.width - xOrigin*2 }
    static var height:  CGFloat { return UIScreen.main.bounds.width*1.5 - yOrigin }
}
struct iPhoneXMargin: MarginProtocol {
    static var xOrigin: CGFloat { return 20 }
    static var yOrigin: CGFloat { return 120 }
    static var width:   CGFloat  { return UIScreen.main.bounds.width - xOrigin*2 }
    static var height:  CGFloat { return UIScreen.main.bounds.width*1.7 - yOrigin }
}
