//
//  ViewFactory.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 8.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// A set of creational methods for building views for the app.
@MainActor
enum ViewFactory {

    // MARK: - Methods

    /// Creates the main view of the app.
    /// - Parameters:
    ///   - catalogService: The main data service of the app.
    ///   - favoritesService: The favorite books list manager.
    ///   - favoritesService: Provides with information related to the user onboarding.
    /// - Returns: The main view of the app.
    static func makeMainView(catalogService: CatalogService,
                             favoritesService: some FavoritesService,
                             imageService: ImageService,
                             onboardingService: OnboardingService) -> some View {
        let viewModel = makeMainViewModel(catalogService: catalogService,
                                          favoritesService: favoritesService,
                                          imageService: imageService,
                                          onboardingService: onboardingService)
        let searchView = makeSearchView(viewModel: viewModel)

        let recommendationsView = makeRecommendationsView(catalogService: catalogService,
                                                          favoritesService: favoritesService,
                                                          imageService: imageService,
                                                          onboardingService: onboardingService)
        
        let favoritesView = makeFavoritesView(catalogService: catalogService,
                                              favoritesService: favoritesService,
                                              imageService: imageService)

        return MainScreen(searchView: searchView, 
                          recommendationsView: recommendationsView,
                          favoritesView: favoritesView,
                          viewModel: viewModel)
    }

    // MARK: Private methods

    private static func makeMainViewModel(
        catalogService: CatalogService,
        favoritesService: FavoritesService,
        imageService: ImageService,
        onboardingService: OnboardingService
    ) -> some MainScreenViewModel & SearchViewModel {
        let model = SearchServiceBasedModel(catalogService: catalogService, favoritesService: favoritesService)
        return SearchDefaultViewModel(model: model, onboardingService: onboardingService, imageService: imageService)
    }

    private static func makeSearchView(viewModel: some SearchViewModel) -> some View {
        SearchView(viewModel: viewModel)
    }

    private static func makeRecommendationsView(catalogService: CatalogService,
                                                favoritesService: some FavoritesService,
                                                imageService: ImageService,
                                                onboardingService: OnboardingService) -> some View {
        let recommendationsModel = RecommendationsDefaultModel(catalogService: catalogService,
                                                               favoritesService: favoritesService)
        let viewModel = RecommendationsDefaultViewModel(model: recommendationsModel,
                                                        onboardingService: onboardingService,
                                                        imageService: imageService)

        return RecommendationsView(viewModel: viewModel)
    }

    private static func makeFavoritesView(catalogService: CatalogService,
                                          favoritesService: some FavoritesService,
                                          imageService: ImageService) -> some View {
        let model = FavoritesServiceBasedModel(catalogService: catalogService, favoritesService: favoritesService)
        let viewModel = FavoritesDefaultViewModel(model: model, imageService: imageService)

        return FavoritesView(viewModel: viewModel)
    }

}
