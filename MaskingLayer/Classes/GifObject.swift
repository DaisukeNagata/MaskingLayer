//
//  GifObject.swift
//  TalkingRecord
//
//  Created by 永田大祐 on 2018/06/26.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import Foundation
import Photos
import ImageIO
import MobileCoreServices

public class GifObject: NSObject {

    var fileProperties = [String: [String: Int]]()
    var frameProperties = [String: [String: Float64]]()

    public func makeGifImageMovie(url :URL,frameY: Double, views: UIViewController, createBool: Bool,scale: CGFloat,imageAr: Array<CGImage>)->URL{
        let frameRate = CMTimeMake(1,Int32(frameY))

        let fileProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 1]]
        let frameProperties = [kCGImagePropertyGIFDictionary as String:[kCGImagePropertyGIFDelayTime as String :CMTimeGetSeconds(frameRate)]]
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL,kUTTypeGIF,imageAr.count,nil) else { print("ng"); return url }

        CGImageDestinationSetProperties(destination,fileProperties as CFDictionary?)

        for image in imageAr{ CGImageDestinationAddImage(destination,image,frameProperties as CFDictionary?) }
        if CGImageDestinationFinalize(destination){ print("ok"); return url }
        return url
    }
}

public extension UIImageView {
    func animateGIF(data: Data, duration: Double,
                    animationRepeatCount: UInt = 1,
                    completion: (() -> Void)? = nil) {
        guard let animatedGIFImage = UIImage().animatedGIF(data: data, duration: duration) else { return }

        self.image = animatedGIFImage.images?.last
        self.animationImages = animatedGIFImage.images
        self.animationDuration = animatedGIFImage.duration
        self.animationRepeatCount = Int(animationRepeatCount)
        self.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + animatedGIFImage.duration * Double(animationRepeatCount)) {
            completion?()
        }
    }
}

extension UIImage {
     func animatedGIF(data: Data,duration: Double)  -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        var speed = 0.0;speed = duration
        let count = CGImageSourceGetCount(source)
        var images: [UIImage] = []
    
        for i in 0..<count {

            guard let imageRef = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
            guard let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any] else { continue }
            guard let gifDictionary = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] else { continue }
            guard (gifDictionary[kCGImagePropertyGIFDelayTime as String] as? Double) != nil else { continue }

            let image = UIImage(cgImage: imageRef, scale: UIScreen.main.scale, orientation: .up)
            UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
            image.draw(in: CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height))
            let renderedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let renderedImage = renderedImage {
                images.append(renderedImage)
            }
        }
        return UIImage.animatedImage(with: images, duration: speed)
    }
}
