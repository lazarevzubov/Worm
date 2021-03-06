//
//  ViewFactory.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 8.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// A set of creational methods for building views for the app.
enum ViewFactory<RecommendationsService: FavoritesService> {

    // MARK: - Methods

    /**
     Creates the main view of the app.
     - Parameters:
        - catalogueService: The main data service of the app.
        - favoritesService: The favorite books list manager.
     - Returns: The main view of the app.
     */
    static func makeMainView(catalogueService: CatalogueService,
                             favoritesService: RecommendationsService,
                             imageService: ImageService) -> some View {
        let searchView = makeSearchView(catalogueService: catalogueService,
                                        favoritesService: favoritesService,
                                        imageService: imageService)
        let recommendationsView = makeRecommendationsView(catalogueService: catalogueService,
                                                          favoritesService: favoritesService,
                                                          imageService: imageService)
        let favoritesView = makeFavoritesView(catalogueService: catalogueService,
                                              favoritesService: favoritesService,
                                              imageService: imageService)

        return MainView(searchView: searchView, recommendationsView: recommendationsView, favoritesView: favoritesView)
    }

    // MARK: Private methods

    private static func makeSearchView(catalogueService: CatalogueService,
                                       favoritesService: RecommendationsService,
                                       imageService: ImageService) -> some View {
        let model = SearchServiceBasedModel(catalogueService: catalogueService, favoritesService: favoritesService)
        let presenter = SearchDefaultPresenter(model: model, imageService: imageService)

        return SearchView<SearchDefaultPresenter<SearchServiceBasedModel>>(presenter: presenter)
    }

    private static func makeRecommendationsView(catalogueService: CatalogueService,
                                                favoritesService: RecommendationsService,
                                                imageService: ImageService) -> some View {
        let recommendationsModel = RecommendationsDefaultModel(catalogueService: catalogueService,
                                                               favoritesService: favoritesService)
        let presenter = RecommendationsDefaultPresenter(model: recommendationsModel, imageService: imageService)

        return RecommendationsView(presenter: presenter)
    }

    private static func makeFavoritesView(catalogueService: CatalogueService,
                                          favoritesService: RecommendationsService,
                                          imageService: ImageService) -> some View {
        let model = FavoritesServiceBasedModel(catalogueService: catalogueService, favoritesService: favoritesService)
        let presenter = FavoritesDefaultPresenter(model: model, imageService: imageService)

        return FavoritesView(presenter: presenter)
    }

}
