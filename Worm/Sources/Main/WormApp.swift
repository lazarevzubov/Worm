//
//  WormApp.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 22.9.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
import SwiftUI

/// The main app structure and entry point.
@main
struct WormApp: App {

    // MARK: - Properties

    // MARK: App protocol properties

    var body: some Scene {
        WindowGroup {
            ViewFactory.makeMainView(catalogService: catalogService,
                                     favoritesService: favoritesService,
                                     imageService: imageService)
        }
    }

    // MARK: Private properties

    private var catalogService: CatalogService = {
        if ProcessInfo.processInfo.environment["TEST"] != nil {
            return CatalogMockService()
        }
        return GoodreadsService(key: "JQfiS9k0doIho3vm13Qxdg")
    }()
    private var favoritesService = FavoritesPersistenceService(persistenceContext: CoreData.shared.managedObjectContext)
    private var imageService = ImageWebService(webService: URLSession.shared)

}
