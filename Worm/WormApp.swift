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
                blockedBooksService: blockedBooksService,
                imageService: imageService,
                onboardingService: onboardingService
            )
        }
    }

    // MARK: Private properties

    private let blockedBooksService: BlockedBooksService
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
    private let favoritesService: FavoritesService
    private let imageService = ImageWebService(webService: URLSession.shared)
    private let onboardingService = OnboardingPersistentService()

    // MARK: - Initialization

    init() {
#if DEBUG
        let storedInMemory = ProcessInfo.processInfo.environment["TEST"] != nil
#else
        let storedInMemory = false
#endif
        let schema = Schema(
            [
                BlockedBook.self,
                FavoriteBook.self
            ],
            version: Schema.Version(1, 0, 0)
        )
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: storedInMemory)

        let modelContainer: ModelContainer
        do {
            modelContainer = try ModelContainerFactory.make(for: schema, configuration: configuration)
        } catch {
            fatalError("Could not create ModelContainer, even after resetting the store: \(error)")
        }

        blockedBooksService = BlockedBooksPersistenceService(modelContainer: modelContainer)
        favoritesService = FavoritesPersistenceService(modelContainer: modelContainer)
    }

}
