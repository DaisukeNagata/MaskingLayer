//
//  MaskVideoURLView.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/06/23.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit
import AVFoundation

public class MaskVideoURLView: UIView {

    var duration: Float64   = 0.0
    var videoURL  = URL(fileURLWithPath: "")
    public let imageView = UIImageView()
    public var imageAr = Array<CGImage>()
    public var thumbnailViews = [UIImageView]()
    public var dataArray = Array<Data>()


    override init(frame: CGRect) {
        super.init(frame: frame)

        self.frame = UIScreen.main.bounds
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setURL() {
        let defo = UserDefaults.standard
        guard let url =  defo.url(forKey: "url") else { return }
        self.duration = MaskVideoURLView().videoDuration(videoURL: url)
        self.videoURL = url
        self.superview?.layoutSubviews()
        self.updateThumbnails()
    }

    func updateThumbnails(){

        let backgroundQueue = DispatchQueue(label: "com.app.queue", qos: .background, target: nil)
        backgroundQueue.async { _ = self.updateThumbnails(view: self, videoURL: self.videoURL, duration: self.duration) }
    }

    private func thumbnailCount(inView: UIView) -> Int {
        var num :Double = 0

        DispatchQueue.main.sync { num = Double(inView.frame.size.width) / Double(inView.frame.size.height) }
        return Int(ceil(num))
    }

    private func thumbnailFromVideo(videoUrl: URL, time: CMTime) -> UIImage {
        let asset: AVAsset = AVAsset(url: videoUrl) as AVAsset
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        do{
            let cgImage = try imgGenerator.copyCGImage(at: time, actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage
        } catch { print("error") }

        return UIImage()
    }

    private func updateThumbnails(view: UIView, videoURL: URL, duration: Float64) -> [UIImageView] {
        var thumbnails = [UIImage]()
        var offset: Float64 = 0

        for view in self.thumbnailViews{
            DispatchQueue.main.sync { view.removeFromSuperview() }
        }

        let imagesCount = self.thumbnailCount(inView: view)
        for i in 0..<imagesCount{
            DispatchQueue.main.sync {
                let thumbnail = thumbnailFromVideo(videoUrl: videoURL,
                                                   time: CMTimeMake(value: Int64(offset), timescale: 1))
                offset = Float64(i) * (duration / Float64(imagesCount))
                thumbnails.append(thumbnail)
            }
        }
        self.addImagesToView(images: thumbnails, view: view)
        return self.thumbnailViews
    }

    private func videoDuration(videoURL: URL) -> Float64 {
        let source = AVURLAsset(url: videoURL)
        return CMTimeGetSeconds(source.duration)
    }

    private func addImagesToView(images: [UIImage], view: UIView) {

        thumbnailViews.removeAll()
        dataArray.removeAll()
        imageAr.removeAll()
        var xPos: CGFloat = 0.0
        var width: CGFloat = 0.0
        for image in images{
            DispatchQueue.main.sync {
                if xPos + view.frame.size.height < view.frame.width {
                    width = view.frame.size.height
                }else{
                    width = view.frame.size.width - xPos
                }
                imageView.image = image
                imageView.alpha = 0
                imageView.clipsToBounds = true
                imageView.frame = CGRect(x: xPos,
                                         y: 0.0,
                                         width: width,
                                         height: 0.1)
                let data = imageView.image!.pngData()
                dataArray.append(data!)
                thumbnailViews.append(imageView)
                imageAr.append((imageView.image?.cgImage)!)
                imageAr[thumbnailViews.count-1] = (imageView.image?.cgImage?.resize(imageView.image!.cgImage!))!
                view.sendSubviewToBack(imageView)
                xPos = xPos + view.frame.size.height
            }
        }
    }
}
