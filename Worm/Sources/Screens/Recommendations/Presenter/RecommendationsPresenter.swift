//
//  RecommendationsPresenter.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 29.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import Foundation
import GoodreadsService

// TODO: HeaderDoc.
protocol RecommendationsPresenter: ObservableObject {

    // MARK: - Properties

    // TODO: HeaderDoc.
    var recommendations: [BookViewModel] { get }

}

// MARK: -

// TODO: HeaderDoc.
final class RecommendationsDefaultPresenter<Manager: RecommendationsManager>: RecommendationsPresenter {

    // MARK: - Properties

    // MARK: RecommendationsPresenter protocol properties

    @Published
    private(set) var recommendations = [BookViewModel]()

    // MARK: Private properties

    private let model: RecommendationsModel
    private let recommendationsManager: Manager
    private let updateQueue: DispatchQueue
    private lazy var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    // TODO: HeaderDoc.
    init(model: RecommendationsModel, recommendationsManager: Manager, updateQueue: DispatchQueue = .main) {
        self.model = model
        self.recommendationsManager = recommendationsManager
        self.updateQueue = updateQueue

        bind(recommendationsManager: recommendationsManager)
        updateFavoriteBooks()
    }

    // MARK: - Methods

    // MARK: Private methods

    private func bind(recommendationsManager: Manager) {
        recommendationsManager
            .objectWillChange
            .receive(on: updateQueue)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
                self?.recommendations = recommendationsManager.recommendations.map { $0.asViewModel(favorite: true) }
        }
        .store(in: &cancellables)
    }

    private func updateFavoriteBooks() {
        // FIXME: Nested closures.
        model.favoriteBookIDs.forEach {
            model.getBook(by: $0) { [weak self] in
                $0?.similarBookIDs.forEach { self?.recommendationsManager.addRecommendation(id: $0) }
            }
        }
    }

}

// MARK: -

// TODO: HeaderDoc.
final class RecommendationsPreviewPresenter: RecommendationsPresenter {

    // MARK: - Properties

    // MARK: RecommendationsPresenter protocol properties

    // TODO.
    var recommendations = [BookViewModel]()

}
