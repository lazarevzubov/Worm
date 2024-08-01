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
struct MainScreen<FavoritesView: View,
                  RecommendationsView: View,
                  SearchView: View,
                  ViewModel: MainScreenViewModel>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        NavigationStack {
            TabView(selection: $tab) {
                searchView
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
                    .tag(Tab.search)
                recommendationsView
                    .tabItem { Label("Recommendations", systemImage: "checkmark") }
                    .tag(Tab.recommendations)
                favoritesView
                    .tabItem { Label("Favourites", systemImage: "heart") }
                    .tag(Tab.favorites)
            }
                .if(tab == .search) {
                    $0
                        .searchable(text: $viewModel.query, placement: .toolbar, prompt: "Search books")
                        .autocorrectionDisabled(true)
                }
                .toolbarColorScheme(.light, for: .automatic)
                .navigationTitle(tab.title)
                .toolbarBackground(tab.color, for: .automatic)
                .toolbarBackground(.visible, for: .automatic)
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
    @State
    private var tab = Tab.search

    // MARK: - Initialization

    /// Creates a view object.
    /// - Parameters:
    ///   - searchView: The Search tab visual representation.
    ///   - recommendationsView: The Recommendations tab visual representation.
    ///   - favoritesView: The Favorites tab visual representation.
    ///   - viewModel: The presentation logic handler.
    init(searchView: SearchView,
         recommendationsView: RecommendationsView,
         favoritesView: FavoritesView,
         viewModel: ViewModel) {
        self.searchView = searchView
        self.recommendationsView = recommendationsView
        self.favoritesView = favoritesView

        self.viewModel = viewModel
    }

    // MARK: -

    private enum Tab {

        case search
        case recommendations
        case favorites

        var color: Color {
            switch self {
                case .search:
                    .search
                case .recommendations:
                    .recommendations
                case .favorites:
                    .favorites
            }
        }
        var title: LocalizedStringKey {
            switch self {
                case .search:
                    "Search"
                case .recommendations:
                    "Recommendations"
                case .favorites:
                    "Favourites"
            }
        }

    }

}

#if DEBUG

// MARK: -

#Preview {
    MainScreen(searchView: SearchView(viewModel: SearchPreviewViewModel()),
               recommendationsView: RecommendationsView(viewModel: RecommendationsPreviewViewModel()),
               favoritesView: FavoritesView(viewModel: FavoritesPreviewsViewModel()), 
               viewModel: MainScreenPreviewViewModel())
}

#endif
