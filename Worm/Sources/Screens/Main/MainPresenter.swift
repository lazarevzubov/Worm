//
//  MainPresenter.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 7.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import GoodreadsService

// TODO: HeaderDoc.

protocol MainPresenter: ObservableObject {

    associatedtype Model: MainModel

    // MARK: - Properties

    var query: String { get set }
    var model: Model { get }

}

// MARK: -

final class MainDefaultPresenter<Model: MainModel>: MainPresenter {

    // MARK: - Properties

    // MARK: MainPresenter protocol properties

    @Published
    var query: String {
        didSet { model.query = query }
    }
    private(set) var model: Model

    // MARK: - Initialization

    init(model: Model) {
        self.model = model
        self.query = model.query
    }

}

// MARK: -

final class MainPreviewPresenter<Model: MainModel>: MainPresenter {

    // MARK: - Properties

    // MARK: MainPresenter protocol properties

    @Published
    var query = ""
    private(set) var model = MainDefaultModel()

}
