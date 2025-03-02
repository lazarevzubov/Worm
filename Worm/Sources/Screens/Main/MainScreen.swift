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

/// The main screen visual representation.
struct MainScreen<
    FavoritesView: View,
    RecommendationsView: View,
    SearchView: View,
    ViewModel: MainScreenViewModel
>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        TabView {
            NavigationStack {
                searchView
                    .searchable(text: $viewModel.query, placement: .toolbar, prompt: "Search books")
                    .autocorrectionDisabled(true)
                    .toolbarColorScheme(.light, for: .automatic)
                    .navigationTitle("Search")
                    .toolbarBackground(Color.search, for: .automatic)
                    .toolbarBackground(.visible, for: .automatic)
            }
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            NavigationStack {
                recommendationsView
                    .toolbarColorScheme(.light, for: .automatic)
                    .navigationTitle("Recommendations")
                    .toolbarBackground(Color.recommendations, for: .automatic)
                    .toolbarBackground(.visible, for: .automatic)
            }
                .tabItem {
                    Label("Recommendations", systemImage: "checkmark")
                }
            NavigationStack {
                favoritesView
                    .toolbarColorScheme(.light, for: .automatic)
                    .navigationTitle("Favourites")
                    .toolbarBackground(Color.favorites, for: .automatic)
                    .toolbarBackground(.visible, for: .automatic)
            }
                .tabItem {
                    Label("Favourites", systemImage: "heart")
                }
        }
    }

    // MARK: Private properties

    private let favoritesView: FavoritesView
    private let recommendationsView: RecommendationsView
    private let searchView: SearchView
    @ObservedObject
    private var viewModel: ViewModel
    @State
    private var searchQuery = ""

    // MARK: - Initialization

    /// Creates a view object.
    /// - Parameters:
    ///   - searchView: The Search tab visual representation.
    ///   - recommendationsView: The Recommendations tab visual representation.
    ///   - favoritesView: The Favorites tab visual representation.
    ///   - viewModel: The presentation logic handler.
    init(
        searchView: SearchView,
        recommendationsView: RecommendationsView,
        favoritesView: FavoritesView,
        viewModel: ViewModel
    ) {
        self.searchView = searchView
        self.recommendationsView = recommendationsView
        self.favoritesView = favoritesView

        self.viewModel = viewModel
    }

}

#if DEBUG

// MARK: -

#Preview {
    MainScreen(
        searchView: SearchView(viewModel: SearchPreviewViewModel()),
        recommendationsView: RecommendationsView(viewModel: RecommendationsPreviewViewModel()),
        favoritesView: FavoritesView(viewModel: FavoritesPreviewsViewModel()), 
        viewModel: MainScreenPreviewViewModel()
    )
}

#endif
