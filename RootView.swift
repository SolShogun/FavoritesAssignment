import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            ExploreView().tabItem { Label("Explore", systemImage: "square.grid.2x2.fill") }
            FavoritesView().tabItem { Label("Favorites", systemImage: "heart.fill") }
            SettingsView().tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .tint(.indigo)
    }
}

struct ExploreView: View {
    @State private var category: Category = .cities
    @State private var search = ""
    var filtered: [FavoriteItem] {
        Catalog.items.filter { $0.category == category && (search.isEmpty || $0.title.localizedCaseInsensitiveContains(search) || $0.subtitle.localizedCaseInsensitiveContains(search)) }
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Discover something you love")
                        .font(.subheadline).foregroundStyle(.secondary)
                    Picker("Category", selection: $category) {
                        ForEach(Category.allCases) { category in
                            Label(category.rawValue, systemImage: category.symbol).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: category) { _ in search = "" }
                    if filtered.isEmpty {
                        EmptyState(symbol: "magnifyingglass", title: "No matches", detail: "Try another search term.")
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(filtered) { item in ItemRow(item: item) }
                        }
                    }
                }.padding()
            }
            .navigationTitle("Explore")
            .searchable(text: $search, prompt: "Search \(category.rawValue.lowercased())")
        }
    }
}

struct ItemRow: View {
    @EnvironmentObject private var store: FavoritesStore
    let item: FavoriteItem
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: item.symbol)
                .font(.title2).foregroundStyle(.indigo)
                .frame(width: 54, height: 54)
                .background(Color.indigo.opacity(0.10), in: RoundedRectangle(cornerRadius: 14))
            VStack(alignment: .leading, spacing: 5) {
                Text(item.title).font(.headline)
                Text(item.subtitle).font(.subheadline).foregroundStyle(.secondary)
                Text(item.category.rawValue.uppercased())
                    .font(.caption2.weight(.semibold)).foregroundStyle(.indigo)
            }
            Spacer(minLength: 8)
            Button { store.toggle(item) } label: {
                Image(systemName: store.isFavorite(item) ? "heart.fill" : "heart")
                    .font(.title3).foregroundStyle(store.isFavorite(item) ? .pink : .secondary)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(store.isFavorite(item) ? "Remove \(item.title) from favorites" : "Add \(item.title) to favorites")
        }
        .padding(12)
        .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18))
    }
}

struct FavoritesView: View {
    @EnvironmentObject private var store: FavoritesStore
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    if store.favorites.isEmpty {
                        EmptyState(symbol: "heart.slash", title: "No favorites yet", detail: "Explore categories and tap a heart to save items.")
                    } else {
                        ForEach(Category.allCases) { category in
                            let items = store.favorites.filter { $0.category == category }
                            if !items.isEmpty {
                                HStack {
                                    Label(category.rawValue, systemImage: category.symbol)
                                        .font(.headline)
                                    Spacer()
                                }.padding(.top, 8)
                                ForEach(items) { item in ItemRow(item: item) }
                            }
                        }
                    }
                }.padding()
            }
            .navigationTitle("Favorites")
            .background(Color(uiColor: .systemGroupedBackground))
        }
    }
}

struct EmptyState: View {
    let symbol: String
    let title: String
    let detail: String
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: symbol).font(.system(size: 42)).foregroundStyle(.indigo)
            Text(title).font(.title3.bold())
            Text(detail).font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(36)
    }
}

struct SettingsView: View {
    @EnvironmentObject private var store: FavoritesStore
    @State private var showingClearConfirmation = false
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $store.theme) {
                        ForEach(AppTheme.allCases) { theme in Text(theme.rawValue).tag(theme) }
                    }
                }
                Section("Saved items") {
                    LabeledContent("Favorites", value: "\(store.favorites.count)")
                    Button("Clear All Favorites", role: .destructive) {
                        showingClearConfirmation = true
                    }
                    .disabled(store.favorites.isEmpty)
                }
                Section {
                    Text("Your favorites and appearance settings are saved on this device.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog("Remove all favorites?", isPresented: $showingClearConfirmation, titleVisibility: .visible) {
                Button("Clear All Favorites", role: .destructive) { store.clear() }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This removes every saved city, hobby, and book. This cannot be undone.")
            }
        }
    }
}
