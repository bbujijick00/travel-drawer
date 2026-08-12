import SwiftUI

/// Decorative app dock. Only "서랍" (this app) and the center "+" FAB are wired
/// up — 탐색/지도/나 don't have designs yet.
struct BottomTabBar: View {
    var onAddTapped: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            dockItem(systemImage: "square.fill", label: "서랍", isActive: true)
            dockItem(systemImage: "circle", label: "탐색", isActive: false)

            Button(action: onAddTapped) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(DT.Colors.accent, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .dtShadow(DT.Shadow.fab)
            }
            .buttonStyle(.plain)
            .offset(y: -18)
            .frame(maxWidth: .infinity)

            dockItem(systemImage: "square.on.square", label: "지도", isActive: false)
            dockItem(systemImage: "circle.dashed", label: "나", isActive: false)
        }
        .padding(.top, 10)
        .padding(.bottom, 14)
        .background(.thinMaterial)
        .overlay(alignment: .top) {
            Rectangle().fill(DT.Colors.border).frame(height: 1)
        }
    }

    private func dockItem(systemImage: String, label: String, isActive: Bool) -> some View {
        VStack(spacing: 4) {
            Image(systemName: systemImage)
                .font(.system(size: 18))
            Text(label)
                .font(.system(size: 9))
        }
        .foregroundStyle(isActive ? DT.Colors.accent : DT.Colors.textFainter)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    BottomTabBar(onAddTapped: {})
}
