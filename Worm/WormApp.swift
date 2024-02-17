//
//  WormApp.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 22.9.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
import SwiftData
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

    private let favoritesService = {
        let modelContainer: ModelContainer = {
#if DEBUG
            let isStoredInMemoryOnly = if ProcessInfo.processInfo.environment["TEST"] != nil {
                true
            } else {
                false
            }
#else
            let isStoredInMemoryOnly = false
#endif
            let schema = Schema([BlockedBook.self,
                                 FavoriteBook.self],
                                version: Schema.Version(1, 0, 0))
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isStoredInMemoryOnly)
            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                // TODO: Proper error handling.
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
        return FavoritesPersistenceService(modelContainer: modelContainer)
    }()
    private let imageService = ImageWebService(webService: URLSession.shared)
    private var catalogService: CatalogService = {
#if DEBUG
        if ProcessInfo.processInfo.environment["TEST"] != nil {
            return CatalogMockService()
        }
#endif
        return GoodreadsService(key: "JQfiS9k0doIho3vm13Qxdg")
    }()

}
