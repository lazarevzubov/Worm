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

    private let mockingService: Bool
    private weak var window: UIWindow?

    // MARK: - Initialization

    // TODO: HeaderDoc.
    init(window: UIWindow, mockingService: Bool = false) {
        self.window = window
        self.mockingService = mockingService
    }

    // MARK: - Methods

    // MARK: Coordinator protocol methods

    func start() {
        let view = MainFactory.makeMainView(mockingService: mockingService)
        let navigationView = NavigationView { view }
        let controller = UIHostingController(rootView: navigationView)

        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }

}
