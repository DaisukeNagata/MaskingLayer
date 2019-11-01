//
//  MaskGifObject.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/06/26.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import Foundation
import Photos
import ImageIO
import MobileCoreServices

public class MaskGifObject: NSObject {

    var fileProperties = [String: [String: Int]]()
    var frameProperties = [String: [String: Float64]]()

    public func makeGifImageMovie(url: URL,frameY: Double, createBool: Bool,scale: CGFloat,imageAr: Array<CGImage>) {
        let frameRate = CMTimeMake(value: 1,timescale: Int32(frameY))
        let urlDefo = UserDefaults.standard

        let fileProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 1]]
        let frameProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String :CMTimeGetSeconds(frameRate)]]
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, kUTTypeGIF, imageAr.count, nil) else { print("ng"); return }

        CGImageDestinationSetProperties(destination,fileProperties as CFDictionary?)

        for image in imageAr{ CGImageDestinationAddImage(destination,image,frameProperties as CFDictionary?) }
        if CGImageDestinationFinalize(destination){
            urlDefo.set(url, forKey: "url")
            print("ok");}
    }
}
