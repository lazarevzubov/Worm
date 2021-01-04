//
//  RecommendationsModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 9.7.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import GoodreadsService

/// Owns logic of maintaing a list of recommedations.
protocol RecommendationsModel: ObservableObject {

    // FIXME: Duplication with SearchModel?

    // MARK: - Properties

    /// The list of favorite book IDs.
    var favoriteBookIDs: [String] { get }
    /// A list of recommended books in ready-to-display order.
    var recommendations: [Book] { get }

    // MARK: - Methods

    /**
     Toggles the favorite-ness state of a book.
     - Parameter bookID: The ID of the book to manipulate.
     */
    func toggleFavoriteState(bookID: String)

}

// MARK: -

/// The default logic of the recommendations list maintenance.
final class RecommendationsDefaultModel<RecommendationsService: FavoritesService>: RecommendationsModel {

    // MARK: - Properties

    // MARK: RecommendationsManager protocol properties

    @Published
    private(set) var favoriteBookIDs = [String]()
    @Published
    var recommendations = [Book]()

    // MARK: Private properties

    private let catalogueService: CatalogueService
    private let favoritesService: RecommendationsService
    private lazy var cancellables = Set<AnyCancellable>()
    private var prioritizedRecommendations = [String: (priority: Int, book: Book?)]() {
        didSet {
            recommendations = prioritizedRecommendations
                .map { $0.value }
                .sorted { $0.priority > $1.priority }
                .compactMap { $0.book }
        }
    }

    // MARK: - Initialization

    /**
     Creates a recommended books list handler.
     - Parameters:
        - catalogueService: The data service of the app.
        - favoritesService: The favorite books list manager.
     */
    init(catalogueService: CatalogueService, favoritesService: RecommendationsService) {
        self.catalogueService = catalogueService
        self.favoritesService = favoritesService

        bind(favoritesService: self.favoritesService)
        updateFavorites()
    }

    // MARK: - Methods

    // MARK: RecommendationsModel protocol methods

    func toggleFavoriteState(bookID: String) {
        if favoriteBookIDs.contains(bookID) {
            favoritesService.removeFromFavoriteBooks(bookID)
        } else {
            favoritesService.addToFavoriteBooks(bookID)
        }
        updateFavorites()
    }

    // MARK: Private methods

    private func bind(favoritesService: RecommendationsService) {
        favoritesService
            .objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
                self?.updateFavorites()
        }
        .store(in: &cancellables)
    }

    private func updateFavorites() {
        favoriteBookIDs = favoritesService.favoriteBooks.compactMap { $0.id }
        favoriteBookIDs.forEach { addSimilarBooksToRecommendations(from: $0) }
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
