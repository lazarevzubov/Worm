//
//  MainFactory.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 8.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
import SwiftUI

// TODO: HeaderDoc.
enum MainFactory {

    // MARK: - Methods

    // TODO: HeaderDoc.
    static func makeMainView(mockingService: Bool) -> some View {
        let service: Service = !mockingService ? GoodreadsService(key: ServiceSettings.goodreadsAPIKey) : MockService()
        let model = MainDefaultModel(service: service)
        let presenter = MainDefaultPresenter(model: model)

        return MainView<MainDefaultPresenter<MainDefaultModel>>(presenter: presenter)
    }
}
