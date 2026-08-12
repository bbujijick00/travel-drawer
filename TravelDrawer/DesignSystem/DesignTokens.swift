import SwiftUI

/// Design tokens transcribed from the "여행 서랍" hi-fi design reference (README.md).
enum DT {

    enum Colors {
        static let appBackground = Color(hex: "#eceae4")
        static let screenBackground = Color(hex: "#faf7f2")

        static let surface = Color(hex: "#ffffff")
        static let subSurface = Color(hex: "#f8f2e9")
        static let subSurfaceAlt = Color(hex: "#f3ede4")
        static let subSurfaceAlt2 = Color(hex: "#f0e8dd")

        static let accent = Color(hex: "#e8735a")
        static let accentHover = Color(hex: "#d55f45")
        static let accentTint = Color(hex: "#fbeee9")
        static let accentTint2 = Color(hex: "#f3d3ca")

        static let textStrong = Color(hex: "#2b2724")
        static let textBody = Color(hex: "#4a4038")
        static let textSecondary = Color(hex: "#8a7c6b")
        static let textFaint = Color(hex: "#a89b8c")
        static let textFainter = Color(hex: "#c3b6a5")

        static let statusOpenBg = Color(hex: "#e7f6ec")
        static let statusOpenFg = Color(hex: "#1e9e57")
        static let statusChangedBg = Color(hex: "#fff4e0")
        static let statusChangedFg = Color(hex: "#c98a12")
        static let statusClosedBg = Color(hex: "#fdece9")
        static let statusClosedFg = Color(hex: "#d64b34")

        static let naverGreen = Color(hex: "#03c75a")
        static let movedGreen = Color(hex: "#2b7a4b")

        static let border = Color(hex: "#eee2d4")
        static let borderAlt = Color(hex: "#ecdfce")
        static let borderAlt2 = Color(hex: "#e7dccd")

        static let bannerWarnBg = Color(hex: "#fff4e0")
        static let bannerWarnTitle = Color(hex: "#8a6410")
        static let bannerWarnBody = Color(hex: "#a08a52")
    }

    enum Radius {
        static let chip: CGFloat = 20
        static let card: CGFloat = 18
        static let cardLarge: CGFloat = 20
        static let thumbSmall: CGFloat = 10
        static let thumbLarge: CGFloat = 16
        static let button: CGFloat = 14
        static let iconChip: CGFloat = 12
        static let deviceScreen: CGFloat = 36
    }

    enum Spacing {
        static let screenH: CGFloat = 22
        static let sectionH: CGFloat = 20
        static let cardGap: CGFloat = 12
        static let gridGap: CGFloat = 11
        static let chipGap: CGFloat = 7
    }

    enum Shadow {
        static let card = ShadowStyle(color: Color(hex: "#2b2724").opacity(0.35), radius: 13, x: 0, y: 6)
        static let accentButton = ShadowStyle(color: Color(hex: "#e8735a").opacity(0.6), radius: 11, x: 0, y: 8)
        static let fab = ShadowStyle(color: Color(hex: "#e8735a").opacity(0.7), radius: 12, x: 0, y: 8)
        static let heartSmall = ShadowStyle(color: Color(hex: "#e8735a").opacity(0.6), radius: 5, x: 0, y: 3)
    }

    struct ShadowStyle {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
}

extension View {
    func dtShadow(_ style: DT.ShadowStyle) -> some View {
        shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
}

extension Color {
    init(hex: String) {
        var s = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var rgb: UInt64 = 0
        Scanner(string: s).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
        _ = s
    }
}
