import Foundation
import SwiftData

enum PlaceTab: String, Codable, CaseIterable, Hashable {
    case wish
    case visited

    var label: String {
        switch self {
        case .wish: "가보고 싶어"
        case .visited: "다녀왔어요"
        }
    }
}

enum PlaceCategory: String, Codable, CaseIterable, Identifiable, Hashable {
    case food = "맛집"
    case cafe = "카페"
    case stay = "숙소"
    case sight = "명소"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .food: "🍜"
        case .cafe: "☕"
        case .stay: "🛏"
        case .sight: "🏛"
        }
    }
}

enum PlaceStatus: String, Codable, Hashable {
    case open
    case changed
    case closed

    var label: String {
        switch self {
        case .open: "영업중"
        case .changed: "정보 바뀜"
        case .closed: "폐업"
        }
    }
}

struct PlaceLink: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var icon: String
    var label: String
    var url: String
}

@Model
final class Place {
    var id: UUID = UUID()
    var tab: PlaceTab = PlaceTab.wish
    var name: String = ""
    var category: PlaceCategory = PlaceCategory.food
    var region: String = ""

    /// Photo asset/file identifiers. First entry is the cover photo.
    var photos: [String] = []
    var tags: [String] = []
    var links: [PlaceLink] = []

    var status: PlaceStatus = PlaceStatus.open
    var lastCheckedAt: Date?

    var sub: String = ""
    var addr: String = ""
    var hours: String = ""
    var access: String = ""
    var visitDate: Date?
    var memo: String = ""

    /// "다시 가고 싶은" — only meaningful (and shown) for visited places.
    var isHearted: Bool = false

    var createdAt: Date = Date()

    init(
        name: String,
        tab: PlaceTab,
        category: PlaceCategory,
        region: String = "",
        photos: [String] = [],
        tags: [String] = [],
        links: [PlaceLink] = [],
        status: PlaceStatus = .open,
        lastCheckedAt: Date? = nil,
        sub: String = "",
        addr: String = "",
        hours: String = "",
        access: String = "",
        visitDate: Date? = nil,
        memo: String = "",
        isHearted: Bool = false
    ) {
        self.id = UUID()
        self.name = name
        self.tab = tab
        self.category = category
        self.region = region
        self.photos = photos
        self.tags = tags
        self.links = links
        self.status = status
        self.lastCheckedAt = lastCheckedAt
        self.sub = sub
        self.addr = addr
        self.hours = hours
        self.access = access
        self.visitDate = visitDate
        self.memo = memo
        self.isHearted = isHearted
        self.createdAt = Date()
    }

    var checkedLabel: String {
        guard let lastCheckedAt else { return "확인 기록 없음" }
        let days = Calendar.current.dateComponents([.day], from: lastCheckedAt, to: Date()).day ?? 0
        switch days {
        case ..<1: return "오늘 확인"
        case 1: return "1일 전 확인"
        default: return "\(days)일 전 확인"
        }
    }
}
