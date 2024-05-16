//
//  WormApp.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 22.9.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
import OSLog
import SwiftData
import SwiftUI

/// The main app structure and entry point.
@main
struct WormApp: App {

    // MARK: - Properties

    /// Manages shared legacy behaviors of the app.
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate

    // MARK: App protocol properties

    var body: some Scene {
        WindowGroup {
            ViewFactory.makeMainView(catalogService: catalogService,
                                     favoritesService: favoritesService,
                                     imageService: imageService, 
                                     onboardingService: onboardingService,
                                     logger: logger)
        }
    }

    // MARK: Private properties

    private let catalogService: CatalogService = {
#if DEBUG
        if ProcessInfo.processInfo.environment["TEST"] != nil {
            return CatalogPreviewsService()
        }
#endif
        return GoodreadsService(key: "JQfiS9k0doIho3vm13Qxdg")
    }()
    private let favoritesService = {
        let modelContainer: ModelContainer = {
#if DEBUG
            let storedInMemory = if ProcessInfo.processInfo.environment["TEST"] != nil {
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
            let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: storedInMemory)
            do {
                return try ModelContainer(for: schema, configurations: configuration)
            } catch {
                // TODO: Proper error handling.
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
        return FavoritesPersistenceService(modelContainer: modelContainer)
    }()
    private let imageService = ImageWebService(webService: URLSession.shared)
    private let logger = Logger()
    private let onboardingService = OnboardingPersistentService()

}
