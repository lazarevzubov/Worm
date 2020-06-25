//
//  SearchFactory.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 8.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData
import SwiftUI

/// A set of creational methods for building the search screen of the app.
enum SearchFactory {

    // MARK: - Methods

    /**
     Creates the search screen view.
     - Parameters:
        - context: An object space to manipulate and track changes to the app's Core Data persistent storage.
        - catalogueService: The data service of the app.
     - Returns: The view of the search screen.
     */
    static func makeSearchView(context: NSManagedObjectContext, catalogueService: CatalogueService) -> some View {
        let persistenseService = FavoritesPersistenceService(persistenceContext: context)
        let model = SearchServiceBasedModel(catalogueService: catalogueService, favoritesService: persistenseService)

        let presenter = SearchDefaultPresenter(model: model)

        return SearchView<SearchDefaultPresenter<SearchServiceBasedModel>>(presenter: presenter)
    }

}
