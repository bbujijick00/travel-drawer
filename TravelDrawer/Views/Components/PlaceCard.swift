import SwiftUI

/// Row card used in the category list. Tapping the row opens detail; tapping
/// the heart toggles "다시 가고 싶은" without navigating (event is isolated to
/// its own button so it never triggers the row's NavigationLink).
struct PlaceCard: View {
    @Bindable var place: Place
    let showsHeart: Bool

    var body: some View {
        HStack(spacing: 14) {
            PlacePhotoView(filename: place.photos.first, cornerRadius: 16)
                .frame(width: 66, height: 66)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(place.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(DT.Colors.textStrong)
                        .lineLimit(1)
                    Spacer()
                    if showsHeart {
                        HeartButton(isOn: place.isHearted, size: 26) {
                            place.isHearted.toggle()
                        }
                    }
                }
                Text("📍 \(place.region)")
                    .font(.system(size: 11))
                    .foregroundStyle(DT.Colors.textFaint)
                HStack(spacing: 6) {
                    StatusBadge(status: place.status)
                    Text(place.checkedLabel)
                        .font(.system(size: 10))
                        .foregroundStyle(DT.Colors.textFainter)
                }
            }
        }
        .padding(12)
        .background(DT.Colors.surface, in: RoundedRectangle(cornerRadius: DT.Radius.cardLarge, style: .continuous))
        .dtShadow(DT.Shadow.card)
        .contentShape(Rectangle())
    }
}
