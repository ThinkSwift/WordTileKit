import SwiftUI

// MARK: - Theme

public struct WordTileTheme {
    public var fill: Color
    public var hiddenFill: Color
    public var stroke: Color
    public var text: Color

    public init(
        fill: Color = Color(red: 1.0, green: 0.92, blue: 0.45),
        hiddenFill: Color = Color.yellow.opacity(0.35),
        stroke: Color = Color.black.opacity(0.08),
        text: Color = .primary
    ) {
        self.fill = fill
        self.hiddenFill = hiddenFill
        self.stroke = stroke
        self.text = text
    }
}

// MARK: - Corner Strategy

public enum CornerStrategy: Equatable {
    case auto(ratio: CGFloat = 0.12, min: CGFloat = 4, max: CGFloat = 10)
    case fixed(CGFloat)
}

// MARK: - Single Tile

public struct WordTile: View {
    public enum State { case normal, hidden }

    public let char: Character?
    public let state: State
    public var theme: WordTileTheme = .init()
    public var corner: CornerStrategy = .auto()   // avoids "too round" look on small tiles
    public var size: CGFloat = 44
    public var fontWeight: Font.Weight = .heavy
    public var placeholder: String = "•"

    public init(
        char: Character?,
        state: State,
        theme: WordTileTheme = .init(),
        corner: CornerStrategy = .auto(),
        size: CGFloat = 44,
        fontWeight: Font.Weight = .heavy,
        placeholder: String = "•"
    ) {
        self.char = char
        self.state = state
        self.theme = theme
        self.corner = corner
        self.size = size
        self.fontWeight = fontWeight
        self.placeholder = placeholder
    }

    private var resolvedCorner: CGFloat {
        switch corner {
        case .fixed(let v): return v
        case .auto(let ratio, let minV, let maxV):
            return max(minV, min(maxV, size * ratio))
        }
    }

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: resolvedCorner, style: .continuous)
                .fill(state == .hidden ? theme.hiddenFill : theme.fill)
                .overlay(
                    RoundedRectangle(cornerRadius: resolvedCorner, style: .continuous)
                        .stroke(theme.stroke, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 8, y: 3)

            if state == .hidden {
                Text(placeholder)
                    .font(.system(size: size * 0.42, weight: .black, design: .rounded))
                    .kerning(0)
                    .foregroundColor(theme.text.opacity(0.28))
            } else {
                Text(char.map(String.init) ?? "")
                    .font(.system(size: size * 0.5, weight: fontWeight, design: .rounded))
                    .minimumScaleFactor(0.6)
                    .kerning(0)
                    .foregroundColor(theme.text)
            }
        }
        .frame(width: size, height: size)
        .accessibilityLabel(state == .hidden ? "Hidden letter" : (char.map(String.init) ?? ""))
    }
}

// MARK: - Row (always horizontal)

public struct WordTilesRow: View {
    public enum FitMode { case squeeze, scroll, scaleDown }

    public let word: String
    public let hiddenIndices: Set<Int>

    public var theme: WordTileTheme = .init()
    public var spacing: CGFloat = 0               // caller controls; default 0 per request
    public var corner: CornerStrategy = .auto()
    public var defaultTile: CGFloat = 44          // preferred size when it fits
    public var minTile: CGFloat = 26
    public var maxTile: CGFloat = 52
    public var placeholder: String = "•"
    public var fitMode: FitMode = .squeeze

    private var chars: [Character] { Array(word.uppercased()) }

    public init(
        word: String,
        hiddenIndices: Set<Int>,
        theme: WordTileTheme = .init(),
        spacing: CGFloat = 0,
        corner: CornerStrategy = .auto(),
        defaultTile: CGFloat = 44,
        minTile: CGFloat = 26,
        maxTile: CGFloat = 52,
        placeholder: String = "•",
        fitMode: FitMode = .squeeze
    ) {
        self.word = word
        self.hiddenIndices = hiddenIndices
        self.theme = theme
        self.spacing = spacing
        self.corner = corner
        self.defaultTile = defaultTile
        self.minTile = minTile
        self.maxTile = maxTile
        self.placeholder = placeholder
        self.fitMode = fitMode
    }

    public var body: some View {
        GeometryReader { geo in
            let n = max(chars.count, 1)
            let totalSpacing = spacing * CGFloat(max(n - 1, 0))
            let avail = geo.size.width - totalSpacing

            let fitsDefault = avail >= defaultTile * CGFloat(n)
            let ideal = (avail / CGFloat(n))
            let base = fitsDefault ? defaultTile : ideal
            let clamped = max(min(base, maxTile), minTile)
            let needsMore = !fitsDefault && (ideal < minTile)
            let rowWidth = clamped * CGFloat(n) + totalSpacing

            content(tileSize: clamped, needsMore: needsMore, rowWidth: rowWidth, container: geo.size.width)
                .frame(width: geo.size.width, alignment: .center)
        }
        .frame(height: max(minTile, min(maxTile, defaultTile)))
    }

    @ViewBuilder
    private func content(tileSize: CGFloat, needsMore: Bool, rowWidth: CGFloat, container: CGFloat) -> some View {
        let row = HStack(spacing: spacing) {
            ForEach(chars.indices, id: \.self) { i in
                WordTile(
                    char: chars[i],
                    state: hiddenIndices.contains(i) ? .hidden : .normal,
                    theme: theme,
                    corner: corner,
                    size: tileSize,
                    placeholder: placeholder
                )
            }
        }

        switch (fitMode, needsMore) {
        case (.scroll, true):
            ScrollView(.horizontal, showsIndicators: false) { row.padding(.horizontal, 2) }
        case (.scaleDown, true):
            let scale = max(container / rowWidth, 0.5)
            row.scaleEffect(scale, anchor: .center)
        default:
            row
        }
    }
}