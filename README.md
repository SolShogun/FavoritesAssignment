# Favorites — SwiftUI State & Architecture Assignment
A native iOS Favorites application built with SwiftUI and MVVM-style shared observable state.
Features
- Explore Cities, Hobbies, and Books with category-specific search
- Favorite and unfavorite items from Explore or Favorites
- Favorites grouped by category and synchronized instantly
- Persist favorite IDs using UserDefaults
- Select System, Light, or Dark theme; preference persists across launches
- Confirm before clearing all favorites
- Accessible heart controls and polished empty states
Run in Xcode
1. On a Mac, install Xcode.
2. Choose File > New > Project > iOS > App. Name it Favorites and select SwiftUI with Swift language, iOS 16 or later.
3. Delete the generated ContentView.swift and generated FavoritesApp.swift from the project (use Move to Trash only for these generated files).
4. Drag all four files in Sources/ into the Xcode project, checking Copy items if needed and the app target.
5. Select an iPhone simulator, then choose Product > Run.
6. Verify favorites persist after relaunch, the Favorites tab updates instantly, and Settings changes appearance.
Project files
- FavoritesApp.swift: app entry and shared environment object
- FavoritesStore.swift: models, sample catalog, persistence, theme state
- RootView.swift: Explore, Favorites, Settings and reusable UI components
Important
This is a self-contained implementation supplied as Swift source, not a compiled or simulator-tested Xcode project. The included sample catalog should be replaced with the instructor's exact starter data if required. The original instructor project may include additional image assets not bundled here.
