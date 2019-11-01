![image](https://github.com/daisukenagata/MaskingLayer/blob/master/MaskImage.png?raw=true)

# MaskingLayer Xcode11 Swift5
[![Version](https://img.shields.io/cocoapods/v/MaskingLayer.svg?style=flat)](https://cocoapods.org/pods/MaskingLayer)
[![License](https://img.shields.io/cocoapods/l/MaskingLayer.svg?style=flat)](https://cocoapods.org/pods/MaskingLayer)
[![Platform](https://img.shields.io/cocoapods/p/MaskingLayer.svg?style=flat)](https://cocoapods.org/pods/MaskingLayer)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
You can select background color, camera roll, video roll with long tap.
 
Example ViewController
```ruby
import UIKit
import MaskingLayer

class ViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    var mO = MaskingLayerViewModel(minSegment: 15)

    override func viewDidLoad() {
        super.viewDidLoad()

        let maskGestureView = MaskGestureView(mO: mO)
        maskGestureView.frame = view.frame
        mO.frameResize(images: UIImage(named: "IMG_4011")!)

        view.addSubview(maskGestureView)
        view.addSubview(mO.imageView)
        view.layer.addSublayer(mO.maskLayer.clipLayer)

        mO.masPathSet()

        mO.observe(for: mO.maskCount) { _ in
            self.mO.maskCount.initValue()
            guard self.mO.vm.setVideoURLView.dataArray.count == 0 else {  self.view.addSubview( self.mO.cView); return }

            let defo = UserDefaults.standard
            guard defo.object(forKey: "url") == nil else {

                self.mO.maskPortraitMatte(minSegment: 15)
                if self.mO.imageBackView.image != nil { self.mO.gousei() }
                return
            }
        }

        mO.observe(for: mO.longTappedCount) { _ in
            self.mO.longTappedCount.initValue()
            self.mO.maskLayer.alertSave(views: self,mo: self.mO)
        }

        mO.observe(for: mO.backImageCount) { _ in
            self.mO.backImageCount.initValue()
            self.mO.imageBackView.image = self.mO.imageView.image
            self.mO.imageBackView.frame = self.mO.imageView.frame
            self.mO.imageBackView.setNeedsLayout()
        }
    }
}

```


## Version 0.4.2
You can generate a GIF image by pressing the leftmost image.


## Gif
![](https://github.com/daisukenagata/MaskingLayer/blob/master/gif%20or%20image/MovieImage.gif?raw=true)
![](https://github.com/daisukenagata/MaskingLayer/blob/master/gif%20or%20image/MovieGif.gif?raw=true)



## Version 0.5  Version 0.5.1
Os12 portrait camera with iphoneX or higher, masking images where people are reflections
![](https://github.com/daisukenagata/MaskingLayer/blob/master/gif%20or%20image/MovieMatte.gif?raw=true)
![](https://github.com/daisukenagata/MaskingLayer/blob/master/gif%20or%20image/IMG_0073.TRIM.gif?raw=true)
## Version 0.6.4
Press BackImage with a long tap and decide the background, then select portrait camera image
<img src= "https://github.com/daisukenagata/MaskingLayer/blob/master/gif%20or%20image/5453.jpg?raw=true" width="330" height="500">

## Version 0.6.5
Added a compositing function that can be saved to the terminal.



## Version 0.8 ~

The left is the latest version. Perform a smooth crop.
![](https://user-images.githubusercontent.com/16457165/63633553-2ed26080-c685-11e9-8c91-17e3eb36dc3f.gif)


## Installation

MaskingLayer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MaskingLayer'
```

## Author

daisukenagata, dbank0208@gmail.com

## License

MaskingLayer is available under the MIT license. See the LICENSE file for more info.


