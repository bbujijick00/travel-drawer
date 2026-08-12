import SwiftUI

struct StatusBadge: View {
    let status: PlaceStatus

    private var colors: (bg: Color, fg: Color) {
        switch status {
        case .open: (DT.Colors.statusOpenBg, DT.Colors.statusOpenFg)
        case .changed: (DT.Colors.statusChangedBg, DT.Colors.statusChangedFg)
        case .closed: (DT.Colors.statusClosedBg, DT.Colors.statusClosedFg)
        }
    }

    var body: some View {
        Text(status.label)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(colors.fg)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(colors.bg, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

/// Small heart toggle shared by the place card and the detail title block.
struct HeartButton: View {
    let isOn: Bool
    var size: CGFloat = 26
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isOn ? "heart.fill" : "heart")
                .font(.system(size: size * 0.46, weight: .semibold))
                .foregroundStyle(isOn ? Color.white : DT.Colors.textFainter)
                .frame(width: size, height: size)
                .background(
                    RoundedRectangle(cornerRadius: size * 0.34, style: .continuous)
                        .fill(isOn ? DT.Colors.accent : DT.Colors.surface)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.34, style: .continuous)
                        .strokeBorder(isOn ? Color.clear : DT.Colors.borderAlt, lineWidth: 1.5)
                )
                .dtShadow(isOn ? DT.Shadow.heartSmall : DT.ShadowStyle(color: .clear, radius: 0, x: 0, y: 0))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 12) {
        HStack { StatusBadge(status: .open); StatusBadge(status: .changed); StatusBadge(status: .closed) }
        HStack { HeartButton(isOn: true, action: {}); HeartButton(isOn: false, action: {}) }
    }
    .padding()
}
