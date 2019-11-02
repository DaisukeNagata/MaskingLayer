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

final class MaskGifObject: NSObject {

    var fileProperties = [String: [String: Int]]()
    var frameProperties = [String: [String: Float64]]()

    func makeGifImageMovie(url: URL,frameY: Double, imageAr: Array<CGImage>) {
        let frameRate = CMTimeMake(value: Int64(frameY), timescale: Int32(frameY))
        let urlDefo = UserDefaults.standard

        let component = url.pathComponents
        guard let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(component[7]).gif") else { print("ng"); return }
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, kUTTypeGIF, imageAr.count, nil) else { print("ng"); return }

        let fileProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 1]]
        let frameProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String :CMTimeGetSeconds(frameRate)]]

        CGImageDestinationSetProperties(destination,fileProperties as CFDictionary?)

        for image in imageAr{ CGImageDestinationAddImage(destination,image,frameProperties as CFDictionary?) }
        if CGImageDestinationFinalize(destination){
            urlDefo.set(url, forKey: "url")
            print("ok");}
    }
}
