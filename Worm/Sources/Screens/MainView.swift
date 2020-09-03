//
//  MainView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 25.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The main screen visual representation.
struct MainView<SearchView: View, RecommendationsView: View>: View {

    // TODO: Check accessibility.

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        TabView {
            searchView
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("SearchScreenTitle")
            }
            recommendationsView
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("RecommendationsScreenTitle")
            }
        }
    }

    // MARK: Private properties

    private let searchView: SearchView
    private let recommendationsView: RecommendationsView

    // MARK: - Initialization

    /**
     Creates a view object.
     - Parameters:
        - searchView: The Search tab visual representation.
        - recommendationsView: The Recommendations tab visual representation.
     */
    init(searchView: SearchView, recommendationsView: RecommendationsView) {
        self.searchView = searchView
        self.recommendationsView = recommendationsView
    }

}

// MARK: -

/// The main screen visual representation for the SwiftUI Previews.
struct MainView_Previews: PreviewProvider {

    // MARK: - Properties

    // MARK: PreviewProvider protocol properties

    static var previews: some View {
        MainView(searchView: SearchView(presenter: SearchPreviewPresenter()),
                 recommendationsView: RecommendationsView(presenter: RecommendationsPreviewPresenter()))
    }

}
