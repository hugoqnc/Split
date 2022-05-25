<h1> Split!
  <img align="right" src="Resources/icon-radius.png" width=74px>
</h1>
<br/>

<p align="center">
  <img align="center" src="https://user-images.githubusercontent.com/67365803/170351859-860bc194-149e-41eb-8fa2-5ed8af58e5af.png#gh-light-mode-only" width=250px>
  <img align="center" src="https://user-images.githubusercontent.com/67365803/170351861-d1d8803d-094c-4909-bf58-3d90d5aa52c6.png#gh-dark-mode-only" width=250px>
</p>

Split! is an app for iOS and iPadOS, that allows a group of people to easily share expenses from a common receipt.
For example, roommates can do their shopping and pay for everything together.
Afterwards, one of them can scan the receipt, and attribute each expense to one person, several people or the whole group.
The app will calculate everyone's total, much faster than if you had to do it by hand.
<br/>
<br/>

![](Resources/presentation.png)

Image: some screenshots of Split!, on iPhone and iPad, in light and dark mode. 

## Quick demo

https://user-images.githubusercontent.com/67365803/159295049-a5201b9e-ec59-4356-a12f-6d40171c7870.mp4

## Features
- [x] Scan any receipt, regardless of the brand, language or currency
- [x] Take your scan in a single tap, with no need to manually crop it
- [x] Reliable image recognition results, that are automatically verified by matching the price of all items to the total price
- [x] Full Privacy: No account, no internet connection is required to run the application (everything happens locally and no data is shared)
- [x] Use it from two to an unlimited number of people
- [x] Quickly display images corresponding to the item name on the receipt, to easily understand what it refers to
- [x] Share the results using any app you want
- [x] Export the results to a [Tricount](https://www.tricount.com/) of your choice in just a tap[^1]
- [x] Keeps a history of all receipts and of their distribution
- [x] Minimalist and native design for iOS
- [X] Dark Mode fully supported
- [x] Add, delete or modify items on the fly
- [x] Easily correct small errors of image recognition
- [x] Handles reductions (with negative amounts)
- [x] Export the scanned receipt 
- [x] Export the detailed computation of the results (for everyone or for a single person)
- [x] Display and use the currency symbol of your choice (€, $, £, ¥)
- [x] Save your most frequently used list of people
- [x] iPad optimized version that takes advantage of the large screen
- [x] Scan several receipts from the beginning to group all transactions 
- [x] Sort expenses by price to better manage your budget
- [x] Modify advanced image recognition parameters in settings

## Upcoming features
- [ ] Welcome screen and "getting started" tutorial
- [ ] Hopefully, publication of Split! on the App Store

## Technical Details
- This app works on Apple devices running iOS 15 / iPadOS 15 or higher
- Developped using [SwiftUI](https://developer.apple.com/xcode/swiftui/), which results in native and fluid components and animations
- The image recognition part is achieved through Apple's [Vision](https://developer.apple.com/documentation/vision) Framework
- This project uses two (open source) [Swift Packages](https://developer.apple.com/documentation/swift_packages) dependencies:
  - [SlideOverCard](https://github.com/joogps/SlideOverCard), that provides beautiful tutorial cards
  - [WebView](https://github.com/kylehickinson/SwiftUI-WebView), that is used to facilitate the use of [WKWebView](https://developer.apple.com/documentation/webkit/wkwebview) in order to send requests to Tricount <sup id="a1">[1](#f1)</sup>
- This app is not (yet?) on the App Store, but if you have a Mac with Xcode installed, you can install it on your iPhone or iPad using your own signing certificate

[^1]: Split! is not affiliated in any way with Tricount. It does not use the official [Tricount API](https://www.tricount.com/en/api), but a [workaround](https://github.com/hugoqnc/Split/blob/main/Split/View/Tricount/TricountWebView.swift#L183).
