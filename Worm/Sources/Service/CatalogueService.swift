//
//  Service.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 23.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService

/// The data service of the app.
protocol CatalogueService {

    // MARK: - Methods

    /**
     Dispatches a book search query.

     - Parameters:
        - query: The search query.
        - resultCompletion: The block of code to run upon the query completion.
        - ids: The result of the query consisting of book IDs.
     */
    func searchBooks(_ query: String, resultCompletion: @escaping (_ ids: [String]) -> Void)
    /**
     Dispatches a request of a book info.

     - Parameters:
        - id: The ID of the book.
        - resultCompletion: The block of code to run upon the request completion.
        - book: The result of the request.
     */
    func getBook(by id: String, resultCompletion: @escaping (_ book: Book?) -> Void)

}

// MARK: - Service

extension GoodreadsService: CatalogueService { }

// MARK: -

/**
 A mock implementation of the service.

 Useful for testing.
 */
final class MockService: CatalogueService {

    // MARK: - Properties

    // MARK: Private properties

    private static let books = [Book(authors: ["J.R.R. Tolkien"], title: "The Lord of the Rings", id: "1"),
                                Book(authors: ["Michael Bond"], title: "Paddington Pop-Up London", id: "2"),
                                Book(authors: ["J.K. Rowling"],
                                     title: "Harry Potter and the Sorcecer's Stone",
                                     id: "3"),
                                Book(authors: ["George R.R. Martin"], title: "A Game of Thrones", id: "4"),
                                Book(authors: ["Frank Herbert"], title: "Dune I", id: "5"),
                                Book(authors: ["Mikhail Bulgakov"], title: "The Master and Margarita", id: "6"),
                                Book(authors: ["Alan Moore"], title: "Watchmen", id: "7"),
                                Book(authors: ["Steve McConnell"], title: "Code Complete", id: "8"),
                                Book(authors: ["Jane Austen"], title: "Pride and Prejudice", id: "9"),
                                Book(authors: ["Martin Fowler"],
                                     title: "Refactoring: Improving the Design of Existing Code",
                                     id: "10"),
                                Book(authors: ["Stephen King"], title: "The Shining", id: "11"),
                                Book(authors: ["Hannah Arendt"],
                                     title: "Eichmann in Jerusalem: A Report on the Banality of Evil",
                                     id: "12"),
                                Book(authors: ["Fyodor Dostoyevsky"], title: "The Idiot", id: "13"),
                                Book(authors: ["Ken Kesey"], title: "Sometimes a Great Notion", id: "14"),
                                Book(authors: ["Haruki Murakami"], title: "The Wind-Up Bird Chronicle", id: "15")]

    // MARK: - Methods

    // MARK: Service protocol methods

    func searchBooks(_ query: String, resultCompletion: @escaping ([String]) -> Void) {
        let ids = MockService.books.map { $0.id }
        resultCompletion(ids)
    }

    func getBook(by id: String, resultCompletion: @escaping (Book?) -> Void) {
        let book = MockService.books.first { $0.id == id }
        resultCompletion(book)
    }

}
