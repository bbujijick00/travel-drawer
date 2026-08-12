import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var tab: PlaceTab = .wish
    @State private var path: [Route] = []
    @State private var isAddPresented = false
    @State private var addTab: PlaceTab = .wish

    private var showsTabBar: Bool {
        if case .detail = path.last { return false }
        return true
    }

    var body: some View {
        ZStack {
            DT.Colors.appBackground.ignoresSafeArea()

            NavigationStack(path: $path) {
                FoldersView(tab: $tab, path: $path)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .list(let filter):
                            PlaceListView(tab: tab, filter: filter, path: $path)
                        case .detail(let place):
                            PlaceDetailView(place: place)
                        }
                    }
            }
            .safeAreaInset(edge: .bottom) {
                if showsTabBar {
                    BottomTabBar(onAddTapped: {
                        addTab = tab
                        isAddPresented = true
                    })
                }
            }
        }
        .fullScreenCover(isPresented: $isAddPresented) {
            AddPlaceView(initialTab: addTab)
        }
        .task {
            SeedData.insertIfNeeded(context: modelContext)
        }
    }
}
