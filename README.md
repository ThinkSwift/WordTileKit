# WordTileKit

Lightweight SwiftUI components for rendering letter tiles and responsive word rows. Perfect for word games, quizzes, and letter-based interfaces.

- Tiny API: `WordTile` and `WordTilesRow`
- Auto-sizing row that fits available width
- Configurable theme, spacing, corner radius strategy
- Accessibility-friendly labels

## Requirements

- Swift 5.10+
- Xcode 15.4+ (or newer with Swift 5.10 toolchain)
- Platforms:
  - iOS 17+
  - macOS 14+

## Installation

Use Swift Package Manager.

- In Xcode: File → Add Packages…
- Enter the URL:
  ```
  https://github.com/ThinkSwift/WordTileKit
  ```
- Add the `WordTileKit` library to your target.

## Quick Start

```swift
import SwiftUI
import WordTileKit

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Single tile
            WordTile(char: "A", state: .normal)

            // Hidden tile
            WordTile(char: nil, state: .hidden)

            // A row that fits its container width
            WordTilesRow(
                word: "SWIFT",
                hiddenIndices: [1, 3]   // Hides W and T
            )
            .padding(.horizontal, 24)
        }
    }
}
```

## Customization

### Theme

```swift
let theme = WordTileTheme(
    fill: Color.yellow,
    hiddenFill: Color.yellow.opacity(0.35),
    stroke: Color.black.opacity(0.1),
    text: .primary
)

WordTile(char: "S", state: .normal, theme: theme)
```

### Corner Radius Strategy

- `.auto(ratio:min:max)` scales corners from the tile size (default), clamped to a range.
- `.fixed(CGFloat)` uses an explicit corner radius.

```swift
WordTile(
    char: "A",
    state: .normal,
    corner: .auto(ratio: 0.12, min: 4, max: 10)
)

WordTile(
    char: "B",
    state: .normal,
    corner: .fixed(8)
)
```

### Row Sizing and Fit Mode

Control spacing and tile sizing bounds, plus the fit strategy when content is tight:

- `.squeeze` (default): squeezes tiles between `minTile...maxTile`. If still too tight, tiles clamp at `minTile`.
- `.scroll`: when content won't fit, the row becomes horizontally scrollable.
- `.scaleDown`: when content won't fit, scale the entire row down to fit.

```swift
WordTilesRow(
    word: "WORDTILEKIT",
    hiddenIndices: [],
    spacing: 4,
    defaultTile: 44,
    minTile: 26,
    maxTile: 52,
    fitMode: .scroll
)
```

### Placeholder and Typography

```swift
WordTile(
    char: nil,
    state: .hidden,
    placeholder: "•",
    fontWeight: .heavy,
    size: 44
)
```

## Accessibility

- Hidden tiles use the accessibility label "Hidden letter".
- Visible tiles use the character as the accessibility label.

You can wrap tiles with your own accessible containers as needed.

## Examples

A minimal demo view is included at `Examples/DemoApp/ContentView.swift`. Open this file in Xcode and use the SwiftUI Preview to try the components without creating a full app target.

## Roadmap

- DocC documentation
- Sample demo app project
- Optional animations

## License

MIT — see [LICENSE](LICENSE).
