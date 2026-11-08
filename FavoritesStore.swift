import SwiftUI

struct FavoriteItem: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let symbol: String
    let category: Category
}

enum Category: String, CaseIterable, Identifiable, Codable {
    case cities = "Cities", hobbies = "Hobbies", books = "Books"
    var id: String { rawValue }
    var symbol: String {
        switch self { case .cities: return "building.2.fill"; case .hobbies: return "paintpalette.fill"; case .books: return "books.vertical.fill" }
    }
}

enum AppTheme: String, CaseIterable, Identifiable {
    case system = "System", light = "Light", dark = "Dark"
    var id: String { rawValue }
    var colorScheme: ColorScheme? {
        switch self { case .system: return nil; case .light: return .light; case .dark: return .dark }
    }
}

enum Catalog {
    static let items: [FavoriteItem] = [
        .init(id: "city-atlanta", title: "Atlanta", subtitle: "Georgia, USA", symbol: "building.2.crop.circle", category: .cities),
        .init(id: "city-newyork", title: "New York", subtitle: "New York, USA", symbol: "building.2.fill", category: .cities),
        .init(id: "city-paris", title: "Paris", subtitle: "France", symbol: "globe.europe.africa.fill", category: .cities),
        .init(id: "city-tokyo", title: "Tokyo", subtitle: "Japan", symbol: "sun.horizon.fill", category: .cities),
        .init(id: "hobby-reading", title: "Reading", subtitle: "Books and stories", symbol: "book.fill", category: .hobbies),
        .init(id: "hobby-hiking", title: "Hiking", subtitle: "Outdoor adventures", symbol: "figure.hiking", category: .hobbies),
        .init(id: "hobby-photography", title: "Photography", subtitle: "Capture moments", symbol: "camera.fill", category: .hobbies),
        .init(id: "hobby-cooking", title: "Cooking", subtitle: "Make something delicious", symbol: "fork.knife", category: .hobbies),
        .init(id: "book-1984", title: "1984", subtitle: "George Orwell", symbol: "book.closed.fill", category: .books),
        .init(id: "book-pride", title: "Pride and Prejudice", subtitle: "Jane Austen", symbol: "book.closed.fill", category: .books),
        .init(id: "book-mockingbird", title: "To Kill a Mockingbird", subtitle: "Harper Lee", symbol: "book.closed.fill", category: .books),
        .init(id: "book-gatsby", title: "The Great Gatsby", subtitle: "F. Scott Fitzgerald", symbol: "book.closed.fill", category: .books)
    ]
}

final class FavoritesStore: ObservableObject {
    @Published private(set) var favoriteIDs: Set<String> = []
    @Published var theme: AppTheme = .system {
        didSet { UserDefaults.standard.set(theme.rawValue, forKey: "appTheme") }
    }
    init() {
        favoriteIDs = Set(UserDefaults.standard.stringArray(forKey: "favoriteIDs") ?? [])
        theme = AppTheme(rawValue: UserDefaults.standard.string(forKey: "appTheme") ?? "System") ?? .system
    }
    var favorites: [FavoriteItem] { Catalog.items.filter { favoriteIDs.contains($0.id) } }
    func isFavorite(_ item: FavoriteItem) -> Bool { favoriteIDs.contains(item.id) }
    func toggle(_ item: FavoriteItem) {
        if favoriteIDs.contains(item.id) { favoriteIDs.remove(item.id) }
        else { favoriteIDs.insert(item.id) }
        save()
    }
    func clear() { favoriteIDs.removeAll(); save() }
    private func save() { UserDefaults.standard.set(Array(favoriteIDs).sorted(), forKey: "favoriteIDs") }
}
