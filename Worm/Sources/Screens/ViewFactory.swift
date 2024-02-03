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

    /// Creates the main view of the app.
    /// - Parameters:
    ///   - catalogService: The main data service of the app.
    ///   - favoritesService: The favorite books list manager.
    /// - Returns: The main view of the app.
    static func makeMainView(catalogService: CatalogService,
                             favoritesService: RecommendationsService,
                             imageService: ImageService) -> some View {
        let searchView = makeSearchView(catalogService: catalogService,
                                        favoritesService: favoritesService,
                                        imageService: imageService)
        let recommendationsView = makeRecommendationsView(catalogService: catalogService,
                                                          favoritesService: favoritesService,
                                                          imageService: imageService)
        let favoritesView = makeFavoritesView(catalogService: catalogService,
                                              favoritesService: favoritesService,
                                              imageService: imageService)

        return MainView(searchView: searchView, recommendationsView: recommendationsView, favoritesView: favoritesView)
    }

    // MARK: Private methods

    private static func makeSearchView(catalogService: CatalogService,
                                       favoritesService: RecommendationsService,
                                       imageService: ImageService) -> some View {
        let model = SearchServiceBasedModel(catalogService: catalogService, favoritesService: favoritesService)
        let viewModel = SearchDefaultViewModel(model: model, imageService: imageService)

        return SearchView<SearchDefaultViewModel<SearchServiceBasedModel>>(viewModel: viewModel)
    }

    private static func makeRecommendationsView(catalogService: CatalogService,
                                                favoritesService: RecommendationsService,
                                                imageService: ImageService) -> some View {
        let recommendationsModel = RecommendationsDefaultModel(catalogService: catalogService,
                                                               favoritesService: favoritesService)
        let viewModel = RecommendationsDefaultViewModel(model: recommendationsModel, imageService: imageService)

        return RecommendationsView(viewModel: viewModel)
    }

    private static func makeFavoritesView(catalogService: CatalogService,
                                          favoritesService: RecommendationsService,
                                          imageService: ImageService) -> some View {
        let model = FavoritesServiceBasedModel(catalogService: catalogService, favoritesService: favoritesService)
        let viewModel = FavoritesDefaultViewModel(model: model, imageService: imageService)

        return FavoritesView(viewModel: viewModel)
    }

}
