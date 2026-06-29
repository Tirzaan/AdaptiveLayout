import SwiftUI

// MARK: - Device Type

/// Represents the current device family your app is running on.
public enum DeviceType: String, Equatable {
    case iPhone
    case iPad
    case mac

    /// The current device type at runtime.
    public static var current: DeviceType {
        #if os(macOS)
        return .mac
        #elseif targetEnvironment(macCatalyst)
        return .mac
        #else
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:  return .iPad
        default:    return .iPhone
        }
        #endif
    }
}

// MARK: - Screen Size Environment Object

/// Inject this into your app to give any view access to live screen dimensions.
///
/// Usage in App entry point:
///     @StateObject private var screen = ScreenSize()
///     ContentView().environmentObject(screen)
///
/// Usage in any View:
///     @EnvironmentObject var screen: ScreenSize
///     Text("Width: \(screen.width)")
public final class ScreenSize: ObservableObject {
    @Published public var width: CGFloat = 0
    @Published public var height: CGFloat = 0
    @Published public var device: DeviceType = DeviceType.current

    public init() {}

    /// Returns true when the app is in a narrow/compact container (e.g. iPhone portrait, iPad Split View).
    public var isCompact: Bool { width < 600 }

    /// Returns a value scaled relative to screen width.
    /// scale(0.5) → half the screen width, clamped between min and max.
    public func scale(_ ratio: CGFloat, min: CGFloat = 8, max: CGFloat = .infinity) -> CGFloat {
        Swift.max(min, Swift.min(max, width * ratio))
    }
}
