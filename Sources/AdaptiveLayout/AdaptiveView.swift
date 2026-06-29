import SwiftUI

// MARK: - AdaptiveView

/// A container that automatically picks the right layout based on screen width and device.
///
/// Basic usage (compact vs regular):
///     AdaptiveView {
///         Text("Phone layout")
///     } regular: {
///         Text("iPad / Mac layout")
///     }
///
/// Full per-device control:
///     AdaptiveView {
///         PhoneView()
///     } iPad: {
///         TabletView()
///     } mac: {
///         DesktopView()
///     }
public struct AdaptiveView<Compact: View, Regular: View, Mac: View>: View {

    @Environment(\.horizontalSizeClass) private var hSizeClass
    private let device = DeviceType.current

    private let compact: () -> Compact
    private let regular: () -> Regular
    private let mac:     () -> Mac

    /// Initialise with all three layouts.
    public init(
        @ViewBuilder compact: @escaping () -> Compact,
        @ViewBuilder regular: @escaping () -> Regular,
        @ViewBuilder mac:     @escaping () -> Mac
    ) {
        self.compact = compact
        self.regular = regular
        self.mac     = mac
    }

    public var body: some View {
        if device == .mac {
            mac()
        } else {
            // Use horizontalSizeClass instead of GeometryReader for the switcher
            if hSizeClass == .compact {
                compact()
            } else {
                regular()
            }
        }
    }
}

// MARK: - Compact + Regular only (most common case)

extension AdaptiveView where Mac == AnyView {
    /// Simpler init: just provide a compact and a regular layout.
    /// Mac will use the regular layout automatically.
    public init(
        @ViewBuilder compact: @escaping () -> Compact,
        @ViewBuilder regular: @escaping () -> Regular
    ) {
        self.compact = compact
        self.regular = regular
        self.mac     = { AnyView(regular()) }
    }
}

// MARK: - AdaptiveStack

/// Switches between VStack (compact) and HStack (regular) automatically.
///
///     AdaptiveStack(spacing: 16) {
///         ImageView()
///         InfoView()
///     }
public struct AdaptiveStack<Content: View>: View {
    @Environment(\.horizontalSizeClass) private var hSizeClass

    private let spacing: CGFloat
    private let content: () -> Content

    public init(spacing: CGFloat = 16, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        GeometryReader { geo in
            Group {
                if geo.size.width >= 600 {
                    HStack(spacing: spacing, content: content)
                } else {
                    VStack(spacing: spacing, content: content)
                }
            }
        }
    }
}
