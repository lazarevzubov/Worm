//
//  SearchMockModel.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 25.4.2024.
//

import Combine
import GoodreadsService
@testable
import Worm

actor SearchMockModel: SearchModel {

    // MARK: - Properties

    private(set) var query = ""

    // MARK: SearchModel protocol properties

    @Published
    private(set) var books = Set<Book>()
    var booksPublisher: Published<Set<Book>>.Publisher { $books }
    @Published
    private(set) var favoriteBookIDs = Set<String>()
    var favoriteBookIDsPublisher: Published<Set<String>>.Publisher { $favoriteBookIDs }

    // MARK: - Initialization

    init(books: Set<Book> = [], favoriteBookIDs: Set<String> = []) async {
        self.books = books
        self.favoriteBookIDs = favoriteBookIDs
    }

    // MARK: - Methods

    // MARK: SearchModel protocol methods

    func searchBooks(by query: String) {
        self.query = query
    }
    
    func toggleFavoriteStateOfBook(withID id: String) {
        if favoriteBookIDs.contains(id) {
            favoriteBookIDs.remove(id)
        } else {
            favoriteBookIDs.insert(id)
        }
    }

}
