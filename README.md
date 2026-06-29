# AdaptiveLayout

A lightweight Swift package that makes it trivial to build SwiftUI layouts that look great on iPhone, iPad, and Mac — without repeating yourself.

## Installation

**Swift Package Manager** → Add Package → paste your repo URL, or drag the folder into Xcode as a local package.

Minimum targets: **iOS 16**, **macOS 13**, **Mac Catalyst 16**

---

## What's inside

| File | What it does |
|---|---|
| `DeviceType.swift` | `DeviceType` enum + `ScreenSize` ObservableObject |
| `AdaptiveView.swift` | `AdaptiveView` layout switcher + `AdaptiveStack` |
| `ViewExtensions.swift` | `.adaptivePadding()` `.adaptiveFont()` `.adaptiveFrame()` `.ifDevice()` |
| `AdaptiveScreenModifier.swift` | `.adaptiveScreen()` — apply once at the top of your app |

---

## Quick start

```swift
// 1. Apply once at the app root
ContentView()
    .adaptiveScreen()

// 2. Switch layouts based on device
AdaptiveView {
    PhoneLayout()       // compact / iPhone
} regular: {
    TabletLayout()      // iPad
} mac: {
    DesktopLayout()     // Mac
}

// 3. Auto VStack ↔ HStack
AdaptiveStack(spacing: 16) {
    ImageView()
    TextBlock()
}

// 4. Padding & font that scales
Text("Hello")
    .adaptivePadding()
    .adaptiveFont(.title, iPhoneSize: 20, iPadSize: 28, macSize: 24)

// 5. Show only on certain devices
SidebarView()
    .ifDevice(.iPad, .mac)

// 6. Read live screen size anywhere
@EnvironmentObject var screen: ScreenSize
Image(...).font(.system(size: screen.scale(0.15, min: 40, max: 120)))
```

---

## Breakpoints

| Width | Layout used |
|---|---|
| < 600 pt | Compact (iPhone, iPad Split View) |
| ≥ 600 pt | Regular (iPad full screen) |
| Mac | Always Mac layout |
