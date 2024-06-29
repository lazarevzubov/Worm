//
//  MainScreen.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 25.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

// TODO: Accessibility.
// TODO: UI tests.
// TODO: iPads.

/// The main screen visual representation.
struct MainScreen<SearchView: View, RecommendationsView: View, FavoritesView: View>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        TabView {
            searchView
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            recommendationsView
                .tabItem {
                    Label("Recommendations", systemImage: "checkmark")
                }
            favoritesView
                .tabItem {
                    Label("Favourites", systemImage: "heart")
                }
        }
    }

    // MARK: Private properties

    private let favoritesView: FavoritesView
    private let recommendationsView: RecommendationsView
    private let searchView: SearchView

    // MARK: - Initialization

    /// Creates a view object.
    /// - Parameters:
    ///   - searchView: The Search tab visual representation.
    ///   - recommendationsView: The Recommendations tab visual representation.
    ///   - favoritesView: The Favorites tab visual representation.
    init(searchView: SearchView, recommendationsView: RecommendationsView, favoritesView: FavoritesView) {
        self.searchView = searchView
        self.recommendationsView = recommendationsView
        self.favoritesView = favoritesView
    }

}

#if DEBUG

// MARK: -

#Preview {
    let searchView = SearchView(viewModel: SearchPreviewViewModel())
    let recommendationsView = RecommendationsView(viewModel: RecommendationsPreviewViewModel())
    let favoritesView = FavoritesView(viewModel: FavoritesPreviewsViewModel())

    return MainScreen(searchView: searchView, recommendationsView: recommendationsView, favoritesView: favoritesView)
}

#endif
