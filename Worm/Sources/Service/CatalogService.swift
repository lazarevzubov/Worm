//
//  Service.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 23.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService

/// The data service of the app.
protocol CatalogService: Sendable {

    // MARK: - Methods

    /// Dispatches a book search query.
    /// - Parameter query: The search query.
    /// - Returns: The result of the query consisting of book IDs.
    func searchBooks(_ query: String) async -> [String]
    /// Dispatches a request of a book info.
    /// - Parameter id: The ID of the book.
    /// - Returns: The result of the request.
    func getBook(by id: String) async -> Book?

}

// MARK: -

/// The data service of the app, based on the Goodreads service.
///
/// The book-retrieving APIs take advantage from a caching layer to provide repeatedly requested data in more efficient way.
final class CatalogGoodreadsService: CatalogService {

    // MARK: - Properties

    // MARK: Private properties

    private let cacheService: any CacheService<String, Book>
    private let goodreadsService: GoodreadsService

    // MARK: - Initialization

    /// Creates a data service of the app, based on the Goodreads service.
    /// - Parameters:
    ///   - goodreadsService: The entry point to the service.
    ///   - cacheService: Stores results of computations or distributed calls to provide them in a more efficient manner than repeating the initial call again.
    init(goodreadsService: GoodreadsService, cacheService: any CacheService<String, Book>) {
        self.goodreadsService = goodreadsService
        self.cacheService = cacheService
    }

    // MARK: - Methods

    // MARK: CatalogService protocol methods

    func searchBooks(_ query: String) async -> [String] {
        await goodreadsService.searchBooks(query)
    }

    func getBook(by id: String) async -> Book? {
        if let book = await cacheService.storage[id] {
            return book
        }

        let book = await goodreadsService.getBook(by: id)
        if let book {
            await cacheService.insert(book, for: id)
        }

        return book
    }


}

#if DEBUG

// MARK: -

final class CatalogPreviewsService: CatalogService {

    // MARK: - Properties

    // MARK: Private properties

    private static let books = [
        Book(
            id: "1",
            authors: ["J.R.R. Tolkien"],
            title: "The Lord of the Rings",
            description: "A sensitive hobbit unexpectedly saves the situation.",
            rating: nil,
            similarBookIDs: ["15"]
        ),
        Book(
            id: "2",
            authors: ["Michael Bond"],
            title: "Paddington Pop-Up London",
            description: "A cute pop-up book about London, the capital of The United Kingdom.",
            rating: 0.12,
            similarBookIDs: ["14"]
        ),
        Book(
            id: "3",
            authors: ["J.K. Rowling"],
            title: "Harry Potter and the Sorcerer's Stone",
            description: "Another sensitive teenager saves the day thank to his friends.",
            rating: 1.23,
            similarBookIDs: ["13"]
        ),
        Book(
            id: "4",
            authors: ["George R.R. Martin"],
            title: "A Game of Thrones",
            description: "Caligula with magic and dragons.",
            rating: 2.34,
            similarBookIDs: ["12"]
        ),
        Book(
            id: "5",
            authors: ["Frank Herbert"],
            title: "Dune I",
            description: "A good example of why immigrants can be useful to a country (or a planet).",
            rating: 3.45,
            similarBookIDs: ["11"]
        ),
        Book(
            id: "6",
            authors: ["Mikhail Bulgakov"],
            title: "The Master and Margarita",
            description: "An exception that proves that some books from the public school program are actually good.",
            rating: 4.56,
            similarBookIDs: ["10"]
        ),
        Book(
            id: "7",
            authors: ["Alan Moore"],
            title: "Watchmen",
            description: "Aging superheroes with psychological issues face the demons of their past.",
            rating: nil,
            similarBookIDs: ["9"]
        ),
        Book(
            id: "8",
            authors: ["Steve McConnell"],
            title: "Code Complete",
            description: "How to make your code a bit less shitty.",
            rating: 0.12,
            similarBookIDs: ["8"]
        ),
        Book(
            id: "9",
            authors: ["Jane Austen"],
            title: "Pride and Prejudice",
            description: "More than just a love story.",
            rating: 1.23,
            similarBookIDs: ["7"]
        ),
        Book(
            id: "10",
            authors: ["Martin Fowler"],
            title: "Refactoring: Improving the Design of Existing Code",
            description: "A step-by-step guide how to make your code bearable to work with.",
            rating: 2.34,
            similarBookIDs: ["6"]
        ),
        Book(
            id: "11",
            authors: ["Stephen King"],
            title: "The Shining",
            description: "How the family can drive a person crazy, when they are locked up together.",
            rating: 3.45,
            similarBookIDs: ["5"]
        ),
        Book(
            id: "12",
            authors: ["Hannah Arendt"],
            title: "Eichmann in Jerusalem: A Report on the Banality of Evil",
            description: "How the Jew made their situation even worse during WWII.",
            rating: 4.56,
            similarBookIDs: ["4"]
        ),
        Book(
            id: "13",
            authors: ["Fyodor Dostoyevsky"],
            title: "The Idiot",
            description: "A book about a nice person in the world of idiots (i.e., the real world).",
            rating: nil,
            similarBookIDs: ["3"]
        ),
        Book(
            id: "14",
            authors: ["Ken Kesey"],
            title: "Sometimes a Great Notion",
            description: "A story that proves you must stay away of your family after you grow up.",
            rating: 1.23,
            similarBookIDs: ["2"]
        ),
        Book(
            id: "15",
            authors: ["Haruki Murakami"],
            title: "The Wind-Up Bird Chronicle",
            description: "A half anime-pervert, half meditating phantasy.",
            rating: 2.34,
            similarBookIDs: ["1"]
        )
    ]

    // MARK: - Methods

    // MARK: Service protocol methods

    func searchBooks(_ query: String) async -> [String] {
        Self.books.map { $0.id }
    }

    func getBook(by id: String) async -> Book? {
        Self.books.first { $0.id == id }
    }

}

#endif
