import SwiftUI

/// 가보고 싶어 / 다녀왔어요 segmented toggle used on the home and add screens.
struct TabToggle: View {
    @Binding var selection: PlaceTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(PlaceTab.allCases, id: \.self) { t in
                Button {
                    withAnimation(.easeOut(duration: 0.18)) { selection = t }
                } label: {
                    Text(t.label)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(selection == t ? Color.white : DT.Colors.textFaint)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background {
                            if selection == t {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(DT.Colors.accent)
                                    .dtShadow(DT.Shadow.accentButton)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(DT.Colors.subSurfaceAlt2)
        )
    }
}

#Preview {
    TabToggle(selection: .constant(.wish)).padding()
}
