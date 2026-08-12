import SwiftUI
import SwiftData

struct PlaceListView: View {
    let tab: PlaceTab
    @State var filter: ListFilter
    @Binding var path: [Route]

    @Query private var allPlaces: [Place]

    private var inTab: [Place] {
        allPlaces.filter { $0.tab == tab }
    }

    private var filtered: [Place] {
        switch filter {
        case .all: inTab
        case .again: inTab.filter(\.isHearted)
        case .category(let c): inTab.filter { $0.category == c }
        case .region: inTab
        }
    }

    private var regionSections: [(region: String, places: [Place])] {
        let groups = Dictionary(grouping: filtered, by: \.region)
        return groups.keys.sorted().map { ($0, groups[$0] ?? []) }
    }

    /// The category chip row switches between 전체/맛집/카페/숙소/명소 — it isn't
    /// shown for the "다시 가고 싶은" or "지역별" folders, which have their own identity.
    private var showsCategoryChips: Bool {
        switch filter {
        case .all, .category: true
        case .again, .region: false
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                if showsCategoryChips {
                    chipRow
                }
                if filter == .region {
                    regionGroupedList
                } else {
                    flatList
                }
            }
            .padding(.horizontal, DT.Spacing.screenH)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(DT.Colors.screenBackground)
        .navigationBarHidden(true)
    }

    private var header: some View {
        HStack(alignment: .top) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .fill(DT.Colors.subSurfaceAlt)
                        .frame(width: 34, height: 34)
                    Text(filter.emoji).font(.system(size: 17))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(filter.title)
                        .font(.system(size: 22, weight: .black))
                        .foregroundStyle(DT.Colors.textStrong)
                    Text("\(filtered.count)곳")
                        .font(.system(size: 11))
                        .foregroundStyle(DT.Colors.textFaint)
                }
            }
            Spacer()
            Button {
                path.removeLast()
            } label: {
                Text("‹ 종류")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(DT.Colors.textFaint)
            }
            .buttonStyle(.plain)
        }
    }

    private var chipRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DT.Spacing.chipGap) {
                chip(.all)
                ForEach(PlaceCategory.allCases) { chip(.category($0)) }
            }
        }
    }

    private func chip(_ target: ListFilter) -> some View {
        let isActive = filter == target
        return Button {
            filter = target
        } label: {
            Text(target.title)
                .font(.system(size: 11.5, weight: .bold))
                .foregroundStyle(isActive ? Color.white : DT.Colors.textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(isActive ? DT.Colors.accent : DT.Colors.subSurfaceAlt2)
                )
        }
        .buttonStyle(.plain)
    }

    private var flatList: some View {
        LazyVStack(spacing: DT.Spacing.cardGap) {
            ForEach(filtered) { place in
                Button { path.append(.detail(place)) } label: {
                    PlaceCard(place: place, showsHeart: tab == .visited)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var regionGroupedList: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            ForEach(regionSections, id: \.region) { section in
                VStack(alignment: .leading, spacing: DT.Spacing.cardGap) {
                    Text(section.region)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(DT.Colors.textSecondary)
                    ForEach(section.places) { place in
                        Button { path.append(.detail(place)) } label: {
                            PlaceCard(place: place, showsHeart: tab == .visited)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}
