import SwiftUI
import WordTileKit

struct ContentView: View {
    private let theme = WordTileTheme()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("WordTileKit Demo")
                    .font(.largeTitle).bold()

                // Hello world sample (5 letters)
                GroupBox("HELLO") {
                    WordTilesRow(
                        word: "HELLO",
                        hiddenIndices: [1, 4],
                        theme: theme,
                        spacing: 6,
                        defaultTile: 44,
                        fitMode: .squeeze
                    )
                    .frame(height: 56)
                    .padding(.horizontal, 24)
                }

                // 3-letter sample
                GroupBox("3-letter: CAT") {
                    WordTilesRow(
                        word: "CAT",
                        hiddenIndices: [1],
                        theme: theme,
                        spacing: 6,
                        defaultTile: 48,
                        fitMode: .squeeze
                    )
                    .frame(height: 56)
                    .padding(.horizontal, 24)
                }

                // 6-letter sample
                GroupBox("6-letter: SWIFTY") {
                    WordTilesRow(
                        word: "SWIFTY",
                        hiddenIndices: [2, 5],
                        theme: theme,
                        spacing: 6,
                        defaultTile: 44,
                        fitMode: .scroll // try .scaleDown or .squeeze
                    )
                    .frame(height: 56)
                    .padding(.horizontal, 24)
                }

                // Single tiles
                GroupBox("Single tiles") {
                    HStack(spacing: 12) {
                        WordTile(char: "A", state: .normal, size: 44)
                        WordTile(char: "B", state: .normal, corner: .fixed(10), size: 44)
                        WordTile(char: nil, state: .hidden, size: 44)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .padding(.vertical, 24)
        }
    }
}

#Preview {
    ContentView()
        .previewLayout(.sizeThatFits)
}