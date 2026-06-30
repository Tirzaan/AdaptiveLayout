import SwiftUI

public enum AdaptiveSizeClass: Equatable, Sendable {
    case compact
    case regular
    case expanded
}

public struct AdaptiveContext: Equatable, Sendable {
    public let width: CGFloat
    public let height: CGFloat
    public let sizeClass: AdaptiveSizeClass
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    public let spacing: CGFloat
    public let columns: Int
    public let maxContentWidth: CGFloat

    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height

        switch width {
        case ..<600:
            sizeClass = .compact
            horizontalPadding = 16
            verticalPadding = 16
            spacing = 12
            columns = 1
            maxContentWidth = .infinity
        case ..<900:
            sizeClass = .regular
            horizontalPadding = 24
            verticalPadding = 20
            spacing = 16
            columns = 2
            maxContentWidth = 760
        default:
            sizeClass = .expanded
            horizontalPadding = 32
            verticalPadding = 24
            spacing = 20
            columns = 3
            maxContentWidth = 1120
        }
    }
}

private struct AdaptiveContextKey: EnvironmentKey {
    static let defaultValue = AdaptiveContext(width: 390, height: 844)
}

public extension EnvironmentValues {
    var adaptiveContext: AdaptiveContext {
        get { self[AdaptiveContextKey.self] }
        set { self[AdaptiveContextKey.self] = newValue }
    }
}

public extension View {
    /// Wraps the view in a responsive container and exposes `adaptiveContext`
    /// through the SwiftUI environment.
    var adaptive: some View {
        AdaptiveRoot {
            self
        }
    }

    /// Applies padding that follows the current adaptive size class.
    func adaptivePadding() -> some View {
        modifier(AdaptivePaddingModifier())
    }

    /// Centers content and caps width on larger screens.
    func adaptiveReadableWidth() -> some View {
        modifier(AdaptiveReadableWidthModifier())
    }
}

private struct AdaptiveRoot<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        GeometryReader { proxy in
            let context = AdaptiveContext(
                width: proxy.size.width,
                height: proxy.size.height
            )

            content
                .environment(\.adaptiveContext, context)
                .frame(maxWidth: context.maxContentWidth == .infinity ? .infinity : context.maxContentWidth)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private struct AdaptivePaddingModifier: ViewModifier {
    @Environment(\.adaptiveContext) private var context

    func body(content: Content) -> some View {
        content.padding(.horizontal, context.horizontalPadding)
            .padding(.vertical, context.verticalPadding)
    }
}

private struct AdaptiveReadableWidthModifier: ViewModifier {
    @Environment(\.adaptiveContext) private var context

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: context.maxContentWidth == .infinity ? .infinity : context.maxContentWidth)
            .frame(maxWidth: .infinity)
    }
}
