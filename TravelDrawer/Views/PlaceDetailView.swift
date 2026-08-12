import SwiftUI
import UIKit

struct PlaceDetailView: View {
    @Bindable var place: Place
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    private var photoCount: Int { max(place.photos.count, 1) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                hero
                galleryRow
                titleBlock
                if !place.tags.isEmpty { tagsRow }
                if place.status != .open { warningBanner }
                visitInfo
                memoBox
                if !place.links.isEmpty { linksSection }
                locationSection
            }
        }
        .background(DT.Colors.screenBackground)
        .navigationBarHidden(true)
        .safeAreaInset(edge: .bottom) { bottomBar }
    }

    // MARK: Hero

    private var hero: some View {
        ZStack(alignment: .bottom) {
            PlacePhotoView(filename: place.photos.first)
                .frame(height: 250)

            HStack {
                circleButton(systemImage: "chevron.left") { dismiss() }
                Spacer()
                circleButton(systemImage: "arrow.clockwise") {
                    place.status = .open
                    place.lastCheckedAt = Date()
                }
                .foregroundStyle(DT.Colors.accent)
                circleButton(systemImage: "ellipsis") {}
            }
            .padding(.horizontal, 16)
            .padding(.top, 44)
            .frame(maxHeight: .infinity, alignment: .top)

            HStack {
                Spacer()
                Text("1 / \(photoCount)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.black.opacity(0.45)))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)
        }
        .frame(height: 250)
    }

    private func circleButton(systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .semibold))
                .frame(width: 34, height: 34)
                .background(Circle().fill(Color.white.opacity(0.85)))
        }
        .buttonStyle(.plain)
    }

    // MARK: Gallery

    private var galleryRow: some View {
        let shown = min(photoCount, 4)
        return HStack(spacing: 8) {
            ForEach(0..<shown, id: \.self) { i in
                ZStack(alignment: .bottomTrailing) {
                    PlacePhotoView(filename: i < place.photos.count ? place.photos[i] : nil, cornerRadius: 10)
                        .frame(width: 52, height: 52)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .strokeBorder(i == 0 ? DT.Colors.accent : .clear, lineWidth: 2)
                        )
                    if i == shown - 1 && photoCount > 4 {
                        Text("+\(photoCount - 4)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 52, height: 52)
                            .background(Color.black.opacity(0.45), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(DT.Colors.surface)
    }

    // MARK: Title block

    private var titleBlock: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(place.name)
                    .font(.system(size: 21, weight: .black))
                    .foregroundStyle(DT.Colors.textStrong)
                if !place.sub.isEmpty {
                    Text(place.sub)
                        .font(.system(size: 12))
                        .foregroundStyle(DT.Colors.textFaint)
                }
            }
            Spacer()
            if place.tab == .visited {
                HeartButton(isOn: place.isHearted, size: 40) {
                    place.isHearted.toggle()
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(DT.Colors.surface)
    }

    private var tagsRow: some View {
        HStack(spacing: 6) {
            ForEach(place.tags, id: \.self) { tag in
                Text(tag)
                    .font(.system(size: 10))
                    .foregroundStyle(DT.Colors.textSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(DT.Colors.subSurfaceAlt, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DT.Colors.surface)
    }

    private var warningBanner: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                Text("⚠️")
                VStack(alignment: .leading, spacing: 2) {
                    Text("저장 후 정보가 바뀌었을 수 있어요")
                        .font(.system(size: 12.5, weight: .bold))
                        .foregroundStyle(DT.Colors.bannerWarnTitle)
                    Text("\(place.status.label) 상태로 확인됐어요. 최근 확인: \(place.checkedLabel)")
                        .font(.system(size: 11.5))
                        .foregroundStyle(DT.Colors.bannerWarnBody)
                }
            }
            HStack(spacing: 8) {
                Button {
                    place.status = .open
                    place.lastCheckedAt = Date()
                } label: {
                    Text("↻ 지금 다시 확인")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(DT.Colors.naverGreen, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .buttonStyle(.plain)

                Button {} label: {
                    Text("최신 사진 보기")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(DT.Colors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(DT.Colors.surface)
                                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(DT.Colors.borderAlt))
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .background(DT.Colors.bannerWarnBg, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .padding(.horizontal, 20)
        .padding(.top, 14)
    }

    // MARK: Info / memo / links

    private var visitInfo: some View {
        VStack(alignment: .leading, spacing: 10) {
            infoRow("주소", place.addr)
            infoRow("영업시간", place.hours)
            infoRow("가는 법", place.access)
            if let visitDate = place.visitDate {
                infoRow("방문일", visitDate.formatted(date: .abbreviated, time: .omitted))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
    }

    @ViewBuilder
    private func infoRow(_ label: String, _ value: String) -> some View {
        if !value.isEmpty {
            HStack(alignment: .top, spacing: 12) {
                Text(label)
                    .font(.system(size: 12.5))
                    .foregroundStyle(DT.Colors.textFainter)
                    .frame(width: 58, alignment: .leading)
                Text(value)
                    .font(.system(size: 12.5))
                    .foregroundStyle(DT.Colors.textBody)
            }
        }
    }

    private var memoBox: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("나의 메모")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(DT.Colors.textStrong)
            Text(place.memo.isEmpty ? "메모가 없어요" : place.memo)
                .font(.system(size: 12.5))
                .lineSpacing(4)
                .foregroundStyle(place.memo.isEmpty ? DT.Colors.textFainter : DT.Colors.textBody)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(DT.Colors.subSurface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
    }

    private var linksSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("저장한 링크")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(DT.Colors.textStrong)
            VStack(spacing: 8) {
                ForEach(place.links) { link in
                    Button {
                        if let url = URL(string: link.url) { openURL(url) }
                    } label: {
                        HStack {
                            Text(link.icon)
                            Text(link.label)
                                .font(.system(size: 12.5))
                                .foregroundStyle(DT.Colors.textBody)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundStyle(DT.Colors.textFainter)
                        }
                        .padding(12)
                        .background(DT.Colors.subSurface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
    }

    // MARK: Location

    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("위치")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(DT.Colors.textStrong)

            ZStack {
                PhotoPlaceholder(cornerRadius: 14)
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(DT.Colors.accent)
            }
            .frame(height: 120)

            HStack(spacing: 8) {
                Button {
                    openMap(scheme: "nmap://search", webFallback: "https://map.naver.com/v5/search/\(encodedRegion)")
                } label: {
                    HStack(spacing: 8) {
                        Text("N")
                            .font(.system(size: 12, weight: .black))
                            .foregroundStyle(DT.Colors.naverGreen)
                            .frame(width: 20, height: 20)
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                        Text("네이버 지도로 열기")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(DT.Colors.naverGreen, in: RoundedRectangle(cornerRadius: DT.Radius.button, style: .continuous))
                }
                .buttonStyle(.plain)

                Button {
                    openMap(scheme: nil, webFallback: "https://maps.apple.com/?q=\(encodedRegion)")
                } label: {
                    Image(systemName: "location.north.fill")
                        .foregroundStyle(DT.Colors.textSecondary)
                        .frame(width: 46, height: 46)
                        .background(DT.Colors.subSurfaceAlt2, in: RoundedRectangle(cornerRadius: DT.Radius.button, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
        .padding(.bottom, 24)
    }

    private var encodedRegion: String {
        let query = "\(place.name) \(place.region)"
        return query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
    }

    private func openMap(scheme: String?, webFallback: String) {
        if let scheme, let schemeURL = URL(string: "\(scheme)?query=\(encodedRegion)"), UIApplication.shared.canOpenURL(schemeURL) {
            openURL(schemeURL)
        } else if let url = URL(string: webFallback) {
            openURL(url)
        }
    }

    // MARK: Bottom bar

    @ViewBuilder
    private var bottomBar: some View {
        Group {
            if place.tab == .visited {
                Button {
                    place.isHearted.toggle()
                } label: {
                    Text(place.isHearted ? "♥ 다시 가고 싶은 곳에 담김" : "♥ 다시 가고 싶은 곳에 담기")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(place.isHearted ? .white : DT.Colors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            (place.isHearted ? DT.Colors.accent : DT.Colors.subSurfaceAlt2),
                            in: RoundedRectangle(cornerRadius: DT.Radius.button, style: .continuous)
                        )
                        .dtShadow(place.isHearted ? DT.Shadow.accentButton : DT.ShadowStyle(color: .clear, radius: 0, x: 0, y: 0))
                }
                .buttonStyle(.plain)
            } else {
                Button {
                    withAnimation { place.moveToVisited() }
                } label: {
                    Text("✓ 다녀왔어요로 옮기기")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(DT.Colors.movedGreen, in: RoundedRectangle(cornerRadius: DT.Radius.button, style: .continuous))
                        .dtShadow(DT.ShadowStyle(color: DT.Colors.movedGreen.opacity(0.5), radius: 10, x: 0, y: 8))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.thinMaterial)
    }
}
