//
//  ViewFactory.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 8.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// A set of creational methods for building views for the app.
enum ViewFactory {

    // MARK: - Methods

    /**
     Creates the main view of the app.
     - Parameters:
        - catalogueService: The main data service of the app.
        - favoritesService: The favorite books list manager.
     - Returns: The main view of the app.
     */
    static func makeMainView(catalogueService: CatalogueService, favoritesService: FavoritesService) -> some View {
        let searchView = makeSearchView(catalogueService: catalogueService, favoritesService: favoritesService)
        let recommendationsView = makeRecommendationsView(catalogueService: catalogueService,
                                                          favoritesService: favoritesService)
        
        return MainView(searchView: searchView, recommendationsView: recommendationsView)
    }

    // MARK: Private methods

    private static func makeSearchView(catalogueService: CatalogueService,
                                       favoritesService: FavoritesService) -> some View {
        let model = SearchServiceBasedModel(catalogueService: catalogueService, favoritesService: favoritesService)
        let presenter = SearchDefaultPresenter(model: model)

        return SearchView<SearchDefaultPresenter<SearchServiceBasedModel>>(presenter: presenter)
    }

    private static func makeRecommendationsView(catalogueService: CatalogueService,
                                                favoritesService: FavoritesService) -> some View {
        let model = RecommendationsServiceBasedModel(catalogueService: catalogueService,
                                                     favoritesService: favoritesService)
        let recommendationsManager = RecommendationsDefaultManager(catalogueService: catalogueService)
        
        let presenter = RecommendationsDefaultPresenter(model: model, recommendationsManager: recommendationsManager)

        return RecommendationsView(presenter: presenter)
    }

}
