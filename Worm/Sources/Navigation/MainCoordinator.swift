//
//  MainCoordinator.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 19.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Coordinator
import SwiftUI
import UIKit

// TODO: HeaderDoc.

final class MainCoordinator: Coordinator {

    // MARK: - Properties

    // MARK: Private properties

    private weak var window: UIWindow?

    // MARK: - Initialization

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Methods

    // MARK: Coordinator protocol methods

    func start() {
        let model = MainViewDefaultModel()
        let view = MainView(model: model)
        let controller = UIHostingController(rootView: view)

        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }

}