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

/// The main app structure and entry point.
@main
struct WormApp: App {

    // MARK: - Properties

    // MARK: App protocol properties

    var body: some Scene {
        WindowGroup { ViewFactory.makeMainView(catalogueService: catalogueService, favoritesService: favoritesService) }
    }

    // MARK: Private properties

    private var catalogueService: CatalogueService = {
        if ProcessInfo.processInfo.environment["TEST"] != nil {
            return CatalogueMockService()
        }
        return GoodreadsService(key: Settings.goodreadsAPIKey)
    }()
    private var favoritesService = FavoritesPersistenceService(persistenceContext: CoreData.shared.managedObjectContext)

}
