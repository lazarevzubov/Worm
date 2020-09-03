//
//  RecommendationsModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 29.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService

/// The Recommendations screen data providing object.
protocol RecommendationsModel {

    // MARK: - Properties

    /// The list of favorite book IDs.
    var favoriteBookIDs: [String] { get }

    // MARK: - Methods

    /**
     Requests a book by its ID.
     - Parameters:
        - id: The book ID.
        - resultCompletion: The block of code to execute when the result is ready.
        - book: The retrieved book, or `nil`.
     */
    func getBook(by id: String, resultCompletion: @escaping (_ book: Book?) -> Void)
    
}

// MARK: -

/// The Recommendations screen data providing object based on a real service.
struct RecommendationsServiceBasedModel: RecommendationsModel {

    // MARK: - Properties

    // MARK: RecommendationsModel protocol properties

    var favoriteBookIDs: [String] {
        return favoritesService.favoriteBooks.compactMap { $0.id }
    }

    // MARK: Private properties

    private let catalogueService: CatalogueService
    private let favoritesService: FavoritesService

    // MARK: - Initialization

    /**
     Creates a model.
     - Parameters:
        - catalogueService: The main data service of the app.
        - favoritesService: The favorite books list manager.
     */
    init(catalogueService: CatalogueService, favoritesService: FavoritesService) {
        self.catalogueService = catalogueService
        self.favoritesService = favoritesService
    }

    // MARK: - Methods

    // MARK: RecommendationsModel protocol methods

    func getBook(by id: String, resultCompletion: @escaping (_ book: Book?) -> Void) {
        catalogueService.getBook(by: id, resultCompletion: resultCompletion)
    }

}
