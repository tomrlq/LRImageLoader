# LRImageLoader

[![Pod Version](http://img.shields.io/cocoapods/v/LRImageLoader.svg?style=flat)](https://cocoapods.org/pods/LRImageLoader)

* LRImageLoader is an image loading and caching library for iOS

## Installation
* Podfile
```ruby
pod 'LRImageLoader'
```
* Manually
> add LRImageLoader.framework to "General->Embedded Binaries"

## Requirements
* Minimum iOS 8.0

## Loading into UIImageView
* Objective-C
```objective-c
[[LRImageStore sharedStore] loadImage:imageUrl
                          placeholder:[UIImage imageNamed:@"placeholder"]
                                 into:imageView];
```
* Swift
```swift
LRImageStore.shared().loadImage(imageUrl,
                                placeholder: #imageLiteral(resourceName: "placeholder"),
                                into: imageView)
```
## Loading as UIImage
* Objective-C
```objective-c
[[LRImageStore sharedStore] fetchImageForURL:imageUrl progress:nil completion:^(UIImage * _Nullable image, NSString * _Nullable error) {
    if (!error) {
        // handle image
    }
}];
```
* Swift
```swift
LRImageStore.shared().fetchImage(forURL: imageUrl, progress: nil) { (image, errStr) in
    if let successImage = image {
        // handle image
    }
}
```
