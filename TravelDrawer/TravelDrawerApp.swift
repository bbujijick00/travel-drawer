import SwiftUI
import SwiftData

@main
struct TravelDrawerApp: App {
    let container: ModelContainer

    init() {
        container = try! ModelContainer(for: Place.self)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(container)
    }
}
