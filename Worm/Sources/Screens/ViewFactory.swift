//
//  ViewFactory.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 8.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData
import SwiftUI

/// A set of creational methods for building views for the app.
enum ViewFactory {

    // MARK: - Methods

    /**
     Creates the main view of the app.
     - Parameters:
        - context: An object space used to manipulate and track changes to CoreData managed objects.
        - catalogueService: The main data service of the app.
        - favoritesService: The favorite books list manager.
     - Returns: The main view of the app.
     */
    static func makeMainView(context: NSManagedObjectContext,
                             catalogueService: CatalogueService,
                             favoritesService: FavoritesService) -> some View {
        let searchView = makeSearchView(context: context,
                                        catalogueService: catalogueService,
                                        favoritesService: favoritesService)
        let recommendationsView = makeRecommendationsView(context: context,
                                                          catalogueService: catalogueService,
                                                          favoritesService: favoritesService)
        
        return MainView(searchView: searchView, recommendationsView: recommendationsView)
    }

    // MARK: Private methods

    private static func makeSearchView(context: NSManagedObjectContext,
                                       catalogueService: CatalogueService,
                                       favoritesService: FavoritesService) -> some View {
        let model = SearchServiceBasedModel(catalogueService: catalogueService, favoritesService: favoritesService)
        let presenter = SearchDefaultPresenter(model: model)

        return SearchView<SearchDefaultPresenter<SearchServiceBasedModel>>(presenter: presenter)
    }

    private static func makeRecommendationsView(context: NSManagedObjectContext,
                                                catalogueService: CatalogueService,
                                                favoritesService: FavoritesService) -> some View {
        let model = RecommendationsServiceBasedModel(catalogueService: catalogueService,
                                                     favoritesService: favoritesService)
        let recommendationsManager = RecommendationsDefaultManager { model.getBook(by: $0, resultCompletion: $1) }
        let presenter = RecommendationsDefaultPresenter(model: model, recommendationsManager: recommendationsManager)

        return RecommendationsView(presenter: presenter)
    }

}
