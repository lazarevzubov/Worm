//
//  RecommendationsPresenter.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 29.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService

// TODO: HeaderDoc.
protocol RecommendationsPresenter {

    // MARK: - Properties

    // TODO: HeaderDoc.
    var recommendations: [Book] { get }

}

// MARK: -

// TODO: HeaderDoc.
final class RecommendationsDefaultPresenter: RecommendationsPresenter {

    // MARK: - Properties

    // MARK: RecommendationsPresenter protocol properties

    var recommendations: [Book] { recommendationsManager.recommendations }

    // MARK: Private properties

    private let model: RecommendationsModel
    private let recommendationsManager: RecommendationsManager

    // MARK: - Initialization

    // TODO: HeaderDoc.
    init(model: RecommendationsModel, recommendationsManager: RecommendationsManager) {
        self.model = model
        self.recommendationsManager = recommendationsManager

        updateFavoriteBooks()
    }

    // MARK: - Methods

    // MARK: Private methods

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
struct RecommendationsPreviewPresenter: RecommendationsPresenter {

    // MARK: - Properties

    // MARK: RecommendationsPresenter protocol properties

    // TODO.
    var recommendations = [Book]()

}
