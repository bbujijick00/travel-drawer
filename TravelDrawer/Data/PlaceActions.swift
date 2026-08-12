import Foundation
import SwiftData

extension SeedData {
    /// Populates the store with sample places on first launch only.
    static func insertIfNeeded(context: ModelContext) {
        let existing = try? context.fetch(FetchDescriptor<Place>())
        guard (existing ?? []).isEmpty else { return }
        for place in places {
            context.insert(place)
        }
    }
}

extension Place {
    /// "다녀왔어요로 옮기기" — flips the tab; every other field (photos, memo,
    /// links, tags…) is left untouched. Nothing is deleted or recreated.
    func moveToVisited() {
        tab = .visited
        lastCheckedAt = Date()
    }
}
