import SwiftUI

// MARK: - AdaptiveScreen Modifier

/// Apply this to any View to inject a live ScreenSize and make it fill the screen properly.
///
/// Usage:
///     ContentView()
///         .adaptiveScreen()
///
/// Then inside ContentView:
///     @EnvironmentObject var screen: ScreenSize
public struct AdaptiveScreenModifier: ViewModifier {
    @StateObject private var screenSize = ScreenSize()

    public func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .environmentObject(screenSize)
                .onAppear {
                    screenSize.width  = geo.size.width
                    screenSize.height = geo.size.height
                }
                .onChange(of: geo.size) { newSize in
                    screenSize.width  = newSize.width
                    screenSize.height = newSize.height
                }
        }
        .ignoresSafeArea(.container, edges: .all)
    }
}

public extension View {
    /// Wraps a view with live screen size tracking and device detection.
    /// Apply once at the top level (e.g. on ContentView or WindowGroup content).
    func adaptiveScreen() -> some View {
        modifier(AdaptiveScreenModifier())
    }
}
