// ============================================================
//  EXAMPLE USAGE — AdaptiveLayout Package
//  Copy these snippets into your own project.
// ============================================================

import SwiftUI
import AdaptiveLayout

// MARK: - 1. App Entry Point
// Apply .adaptiveScreen() once at the top so every view gets
// access to the ScreenSize environment object.

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .adaptiveScreen()   // ← add this once here
        }
    }
}

// MARK: - 2. ContentView using AdaptiveView

struct ContentView: View {
    @EnvironmentObject var screen: ScreenSize   // available everywhere after .adaptiveScreen()

    var body: some View {
        AdaptiveView {
            // iPhone / compact layout
            VStack(spacing: 20) {
                HeaderView()
                CardList()
            }
            .adaptivePadding()

        } regular: {
            // iPad layout
            HStack(spacing: 32) {
                SidebarView()
                    .frame(width: 260)
                CardList()
            }
            .adaptivePadding()

        } mac: {
            // Mac layout
            NavigationSplitView {
                SidebarView()
            } detail: {
                CardList()
            }
        }
    }
}

// MARK: - 3. AdaptiveStack — auto VStack/HStack

struct ProfileRow: View {
    var body: some View {
        // Stacks vertically on iPhone, horizontally on iPad/Mac
        AdaptiveStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 60))
            VStack(alignment: .leading) {
                Text("Jane Appleseed")
                    .adaptiveFont(.headline, iPhoneSize: 18, iPadSize: 24, macSize: 20)
                Text("iOS Developer")
                    .foregroundStyle(.secondary)
            }
        }
        .adaptivePadding()
    }
}

// MARK: - 4. adaptiveFrame — max-width card

struct Card: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.blue.opacity(0.15))
            .frame(height: 120)
            .adaptiveFrame(maxFraction: 0.9, cap: 600)  // never wider than 90% or 600pt
            .adaptivePadding(.horizontal)
    }
}

// MARK: - 5. ifDevice — show/hide per platform

struct ToolbarRow: View {
    var body: some View {
        HStack {
            Text("My App")
                .adaptiveFont(.title, iPhoneSize: 22, iPadSize: 30, macSize: 26)

            // Only show on iPad and Mac
            Spacer()
                .ifDevice(.iPad, .mac)

            Button("New") {}
                .ifDevice(.iPad, .mac)
        }
    }
}

// MARK: - 6. ScreenSize directly for custom math

struct HeroImage: View {
    @EnvironmentObject var screen: ScreenSize

    var body: some View {
        Image(systemName: "star.fill")
            .font(.system(size: screen.scale(0.15, min: 40, max: 120)))
            // → 15% of screen width, minimum 40pt, max 120pt
    }
}

// MARK: - Placeholder views used above
struct HeaderView: View  { var body: some View { Text("Header") } }
struct CardList: View    { var body: some View { Text("Cards") } }
struct SidebarView: View { var body: some View { Text("Sidebar") } }
