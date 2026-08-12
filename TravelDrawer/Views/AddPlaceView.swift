import SwiftUI
import PhotosUI
import SwiftData

struct AddPlaceView: View {
    let initialTab: PlaceTab

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var tab: PlaceTab
    @State private var name = ""
    @State private var category: PlaceCategory = .food
    @State private var region = ""
    @State private var tagsText = ""
    @State private var memo = ""

    @State private var photoFilenames: [String] = []
    @State private var pickerItems: [PhotosPickerItem] = []

    @State private var linkLabel = ""
    @State private var linkURL = ""
    @State private var links: [PlaceLink] = []

    init(initialTab: PlaceTab) {
        self.initialTab = initialTab
        _tab = State(initialValue: initialTab)
    }

    var body: some View {
        VStack(spacing: 0) {
            headerBar
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    TabToggle(selection: $tab)
                    photosSection
                    fieldSection(title: "장소 이름") {
                        TextField("장소 이름을 입력해요", text: $name)
                            .textFieldStyle(.plain)
                    }
                    categorySection
                    fieldSection(title: "지역") {
                        HStack {
                            TextField("지역을 입력해요", text: $region)
                                .textFieldStyle(.plain)
                            Button("📍 지도에서 찾기") {}
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(DT.Colors.textSecondary)
                        }
                    }
                    fieldSection(title: "태그") {
                        TextField("쉼표로 구분해서 입력해요", text: $tagsText)
                            .textFieldStyle(.plain)
                    }
                    linksSection
                    fieldSection(title: "메모") {
                        TextField("메모를 남겨보세요", text: $memo, axis: .vertical)
                            .lineLimit(3...6)
                            .textFieldStyle(.plain)
                    }
                    saveButtonBlock
                }
                .padding(.horizontal, DT.Spacing.screenH)
                .padding(.top, 18)
                .padding(.bottom, 30)
            }
            .background(DT.Colors.screenBackground)
        }
        .background(DT.Colors.screenBackground)
        .onChange(of: pickerItems) { _, items in
            Task { await loadPickedPhotos(items) }
        }
    }

    // MARK: Header

    private var headerBar: some View {
        HStack {
            Button("취소") { dismiss() }
                .foregroundStyle(DT.Colors.textFaint)
            Spacer()
            Text("새 장소")
                .font(.system(size: 14, weight: .black))
                .foregroundStyle(DT.Colors.textStrong)
            Spacer()
            Button("저장") { save() }
                .foregroundStyle(DT.Colors.accent)
                .fontWeight(.black)
        }
        .font(.system(size: 14, weight: .semibold))
        .padding(.horizontal, DT.Spacing.screenH)
        .frame(height: 52)
        .background(DT.Colors.screenBackground)
        .overlay(alignment: .bottom) {
            Rectangle().fill(DT.Colors.subSurfaceAlt2).frame(height: 1)
        }
    }

    // MARK: Photos

    private var photosSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("사진 · 첫 장이 대표 사진")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(DT.Colors.textSecondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(photoFilenames.enumerated()), id: \.offset) { index, filename in
                        ZStack(alignment: .topLeading) {
                            PlacePhotoView(filename: filename, cornerRadius: 12)
                                .frame(width: 64, height: 64)
                            if index == 0 {
                                Text("대표")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(DT.Colors.accent, in: Capsule())
                                    .offset(x: 4, y: -6)
                            }
                        }
                    }

                    PhotosPicker(selection: $pickerItems, matching: .images) {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(DT.Colors.borderAlt, style: StrokeStyle(lineWidth: 1.5, dash: [5]))
                            .frame(width: 64, height: 64)
                            .overlay(Image(systemName: "plus").foregroundStyle(DT.Colors.textFainter))
                    }
                }
            }
        }
    }

    private func loadPickedPhotos(_ items: [PhotosPickerItem]) async {
        for item in items {
            guard let data = try? await item.loadTransferable(type: Data.self),
                  let filename = PhotoStorage.save(data) else { continue }
            photoFilenames.append(filename)
        }
        pickerItems = []
    }

    // MARK: Category

    private var categorySection: some View {
        fieldSection(title: "종류") {
            HStack(spacing: DT.Spacing.chipGap) {
                ForEach(PlaceCategory.allCases) { c in
                    let isActive = category == c
                    Button { category = c } label: {
                        Text("\(c.emoji) \(c.rawValue)")
                            .font(.system(size: 11.5, weight: .bold))
                            .foregroundStyle(isActive ? Color.white : DT.Colors.textSecondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(isActive ? DT.Colors.accent : DT.Colors.subSurfaceAlt2))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: Links

    private var linksSection: some View {
        fieldSection(title: "저장할 링크") {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(links) { link in
                    HStack {
                        Text("📝 \(link.label.isEmpty ? link.url : link.label)")
                            .font(.system(size: 12))
                            .foregroundStyle(DT.Colors.textBody)
                        Spacer()
                        Button {
                            links.removeAll { $0.id == link.id }
                        } label: {
                            Image(systemName: "xmark.circle.fill").foregroundStyle(DT.Colors.textFainter)
                        }
                        .buttonStyle(.plain)
                    }
                }
                HStack(spacing: 8) {
                    TextField("링크 이름", text: $linkLabel).textFieldStyle(.plain)
                    TextField("https://...", text: $linkURL).textFieldStyle(.plain)
                    Button("추가") {
                        guard !linkURL.isEmpty else { return }
                        links.append(PlaceLink(icon: "📝", label: linkLabel, url: linkURL))
                        linkLabel = ""
                        linkURL = ""
                    }
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(DT.Colors.accent)
                }
            }
        }
    }

    // MARK: Shared field chrome

    private func fieldSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(DT.Colors.textSecondary)
            content()
                .padding(12)
                .background(DT.Colors.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    private var saveButtonBlock: some View {
        VStack(spacing: 8) {
            Button { save() } label: {
                Text("서랍에 저장하기")
                    .font(.system(size: 15, weight: .black))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(DT.Colors.accent, in: RoundedRectangle(cornerRadius: DT.Radius.button, style: .continuous))
                    .dtShadow(DT.Shadow.accentButton)
            }
            .buttonStyle(.plain)
            Text("비워둔 항목은 나중에 채워도 돼요")
                .font(.system(size: 11))
                .foregroundStyle(DT.Colors.textFaint)
        }
        .padding(.top, 8)
    }

    private func save() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let tags = tagsText
            .split(whereSeparator: { $0 == "," || $0 == " " })
            .map(String.init)
            .filter { !$0.isEmpty }

        let place = Place(
            name: name,
            tab: tab,
            category: category,
            region: region,
            photos: photoFilenames,
            tags: tags,
            links: links,
            memo: memo
        )
        modelContext.insert(place)
        dismiss()
    }
}
