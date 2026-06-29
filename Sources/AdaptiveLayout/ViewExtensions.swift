import SwiftUI

// MARK: - View Extensions

public extension View {

    // MARK: Adaptive Padding

    /// Applies padding that scales with the screen size.
    ///
    ///     Text("Hello").adaptivePadding()
    ///     // iPhone → 16pt, iPad → 24pt, Mac → 32pt
    func adaptivePadding(_ edges: Edge.Set = .all, multiplier: CGFloat = 1.0) -> some View {
        modifier(AdaptivePaddingModifier(edges: edges, multiplier: multiplier))
    }

    // MARK: Adaptive Font

    /// Picks a font size based on the current device.
    ///
    ///     Text("Title").adaptiveFont(.title, iPhoneSize: 20, iPadSize: 28, macSize: 32)
    func adaptiveFont(
        _ style: Font.TextStyle = .body,
        iPhoneSize: CGFloat = 16,
        iPadSize: CGFloat = 20,
        macSize: CGFloat = 18
    ) -> some View {
        modifier(AdaptiveFontModifier(
            style:      style,
            iPhoneSize: iPhoneSize,
            iPadSize:   iPadSize,
            macSize:    macSize
        ))
    }

    // MARK: Adaptive Frame

    /// Sets a max width that is a fraction of the screen, with a hard cap.
    ///
    ///     MyCard().adaptiveFrame(maxFraction: 0.9, cap: 700)
    ///     // Never wider than 90% of screen or 700pt, whichever is smaller.
    func adaptiveFrame(maxFraction: CGFloat = 0.95, cap: CGFloat = 800) -> some View {
        modifier(AdaptiveFrameModifier(maxFraction: maxFraction, cap: cap))
    }

    // MARK: Device Conditional

    /// Show this view only on specific device types.
    ///
    ///     SidebarView().ifDevice(.iPad, .mac)
    @ViewBuilder
    func ifDevice(_ devices: DeviceType...) -> some View {
        if devices.contains(DeviceType.current) {
            self
        }
    }

    /// Replace this view with another on specific device types.
    ///
    ///     Text("Default").ifDevice(.iPhone, replace: { Text("Phone version") })
    @ViewBuilder
    func ifDevice<Replacement: View>(
        _ device: DeviceType,
        replace replacement: () -> Replacement
    ) -> some View {
        if DeviceType.current == device {
            replacement()
        } else {
            self
        }
    }
}

// MARK: - Modifiers

struct AdaptivePaddingModifier: ViewModifier {
    let edges: Edge.Set
    let multiplier: CGFloat

    func body(content: Content) -> some View {
        GeometryReader { geo in
            let base: CGFloat = {
                switch DeviceType.current {
                case .iPhone: return 16
                case .iPad:   return 24
                case .mac:    return 32
                }
            }()
            content
                .padding(edges, base * multiplier)
                .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct AdaptiveFontModifier: ViewModifier {
    let style: Font.TextStyle
    let iPhoneSize: CGFloat
    let iPadSize: CGFloat
    let macSize: CGFloat

    func body(content: Content) -> some View {
        let size: CGFloat = {
            switch DeviceType.current {
            case .iPhone: return iPhoneSize
            case .iPad:   return iPadSize
            case .mac:    return macSize
            }
        }()
        content.font(.system(size: size))
    }
}

struct AdaptiveFrameModifier: ViewModifier {
    let maxFraction: CGFloat
    let cap: CGFloat

    func body(content: Content) -> some View {
        GeometryReader { geo in
            let maxWidth = min(geo.size.width * maxFraction, cap)
            content
                .frame(maxWidth: maxWidth)
                .frame(maxWidth: .infinity)  // centre it
        }
    }
}
