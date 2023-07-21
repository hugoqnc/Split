<h1> Split!
  <img align="right" src="Resources/icon-radius.png" width=74px>
</h1>
<br/>

<p align="center">
  <img align="center" src="https://user-images.githubusercontent.com/67365803/170351859-860bc194-149e-41eb-8fa2-5ed8af58e5af.png#gh-light-mode-only" width=250px>
  <img align="center" src="https://user-images.githubusercontent.com/67365803/170351861-d1d8803d-094c-4909-bf58-3d90d5aa52c6.png#gh-dark-mode-only" width=250px>
</p>

Split! is a free[^1] app for iOS and iPadOS, that allows a group of people to easily share expenses from a common receipt.
For example, roommates can do their shopping and pay for everything together.
Afterwards, one of them can scan the receipt, and attribute each expense to one person, several people or the whole group.
The app will calculate everyone's total, much faster than if you had to do it by hand.
<br/>

> [!WARNING]\
> Split! is no longer available on the App Store as of 15/07/2023. If you want to try it out, you can install it from a Mac using Xcode.

<br/>

![](Resources/presentation.jpeg)


## Quick demo
https://user-images.githubusercontent.com/67365803/187445035-cd8ae00c-e1be-445f-83ce-e9cc731e0ba1.mp4

## Features
### General
- [x] Scan any receipt, regardless of the brand, language or currency
- [x] Take your scan in a single tap, with no need to manually crop it
- [x] Reliable image recognition results, that are automatically verified by matching the price of all items to the total price
- [x] No account, no internet connection is required to run the application (everything happens locally and no data is shared)[^2]
- [x] Keeps a history of all receipts and of their distribution
- [x] Quickly display images corresponding to the item name on the receipt, to easily understand what it refers to

### Appearance
- [x] Minimalist and native design for iOS
- [x] Dark Mode fully supported
- [x] iPad optimized version that takes advantage of the large screen

### Sharing
- [x] Export the results to a [Tricount](https://www.tricount.com/) of your choice in just a tap[^3]
- [x] Share the results as text using any app you want (individual or complete results)
- [x] Export the scanned receipt

### And much more...
- [x] Import receipt images from your photo library or files
- [x] Save your most frequently used list of people
- [x] Display and use the currency symbol of your choice (€, $, £, ¥)
- [x] Easily add a tip and taxes, and distribute them fairly
- [x] Scan several receipts from the beginning to group all transactions 
- [x] Add, delete or modify items on the fly during the attribution process
- [x] Handles reductions (with negative amounts)
- [x] Modify advanced image recognition parameters in settings


## Technical Details
- This app works on Apple devices running iOS 15 / iPadOS 15 or higher
- Developped using [SwiftUI](https://developer.apple.com/xcode/swiftui/), which results in native and fluid components and animations
- The image recognition part is achieved through Apple's [Vision](https://developer.apple.com/documentation/vision) Framework
- This project uses two [Swift Packages](https://developer.apple.com/documentation/swift_packages) dependencies: [SlideOverCard](https://github.com/joogps/SlideOverCard), that provides beautiful tutorial cards, and [ConfettiSwiftUI](https://github.com/simibac/ConfettiSwiftUI), that provides confetti animations.
- Split! does not collect your data. You can find the privacy policy [here](PRIVACY.md).

## Highlights
Split! was selected as a **winner of Apple's Swift Student Challenge** at WWDC 2022. My project was further selected among the 12 best projects of this year, and presented in front of Tim Cook!

![](Resources/tim-cook.jpg)

[^1]: Split! is **free**, **ad-free**, does **not collect your data**. It is developed independently by a student in his spare time. If you want to support the project, you can download the app and leave a tip!

[^2]: Except when using Tricount's services, which require an internet connection and acceptance of [Tricount's privacy policy](https://www.tricount.com/en/privacy-policy).

[^3]: Split! is not affiliated in any way with Tricount. It does not use the official [Tricount API](https://www.tricount.com/en/api), but a [workaround](https://github.com/hugoqnc/Split/blob/main/Split/Model/Tricount.swift).
