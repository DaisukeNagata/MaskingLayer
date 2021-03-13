//
//  MaskingLayerModel.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2021/03/13.
//

import Foundation

public struct MaskingLayerModel {
    public var windowSizeWidth: CGFloat
    public var windowSizeHeight: CGFloat
    public var windowColor: UIColor
    public var windowAlpha: CGFloat
    public var imageView: UIImageView
    public var windowFrameView: UIView?
    public var imageBackView: UIImageView?
    public var defaltImageView: UIImageView
    public var maskGestureView: UIView?
    public var image: UIImage
}
