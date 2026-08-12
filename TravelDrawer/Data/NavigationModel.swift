import Foundation

/// `list` view filter. `.region` renders a region-grouped version of the full
/// list instead of a single category (per README's grouping recommendation).
enum ListFilter: Hashable {
    case all
    case again
    case category(PlaceCategory)
    case region

    var title: String {
        switch self {
        case .all: "전체"
        case .again: "다시 가고 싶은"
        case .category(let c): c.rawValue
        case .region: "지역별"
        }
    }

    var emoji: String {
        switch self {
        case .all: "🗂"
        case .again: "♥"
        case .category(let c): c.emoji
        case .region: "📍"
        }
    }
}

enum Route: Hashable {
    case list(ListFilter)
    case detail(Place)
}
