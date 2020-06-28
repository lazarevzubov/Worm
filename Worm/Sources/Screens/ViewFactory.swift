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
    static func makeMainView(context: NSManagedObjectContext, catalogueService: CatalogueService) -> some View {
        let searchView = makeSearchView(context: context, catalogueService: catalogueService)
        return MainView(searchView: searchView)
    }

    // MARK: Private methods

    private static func makeSearchView(context: NSManagedObjectContext, catalogueService: CatalogueService) -> some View {
        let persistenseService = FavoritesPersistenceService(persistenceContext: context)
        let model = SearchServiceBasedModel(catalogueService: catalogueService, favoritesService: persistenseService)

        let presenter = SearchDefaultPresenter(model: model)

        return SearchView<SearchDefaultPresenter<SearchServiceBasedModel>>(presenter: presenter)
    }

}
