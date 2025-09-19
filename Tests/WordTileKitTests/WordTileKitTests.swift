import XCTest
import SwiftUI
@testable import WordTileKit

final class WordTileKitTests: XCTestCase {
    func testCanConstructViews() {
        _ = WordTile(char: "A", state: .normal)
        _ = WordTile(char: nil, state: .hidden)

        _ = WordTilesRow(
            word: "HELLO",
            hiddenIndices: [1, 3],
            spacing: 2,
            defaultTile: 44,
            minTile: 26,
            maxTile: 52,
            fitMode: .squeeze
        )
    }

    func testThemeDefaults() {
        let theme = WordTileTheme()
        XCTAssertNotNil(theme.fill)
        XCTAssertNotNil(theme.hiddenFill)
        XCTAssertNotNil(theme.stroke)
        XCTAssertNotNil(theme.text)
    }
}