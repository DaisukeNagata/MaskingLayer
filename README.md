![image](https://github.com/daisukenagata/MaskingLayer/blob/master/MaskImage.png?raw=true)

# MaskingLayer Xcode10 Swift4.2
[![Version](https://img.shields.io/cocoapods/v/MaskingLayer.svg?style=flat)](https://cocoapods.org/pods/MaskingLayer)
[![License](https://img.shields.io/cocoapods/l/MaskingLayer.svg?style=flat)](https://cocoapods.org/pods/MaskingLayer)
[![Platform](https://img.shields.io/cocoapods/p/MaskingLayer.svg?style=flat)](https://cocoapods.org/pods/MaskingLayer)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
You can select background color, camera roll, video roll with long tap.
 

Setting the layer image
```ruby
mO.maskLayer.imageSet(view: view, imageView: mO.imageView, image: mO.image)
```
 
Start of masking start point
```ruby
mO.maskPath(position: position, view: view, imageView: mO.imageView, bool: true)
```

Continuation of masked lines
```ruby
mO.maskAddLine(position: position, view: view, imageView: mO.imageView, bool: false)
```

Rebuild instance to be masked or clear data
```ruby
mO.resetCView(views: self, imageView: mO.imageView, image: mO.image)
```

Generate thumbnail image
```ruby
mO.setURL(url: info[UIImagePickerControllerMediaURL] as! URL, vc: self)
```

Generation of Gif image
```ruby
mO.maskGif(url: info[UIImagePickerControllerMediaURL] as! URL)
```

## Version 0.4.2
You can generate a GIF image by pressing the leftmost image.


## Gif
![](https://github.com/daisukenagata/MaskingLayer/blob/master/MovieImage.gif)
![](https://github.com/daisukenagata/MaskingLayer/blob/master/MovieGif.gif)

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

## Version 0.5
Os12 portrait camera with iphoneX or higher, masking images where people are reflections
![](https://github.com/daisukenagata/MaskingLayer/blob/master/MovieMatte.gif?raw=true)

