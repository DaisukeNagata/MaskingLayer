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
    let iPhoneX : CGFloat = 832.0
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
            return iPhonePlusMargin.self

        case Margin().iPhoneXR:
            return iPhonePlusMargin.self

        case Margin().iPhoneXSMAX:
            return iPhonePlusMargin.self
        
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
    static var yOrigin: CGFloat { return 40 }
    static var width:   CGFloat { return UIScreen.main.bounds.width - yOrigin }
    static var height:  CGFloat { return UIScreen.main.bounds.width*1.777 - yOrigin }
}
struct iPhoneMargin: MarginProtocol {
    static var xOrigin: CGFloat { return 20 }
    static var yOrigin: CGFloat { return 40 }
    static var width:   CGFloat  { return UIScreen.main.bounds.width - yOrigin }
    static var height:  CGFloat { return UIScreen.main.bounds.width*1.777 - yOrigin }
}
struct iPhonePlusMargin: MarginProtocol {
    static var xOrigin: CGFloat { return 20 }
    static var yOrigin: CGFloat { return 40 }
    static var width:   CGFloat  { return UIScreen.main.bounds.width - yOrigin }
    static var height:  CGFloat { return UIScreen.main.bounds.width*1.777 - yOrigin }
}
struct iPhoneXR: MarginProtocol {
    static var xOrigin: CGFloat { return 20 }
    static var yOrigin: CGFloat { return 40 }
    static var width:   CGFloat  { return UIScreen.main.bounds.width - yOrigin }
    static var height:  CGFloat { return UIScreen.main.bounds.width*2 - yOrigin }
}
struct iPhoneXSMAX: MarginProtocol {
    static var xOrigin: CGFloat { return 20 }
    static var yOrigin: CGFloat { return 40 }
    static var width:   CGFloat { return UIScreen.main.bounds.width - yOrigin }
    static var height:  CGFloat { return UIScreen.main.bounds.width*2 - yOrigin }
}
