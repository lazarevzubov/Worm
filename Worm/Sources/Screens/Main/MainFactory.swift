//
//  MainFactory.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 8.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData
import SwiftUI

/// A set of creational methods for building the main screen of the app.
enum MainFactory {

    // MARK: - Methods

    /**
     Creates the main screen view.
     - Parameters:
        - context: An object space to manipulate and track changes to the app's Core Data persistent storage.
        - catalogueService: The data service of the app.
     - Returns: The view of the main screen.
     */
    static func makeMainView(context: NSManagedObjectContext, catalogueService: CatalogueService) -> some View {
        let persistenseService = FavoritesPersistenceService(persistenceContext: context)
        let model = MainServiceBasedModel(catalogueService: catalogueService, favoritesService: persistenseService)

        let presenter = MainDefaultPresenter(model: model)

        return MainView<MainDefaultPresenter<MainServiceBasedModel>>(presenter: presenter)
    }

}
