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

// MARK: - CatalogService

extension GoodreadsService: @unchecked @retroactive Sendable, CatalogService { }

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
            similarBookIDs: ["15"]
        ),
        Book(
            id: "2",
            authors: ["Michael Bond"],
            title: "Paddington Pop-Up London",
            description: "A cute pop-up book about London, the capital of The United Kingdom.",
            similarBookIDs: ["14"]
        ),
        Book(
            id: "3",
            authors: ["J.K. Rowling"],
            title: "Harry Potter and the Sorcerer's Stone",
            description: "Another sensitive teenager saves the day thank to his friends.",
            similarBookIDs: ["13"]
        ),
        Book(
            id: "4",
            authors: ["George R.R. Martin"],
            title: "A Game of Thrones",
            description: "Caligula with magic and dragons.",
            similarBookIDs: ["12"]
        ),
        Book(
            id: "5",
            authors: ["Frank Herbert"],
            title: "Dune I",
            description: "A good example of why immigrants can be useful to a country (or a planet).",
            similarBookIDs: ["11"]
        ),
        Book(
            id: "6",
            authors: ["Mikhail Bulgakov"],
            title: "The Master and Margarita",
            description: "An exception that proves that some books from the public school program are actually good.",
            similarBookIDs: ["10"]
        ),
        Book(
            id: "7",
            authors: ["Alan Moore"],
            title: "Watchmen",
            description: "Aging superheroes with psychological issues face the demons of their past.",
            similarBookIDs: ["9"]
        ),
        Book(
            id: "8",
            authors: ["Steve McConnell"],
            title: "Code Complete",
            description: "How to make your code a bit less shitty.",
            similarBookIDs: ["8"]
        ),
        Book(
            id: "9",
            authors: ["Jane Austen"],
            title: "Pride and Prejudice",
            description: "More than just a love story.",
            similarBookIDs: ["7"]
        ),
        Book(
            id: "10",
            authors: ["Martin Fowler"],
            title: "Refactoring: Improving the Design of Existing Code",
            description: "A step-by-step guide how to make your code bearable to work with.",
            similarBookIDs: ["6"]
        ),
        Book(
            id: "11",
            authors: ["Stephen King"],
            title: "The Shining",
            description: "How the family can drive a person crazy, when they are locked up together.",
            similarBookIDs: ["5"]
        ),
        Book(
            id: "12",
            authors: ["Hannah Arendt"],
            title: "Eichmann in Jerusalem: A Report on the Banality of Evil",
            description: "How the Jew made their situation even worse during WWII.",
            similarBookIDs: ["4"]
        ),
        Book(
            id: "13",
            authors: ["Fyodor Dostoyevsky"],
            title: "The Idiot",
            description: "A book about a nice person in the world of idiots (i.e., the real world).",
            similarBookIDs: ["3"]
        ),
        Book(
            id: "14",
            authors: ["Ken Kesey"],
            title: "Sometimes a Great Notion",
            description: "A story that proves you must stay away of your family after you grow up.",
            similarBookIDs: ["2"]
        ),
        Book(
            id: "15",
            authors: ["Haruki Murakami"],
            title: "The Wind-Up Bird Chronicle",
            description: "A half anime-pervert, half meditating phantasy.",
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
