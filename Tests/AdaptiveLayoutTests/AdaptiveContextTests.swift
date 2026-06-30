import Testing
@testable import AdaptiveLayout

@Test func compactContextUsesOneColumn() {
    let context = AdaptiveContext(width: 390, height: 844)

    #expect(context.sizeClass == .compact)
    #expect(context.columns == 1)
    #expect(context.horizontalPadding == 16)
}

@Test func regularContextUsesTwoColumns() {
    let context = AdaptiveContext(width: 768, height: 1024)

    #expect(context.sizeClass == .regular)
    #expect(context.columns == 2)
    #expect(context.maxContentWidth == 760)
}

@Test func expandedContextUsesThreeColumns() {
    let context = AdaptiveContext(width: 1200, height: 900)

    #expect(context.sizeClass == .expanded)
    #expect(context.columns == 3)
    #expect(context.maxContentWidth == 1120)
}
