//
//  RecommendationsModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 9.7.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import GoodreadsService

// TODO: Update HeaderDoc.

/// Owns logic of maintaing a list of recommedations.
protocol RecommendationsModel: ObservableObject {

    // MARK: - Properties

    /// A list of recommended books in ready-to-display order.
    var recommendations: [Book] { get }

    // MARK: - Methods

    // TODO: HeaderDoc.
    func fetchRecommendations()

}

// MARK: -

/// The default logic of the recommendations list maintenance.
final class RecommendationsDefaultModel: RecommendationsModel {

    // MARK: - Properties

    // MARK: RecommendationsManager protocol properties

    // TODO: Unit test initially empty.
    @Published
    var recommendations = [Book]()

    // MARK: Private properties

    private let catalogueService: CatalogueService
    private let favoritesService: FavoritesService
    private var prioritizedRecommendations = [String: (priority: Int, book: Book?)]() {
        didSet {
            recommendations = prioritizedRecommendations
                .map { $0.value }
                .sorted { $0.priority > $1.priority }
                .compactMap { $0.book }
        }
    }

    // MARK: - Initialization

    // TODO: Update HeaderDoc.
    /**
     Creates a recommended books list handler.
     - Parameters:
        - bookDownloader: The block of code for a book retrieval.
        - id: The ID of book to retrieve.
        - book: The retrieved book, or `nil` if not exists or failed to retrieve.
     */
    init(catalogueService: CatalogueService, favoritesService: FavoritesService) {
        self.catalogueService = catalogueService
        self.favoritesService = favoritesService
    }

    // MARK: - Methods

    // MARK: RecommendationsModel protocol methods

    // TODO: Unit test.
    func fetchRecommendations() {
        favoriteBookIDs().forEach { addSimilarBooksToRecommendations(from: $0) }
    }

    // MARK: Private methods

    private func favoriteBookIDs() -> [String] {
        return favoritesService.favoriteBooks.compactMap { $0.id }
    }

    private func addSimilarBooksToRecommendations(from bookID: String) {
        catalogueService.getBook(by: bookID) { [weak self] in
            self?.addSimilarBooksToRecommendations(from: $0?.similarBookIDs ?? [])
        }
    }

    private func addSimilarBooksToRecommendations(from ids: [String]) {
        ids.forEach { self.addRecommendation(id: $0) }
    }

    private func addRecommendation(id: String) {
        if let bookDescriptor = prioritizedRecommendations[id] {
            prioritizedRecommendations[id] = (bookDescriptor.priority + 1, bookDescriptor.book)
        } else {
            prioritizedRecommendations[id] = (1, nil)
            catalogueService.getBook(by: id) { [weak self] in
                guard let self = self,
                    let bookDescriptor = self.prioritizedRecommendations[id],
                    bookDescriptor.book == nil else {
                        return
                }
                self.prioritizedRecommendations[id] = (bookDescriptor.priority, $0)
            }
        }
    }

}
