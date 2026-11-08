import SwiftUI

@main
struct FavoritesApp: App {
    @StateObject private var store = FavoritesStore()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .preferredColorScheme(store.theme.colorScheme)
        }
    }
}
