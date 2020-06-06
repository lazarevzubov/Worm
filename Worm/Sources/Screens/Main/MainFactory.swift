//
//  MainFactory.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 8.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData
import GoodreadsService
import SwiftUI

/// A set of creational methods for building the main screen of the app.
enum MainFactory {

    // MARK: - Methods

    /**
     Creates the main screen view.

     - Parameters:
        - context: An object space to manipulate and track changes to the app's Core Data persistent storage.
        - mockingService: Indicates whether to build the real or a mock view.

     - Returns: The view of the main screen.
     */
    static func makeMainView(context: NSManagedObjectContext, mockingService: Bool = false) -> some View {
        let catalogueService: CatalogueService = !mockingService
            ? GoodreadsService(key: Settings.goodreadsAPIKey)
            : CatalogueMockService()
        let persistenseService = FavoritesCoreDataService(databaseContext: context)
        let model = MainServiceBasedModel(catalogueService: catalogueService, persistenseService: persistenseService)

        let presenter = MainDefaultPresenter(model: model)

        return MainView<MainDefaultPresenter<MainServiceBasedModel>>(presenter: presenter)
    }
}
