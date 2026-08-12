import SwiftUI
import SwiftData

struct FoldersView: View {
    @Binding var tab: PlaceTab
    @Binding var path: [Route]

    @Query private var allPlaces: [Place]

    private var inTab: [Place] {
        allPlaces.filter { $0.tab == tab }
    }

    private func count(_ filter: ListFilter) -> Int {
        switch filter {
        case .all: inTab.count
        case .again: inTab.filter(\.isHearted).count
        case .category(let c): inTab.filter { $0.category == c }.count
        case .region: inTab.count
        }
    }

    private var folders: [ListFilter] {
        var f: [ListFilter] = []
        if tab == .visited { f.append(.again) }
        f.append(contentsOf: PlaceCategory.allCases.map(ListFilter.category))
        f.append(.region)
        return f
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                TabToggle(selection: Binding(
                    get: { tab },
                    set: { newValue in
                        tab = newValue
                        path = []
                    }
                ))
                allBanner
                grid
            }
            .padding(.horizontal, DT.Spacing.screenH)
            .padding(.top, 8)
            .padding(.bottom, 12)
        }
        .background(DT.Colors.screenBackground)
        .navigationBarHidden(true)
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(tab.label) · \(inTab.count)")
                    .font(.system(size: 12))
                    .foregroundStyle(DT.Colors.textFaint)
                Text("나의 여행 서랍")
                    .font(.system(size: 25, weight: .black))
                    .tracking(-0.5)
                    .foregroundStyle(DT.Colors.textStrong)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(DT.Colors.subSurfaceAlt)
                .frame(width: 40, height: 40)
                .overlay(Image(systemName: "person.fill").foregroundStyle(DT.Colors.textFaint))
        }
    }

    private var allBanner: some View {
        Button {
            path.append(.list(.all))
        } label: {
            ZStack(alignment: .leading) {
                PhotoPlaceholder(cornerRadius: 20)
                LinearGradient(
                    colors: [DT.Colors.textStrong.opacity(0.5), DT.Colors.textStrong.opacity(0.05)],
                    startPoint: .leading, endPoint: .trailing
                )
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("전체 보기")
                            .font(.system(size: 17, weight: .black))
                            .foregroundStyle(.white)
                        Text("\(tab.label) \(inTab.count)곳 모두")
                            .font(.system(size: 11))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 18)
            }
            .frame(height: 96)
        }
        .buttonStyle(.plain)
    }

    private var grid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: DT.Spacing.gridGap), GridItem(.flexible())], spacing: DT.Spacing.gridGap) {
            ForEach(folders, id: \.self) { filter in
                FolderCard(
                    emoji: filter.emoji,
                    title: filter.title,
                    count: count(filter),
                    isHighlighted: filter == .again,
                    action: { path.append(.list(filter)) }
                )
            }
        }
    }
}
