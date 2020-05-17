//
//  MainFactory.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 8.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

// TODO: HeaderDoc.
enum MainFactory {

    // MARK: - Methods

    // TODO: HeaderDoc.
    static func makeMainView() -> some View {
        let model = MainDefaultModel()
        let presenter = MainDefaultPresenter(model: model)

        return MainView<MainDefaultPresenter<MainDefaultModel>>(presenter: presenter)
    }
}
