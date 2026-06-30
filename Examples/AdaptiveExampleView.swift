import SwiftUI
import AdaptiveLayout

struct AdaptiveExampleView: View {
    @Environment(\.adaptiveContext) private var adaptive

    private let items = [
        "Dashboard",
        "Messages",
        "Projects",
        "Calendar",
        "Settings",
        "Profile"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: adaptive.spacing) {
                Text("Adaptive Example")
                    .adaptiveFont(34, weight: .bold)

                Text("This layout changes columns, spacing, and padding based on the available screen width.")
                    .adaptiveFont(17)
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: columns, spacing: adaptive.spacing) {
                    ForEach(items, id: \.self) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Image(systemName: iconName(for: item))
                                .font(.title2)
                                .foregroundStyle(.blue)

                            Text(item)
                                .adaptiveFont(17, weight: .semibold)

                            Text("Size class: \(label(for: adaptive.sizeClass))")
                                .adaptiveFont(12)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.background)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(color: .black.opacity(0.08), radius: 8, y: 3)
                    }
                }
            }
            .adaptivePadding()
            .adaptiveReadableWidth()
        }
        .background(Color(.systemGroupedBackground))
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: adaptive.spacing),
            count: adaptive.columns
        )
    }

    private func label(for sizeClass: AdaptiveSizeClass) -> String {
        switch sizeClass {
        case .compact:
            "compact"
        case .regular:
            "regular"
        case .expanded:
            "expanded"
        }
    }

    private func iconName(for item: String) -> String {
        switch item {
        case "Dashboard":
            "square.grid.2x2"
        case "Messages":
            "message"
        case "Projects":
            "folder"
        case "Calendar":
            "calendar"
        case "Settings":
            "gearshape"
        default:
            "person.crop.circle"
        }
    }
}

#Preview("Adaptive Example") {
    AdaptiveExampleView().adaptive
}
