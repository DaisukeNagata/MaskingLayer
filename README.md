<p align="center">
<img src="https://user-images.githubusercontent.com/16457165/68517602-9a62bc00-02cb-11ea-9571-518f19ea8277.png?raw=true" width="500" height="700">
</p>

# MaskingLayer
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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mO = MaskingLayerViewModel(minSegment: 15)
        let MV = MaskGestureViewModel(mO: mO, vc: self)
        MV.maskGestureView?.frame = view.frame
        view.addSubview(MV.maskGestureView ?? UIView())

        mO.frameResize(images: UIImage(named: "IMG_4011")!)
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

## Version 1.0.0 ~

```ruby
1. Select hair dyeing with a long tap

2. Selfie with red button

3. Save the photo with the blue button

Screen operation
1. Up swipe is Display of slider bar
2. Long tap is Hide slider bar
```
## Operation link
```ruby
https://twitter.com/dbank0208/status/1192846922563739649?s=20
```

## Example Code
```ruby
import UIKit
import MaskingLayer

class CameraViewController: UIViewController {

    static func identifier() -> String { return String(describing: ViewController.self) }

    static func viewController() -> ViewController {

        let sb = UIStoryboard(name: "Camera", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! ViewController
        return vc
    }

    private var mVM              : MaskingLayerViewModel? = nil
    private var mBObject         : MaskButtonView? = nil
    private var d: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        d = UIView(frame: CGRect(x: 0, y: 44, width: self.view.frame.width, height: self.view.frame.height - 188))
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        mBObject?.cameraMatte.isHidden = false
        mBObject?.cameraRecord.isHidden = false
        
        mVM = MaskingLayerViewModel(vc: self)
        mBObject = MaskButtonView(frame: self.tabBarController?.tabBar.frame ?? CGRect())

        self.tabBarController?.tabBar.addSubview(mBObject?.cameraMatte ?? UIButton())
        self.tabBarController?.tabBar.addSubview(mBObject?.cameraRecord ?? UIButton())

        mBObject?.cameraMatte.addTarget(self, action: #selector(btAction), for: .touchUpInside)
        mBObject?.cameraRecord.addTarget(self, action: #selector(cameraAction), for: .touchUpInside)

        view.addSubview(d ?? UIView())
        mVM?.cmareraPreView(d ?? UIView())

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

        mBObject?.cameraMatte.isHidden = true
        mBObject?.cameraRecord.isHidden = true
        d?.removeFromSuperview()
        mVM?.cameraReset()
        mVM = nil
    }

    // DyeHair Set
    @objc func btAction() { mVM?.btAction() }

    // Save photosAlbum
    @objc func cameraAction() { mVM?.cameraAction() }

}

```
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


