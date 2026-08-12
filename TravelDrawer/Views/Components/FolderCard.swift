import SwiftUI

/// One tile in the home screen's category grid. The "다시 가고 싶은" folder gets
/// the highlighted (accent-tinted) treatment; every other folder is neutral.
struct FolderCard: View {
    let emoji: String
    let title: String
    let count: Int
    let isHighlighted: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    ZStack {
                        RoundedRectangle(cornerRadius: DT.Radius.iconChip, style: .continuous)
                            .fill(isHighlighted ? DT.Colors.accentTint : DT.Colors.subSurfaceAlt)
                            .frame(width: 38, height: 38)
                        Text(emoji).font(.system(size: 18))
                    }
                    Spacer()
                    Text("\(count)")
                        .font(.system(size: 19, weight: .black))
                        .foregroundStyle(isHighlighted ? DT.Colors.accent : DT.Colors.textStrong)
                }
                Text(title)
                    .font(.system(size: 13.5, weight: .bold))
                    .foregroundStyle(DT.Colors.textStrong)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(DT.Colors.surface, in: RoundedRectangle(cornerRadius: DT.Radius.card, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DT.Radius.card, style: .continuous)
                    .strokeBorder(isHighlighted ? DT.Colors.accentTint : .clear, lineWidth: 1.5)
            )
            .dtShadow(DT.Shadow.card)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 11) {
        FolderCard(emoji: "♥", title: "다시 가고 싶은", count: 4, isHighlighted: true, action: {})
        FolderCard(emoji: "🍜", title: "맛집", count: 12, isHighlighted: false, action: {})
    }
    .padding()
    .background(DT.Colors.appBackground)
}
