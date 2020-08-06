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
struct RecommendationsDefaultModel: RecommendationsModel {

    // MARK: - Properties

    // MARK: RecommendationsModel protocol properties

    let favoriteBookIDs: [String]

    // MARK: Private properties

    private let catalogueService: CatalogueService

    // MARK: - Initialization

    // TODO: HeaderDoc.
    init(favoritesService: FavoritesService, catalogueService: CatalogueService) {
        favoriteBookIDs = favoritesService.favoriteBooks.compactMap { $0.id }
        self.catalogueService = catalogueService
    }

    // MARK: - Methods

    // MARK: RecommendationsModel protocol methods

    func getBook(by id: String, resultCompletion: @escaping (_ book: Book?) -> Void) {
        catalogueService.getBook(by: id, resultCompletion: resultCompletion)
    }

}
