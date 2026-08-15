//
//  MainScreen.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 25.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The main screen visual representation.
struct MainScreen<
    SearchView: View,
    RecommendationsView: View,
    FavoritesView: View,
    BlockedView: View,
    ViewModel: MainScreenViewModel
>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        TabView {
            NavigationStack {
                searchView
                    // Makes the whole content area participate in hit testing, including otherwise empty areas.
                    .contentShape(Rectangle())
                    .simultaneousGesture(TapGesture().onEnded { searchFieldFocused = false }, including: .all)
                    .navigationTitle("Search")
                    .searchable(text: $viewModel.query, prompt: "Search books")
                    .searchFocused($searchFieldFocused)
                    .autocorrectionDisabled(true)
            }
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                        .accessibilityIdentifier("SearchTabButton")
                }
            NavigationStack {
                recommendationsView
                    .navigationTitle("Recommendations")
            }
                .tabItem {
                    Label("Recommendations", systemImage: "checkmark")
                        .accessibilityIdentifier("RecommendationsTabButton")
                }
            NavigationStack {
                favoritesView
                    .navigationTitle("Favorites")
            }
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                        .accessibilityIdentifier("FavoritesTabButton")
                }
            NavigationStack {
                blockedView
                    .navigationTitle("Blocked")
            }
                .tabItem {
                    Label("Blocked", systemImage: "nosign")
                        .accessibilityIdentifier("BlockedTabButton")
                }
        }
    }

    // MARK: Private properties

    private let blockedView: BlockedView
    private let favoritesView: FavoritesView
    private let recommendationsView: RecommendationsView
    private let searchView: SearchView
    @FocusState
    private var searchFieldFocused: Bool
    @ObservedObject
    private var viewModel: ViewModel

    // MARK: - Initialization

    /// Creates a view object.
    /// - Parameters:
    ///   - searchView: The Search tab visual representation.
    ///   - recommendationsView: The Recommendations tab visual representation.
    ///   - favoritesView: The Favorites tab visual representation.
    ///   - blockedView: The Blocked tab visual representation.
    ///   - viewModel: The presentation logic handler.
    init(
        searchView: SearchView,
        recommendationsView: RecommendationsView,
        favoritesView: FavoritesView,
        blockedView: BlockedView,
        viewModel: ViewModel
    ) {
        self.searchView = searchView
        self.recommendationsView = recommendationsView
        self.favoritesView = favoritesView
        self.blockedView = blockedView

        self.viewModel = viewModel
    }

}

// MARK: -

#Preview {
    MainScreen(
        searchView: SearchView(viewModel: SearchPreviewViewModel()),
        recommendationsView: RecommendationsView(viewModel: RecommendationsPreviewViewModel()),
        favoritesView: FavoritesView(viewModel: FavoritesPreviewsViewModel()),
        blockedView: BlockedBooksView(viewModel: BlockedBooksPreviewViewModel()),
        viewModel: MainScreenPreviewViewModel()
    )
}
