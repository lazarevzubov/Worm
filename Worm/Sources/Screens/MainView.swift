//
//  MainView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 25.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

// TODO: Check iPads.

// TODO: HeaderDoc.
struct MainView<SearchView: View>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        TabView {
            searchView
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
            }
            Text("Recommendtations coming soon!")
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Recommendtations")
            }
        }
    }

    // MARK: Private properties

    private let searchView: SearchView

    // MARK: - Initialization

    // TODO: HeaderDoc.
    init(searchView: SearchView) {
        self.searchView = searchView
    }

}

// MARK: -

// TODO: HeaderDoc.
struct MainView_Previews: PreviewProvider {

    // MARK: - Properties

    // MARK: PreviewProvider protocol properties

    static var previews: some View { MainView(searchView: SearchView(presenter: SearchPreviewPresenter())) }

}
