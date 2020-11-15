//
//  WormApp.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 22.9.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
import SwiftUI

// TODO: Check iPads.

// TODO: HeaderDoc.
@main
struct WormApp: App {

    // MARK: - Properties

    // MARK: App protocol properties

    var body: some Scene {
        WindowGroup {
            ViewFactory.makeMainView(catalogueService: catalogueService, favoritesService: favoritesService)
        }
    }

    // MARK: Private properties

    private var catalogueService: CatalogueService = {
        #if TEST
        return CatalogueMockService()
        #else
        return GoodreadsService(key: Settings.goodreadsAPIKey)
        #endif
    }()
    private var favoritesService = FavoritesPersistenceService(persistenceContext: CoreData.shared.managedObjectContext)

}
