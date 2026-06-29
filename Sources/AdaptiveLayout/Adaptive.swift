import SwiftUI

// MARK: - AdaptiveConfig
// Controls what .adaptive() does to your view.
// All parameters have sensible defaults so you can just call .adaptive() with nothing.

public struct AdaptiveConfig {
    // Padding
    public var padding: Edge.Set      = .all
    public var paddingMultiplier: CGFloat = 1.0

    // Font scaling (multiplier applied to whatever font the view already has)
    public var fontScale: Bool        = false
    public var iPhoneFontSize: CGFloat = 15
    public var iPadFontSize: CGFloat   = 19
    public var macFontSize: CGFloat    = 17

    // Max width capping
    public var maxWidth: Bool         = false
    public var maxFraction: CGFloat   = 0.95
    public var maxWidthCap: CGFloat   = 800

    // Corner radius scaling
    public var cornerRadius: CGFloat? = nil

    public init() {}
}

// MARK: - The magic modifier

struct AdaptiveModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) private var hSizeClass
    let config: AdaptiveConfig

    private var device: DeviceType { DeviceType.current }

    private var basePadding: CGFloat {
        switch device {
        case .iPhone: return 16
        case .iPad:   return 24
        case .mac:    return 32
        }
    }

    private var fontSize: CGFloat {
        switch device {
        case .iPhone: return config.iPhoneFontSize
        case .iPad:   return config.iPadFontSize
        case .mac:    return config.macFontSize
        }
    }

    func body(content: Content) -> some View {
        if config.maxWidth {
            content
                .padding(config.padding, basePadding * config.paddingMultiplier)
                .applyIf(config.fontScale) { $0.font(.system(size: fontSize)) }
                .applyIf(config.cornerRadius != nil) {
                    $0.clipShape(RoundedRectangle(cornerRadius: scaledRadius))
                }
                .frame(maxWidth: config.maxWidthCap)
                .frame(maxWidth: .infinity)
        } else {
            content
                .padding(config.padding, basePadding * config.paddingMultiplier)
                .applyIf(config.fontScale) { $0.font(.system(size: fontSize)) }
                .applyIf(config.cornerRadius != nil) {
                    $0.clipShape(RoundedRectangle(cornerRadius: scaledRadius))
                }
        }
    }

    private var scaledRadius: CGFloat {
        guard let r = config.cornerRadius else { return 0 }
        switch device {
        case .iPhone: return r
        case .iPad:   return r * 1.3
        case .mac:    return r * 1.1
        }
    }
}

// MARK: - View Extension

public extension View {

    // ─────────────────────────────────────────────
    // SIMPLEST: just call .adaptive() — zero config
    // Adds device-appropriate padding automatically.
    //
    //   Text("Hello").adaptive()
    // ─────────────────────────────────────────────
    func adaptive() -> some View {
        modifier(AdaptiveModifier(config: AdaptiveConfig()))
    }

    // ─────────────────────────────────────────────
    // CUSTOM: tweak what you need via trailing closure
    //
    //   MyCard().adaptive {
    //       $0.maxWidth = true
    //       $0.maxWidthCap = 600
    //       $0.padding = .horizontal
    //   }
    // ─────────────────────────────────────────────
    func adaptive(_ configure: (inout AdaptiveConfig) -> Void) -> some View {
        var config = AdaptiveConfig()
        configure(&config)
        return modifier(AdaptiveModifier(config: config))
    }

    // ─────────────────────────────────────────────
    // SHORTHAND VARIANTS — common use cases as one-liners
    // ─────────────────────────────────────────────

    /// Adaptive padding only on horizontal edges
    func adaptiveH() -> some View {
        adaptive { $0.padding = .horizontal }
    }

    /// Adaptive padding only on vertical edges
    func adaptiveV() -> some View {
        adaptive { $0.padding = .vertical }
    }

    /// Adaptive padding + caps max width (great for cards and forms)
    func adaptiveCard(cap: CGFloat = 700) -> some View {
        adaptive {
            $0.maxWidth    = true
            $0.maxWidthCap = cap
            $0.padding     = .all
        }
    }

    /// Adaptive font size only, no padding changes
    func adaptiveText(iPhone: CGFloat = 15, iPad: CGFloat = 19, mac: CGFloat = 17) -> some View {
        adaptive {
            $0.fontScale      = true
            $0.iPhoneFontSize = iPhone
            $0.iPadFontSize   = iPad
            $0.macFontSize    = mac
            $0.padding        = []   // no padding
        }
    }

    /// Adaptive corner radius (scales up on iPad/Mac)
    func adaptiveCorners(_ radius: CGFloat = 12) -> some View {
        adaptive {
            $0.cornerRadius = radius
            $0.padding      = []
        }
    }
}

// MARK: - Internal helper

extension View {
    @ViewBuilder
    fileprivate func applyIf<T: View>(_ condition: Bool, transform: (Self) -> T) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
