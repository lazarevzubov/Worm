//
//  RecommendationsManager.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 9.7.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import GoodreadsService

/// Owns logic of maintaing a list of recommedations.
protocol RecommendationsManager: ObservableObject {

    // MARK: - Properties

    /// A list of recommended books in ready-to-display order.
    var recommendations: [Book] { get }

    // MARK: - Methods

    /**
     Adds a recommendation to the list maintaining the latter's proper order.
     - Parameter id: The ID of book to add.
     */
    func addRecommendation(id: String)

}

// MARK: -

/// The default logic of the recommendations list maintenance.
final class RecommendationsDefaultManager: RecommendationsManager {

    // MARK: - Properties

    // MARK: RecommendationsManager protocol properties

    @Published
    var recommendations = [Book]()

    // MARK: Private properties

    private let catalogueService: CatalogueService
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
    init(catalogueService: CatalogueService) {
        self.catalogueService = catalogueService
    }

    // MARK: - Methods

    // MARK: RecommendationsManager protocol methods

    func addRecommendation(id: String) {
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
                self.prioritizedRecommendations[id] = (bookDescriptor.priority + 1, $0)
            }
        }
    }

}
