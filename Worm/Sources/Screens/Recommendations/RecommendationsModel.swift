//
//  RecommendationsModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 29.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService

// TODO: HeaderDoc.
protocol RecommendationsModel {

    // MARK: - Properties

    /// The list of favorite book IDs.
    var favoriteBookIDs: [String] { get }

    // MARK: - Methods

    // TODO: HeaderDoc.
    func getBook(by id: String, resultCompletion: @escaping (_ book: Book?) -> Void)
    
}

// MARK: -

// TODO: HeaderDoc.
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

    // TODO: HeaderDoc.
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
