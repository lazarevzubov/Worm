//
//  MainFactory.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 8.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
import SwiftUI

/// A set of creational methods for building the main screen of the app.
enum MainFactory {

    // MARK: - Methods

    /**
     Creates the main screen view.
     - Parameter mockingService: Indicates whether to build the real or a mock view.
     - Returns: The view of the main screen.
     */
    static func makeMainView(mockingService: Bool = false) -> some View {
        let service: Service = !mockingService
            ? GoodreadsService(key: Settings.goodreadsAPIKey)
            : MockService()
        let model = MainDefaultModel(service: service)
        let presenter = MainDefaultPresenter(model: model)

        return MainView<MainDefaultPresenter<MainDefaultModel>>(presenter: presenter)
    }
}
