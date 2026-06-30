# AdaptiveLayout

`AdaptiveLayout` is a tiny SwiftUI package that gives any view a simple adaptive wrapper:

```swift
import SwiftUI
import AdaptiveLayout

struct AppRoot: View {
    var body: some View {
        ContentView().adaptive
    }
}
```

The `.adaptive` property measures the available screen size, centers wide layouts, caps readable width on larger screens, and exposes an `adaptiveContext` environment value for screens that need layout decisions.

## Optional helpers

```swift
struct ContentView: View {
    @Environment(\.adaptiveContext) private var adaptive

    var body: some View {
        LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible(), spacing: adaptive.spacing),
                count: adaptive.columns
            ),
            spacing: adaptive.spacing
        ) {
            // Your content
        }
        .adaptivePadding()
    }
}
```

## Example view

There is a complete sample at `Examples/AdaptiveExampleView.swift`.

Use it from your app like this:

```swift
import SwiftUI
import AdaptiveLayout

struct RootView: View {
    var body: some View {
        AdaptiveExampleView().adaptive
    }
}
```

## Install in Xcode

1. Open your app in Xcode.
2. Choose **File > Add Package Dependencies**.
3. Select this local folder: `AdaptiveLayout`.
4. Add `import AdaptiveLayout`.
5. Wrap your root view with `ContentView().adaptive`.
