//
//  ViewFactory.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 8.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData
import SwiftUI

// TODO: Update HeaderDoc.
/// A set of creational methods for building the search screen of the app.
enum ViewFactory {

    // MARK: - Methods

    // TODO: HeaderDoc
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
