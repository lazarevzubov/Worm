//
//  MainView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 25.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

// TODO: Accessibility.
// TODO: UI tests. Hardly possible with SwiftUI for now.

/// The main screen visual representation.
struct MainView<SearchView: View, RecommendationsView: View, FavoritesView: View>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        TabView {
            searchView
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .accessibility(hidden: true)
                    Text("SearchScreenTitle")
                }
            recommendationsView
                .tabItem {
                    Image(systemName: "checkmark")
                        .accessibility(hidden: true)
                    Text("RecommendationsScreenTitle")
                }
            favoritesView
                .tabItem {
                    Image(systemName: "heart")
                        .accessibility(hidden: true)
                    Text("FavoritesScreenTitle")
                }
        }
    }

    // MARK: Private properties

    private let favoritesView: FavoritesView
    private let recommendationsView: RecommendationsView
    private let searchView: SearchView

    // MARK: - Initialization

    /**
     Creates a view object.
     - Parameters:
        - searchView: The Search tab visual representation.
        - recommendationsView: The Recommendations tab visual representation.
        - favoritesView: The Favorites tab visual representation.
     */
    init(searchView: SearchView, recommendationsView: RecommendationsView, favoritesView: FavoritesView) {
        self.searchView = searchView
        self.recommendationsView = recommendationsView
        self.favoritesView = favoritesView
    }

}

// MARK: -

/// The main screen visual representation for the SwiftUI Previews.
struct MainView_Previews: PreviewProvider {

    // MARK: - Properties

    // MARK: PreviewProvider protocol properties

    static var previews: some View {
        let searchView = SearchView(presenter: SearchPreviewPresenter())
        let recommendationsView = RecommendationsView(presenter: RecommendationsPreviewPresenter())
        let favoritesView = FavoritesView(presenter: FavoritesPreviewPresenter())
        
        return MainView(searchView: searchView, recommendationsView: recommendationsView, favoritesView: favoritesView)
    }

}
