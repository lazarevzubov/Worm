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
            ViewFactory.makeMainView(
                catalogService: catalogService,
                favoritesService: favoritesService,
                imageService: imageService,
                onboardingService: onboardingService
            )
        }
    }

    // MARK: Private properties

    private let catalogService: CatalogService = {
#if DEBUG
        if ProcessInfo.processInfo.environment["TEST"] != nil {
            return CatalogPreviewsService()
        }
#endif

        let goodreadsService = GoodreadsService(key: "JQfiS9k0doIho3vm13Qxdg")
        let cacheService = CacheInMemoryService<String, Book>()

        return CatalogGoodreadsService(goodreadsService: goodreadsService, cacheService: cacheService)
    }()
    private var favoritesService: FavoritesService {
        get {
            let modelContainer: ModelContainer = {
#if DEBUG
                let storedInMemory = ProcessInfo.processInfo.environment["TEST"] != nil
#else
                let storedInMemory = false
#endif
                let schema = Schema(
                    [BlockedBook.self,
                     FavoriteBook.self],
                    version: Schema.Version(1, 0, 0)
                )
                let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: storedInMemory)
                do {
                    return try ModelContainer(for: schema, configurations: configuration)
                } catch {
                    // TODO: Proper error handling.
                    fatalError("Could not create ModelContainer: \(error)")
                }
            }()
            return FavoritesPersistenceService(modelContainer: modelContainer)
        }
    }
    private let imageService = ImageWebService(webService: URLSession.shared)
    private let onboardingService = OnboardingPersistentService()

}
