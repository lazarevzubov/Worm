//
//  MainViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 20.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService

// TODO: HeaderDoc.

protocol MainViewModel {

    // MARK: - Properties

    var books: [Book] { get }

}

// MARK: -

struct MainViewDefaultModel: MainViewModel {

    // MARK: - Properties

    // MARK: MainViewModel protocol properties

    private(set) var books = [Book]()

}

// MARK: -

struct MainViewPreviewModel: MainViewModel {

    // MARK: - Properties

    // MARK: MainViewModel protocol properties

    var books: [Book] {
        let book1 = Book(authors: ["J.R.R. Tolkien"], title: "The Lord of the Rings", id: "1")
        let book2 = Book(authors: ["Michale Bond"], title: "Paddington Pop-Up London", id: "2")
        let book3 = Book(authors: ["J.K. Rowling"], title: "Harry Potter and the Sorcecer's Stone", id: "3")
        let book4 = Book(authors: ["George R.R. Martin"], title: "A Game of Thrones", id: "4")
        let book5 = Book(authors: ["Frank Herbert"], title: "Dune I", id: "5")
        let book6 = Book(authors: ["Mikhail Bulgakov"], title: "The Master and Margarita", id: "6")
        let book7 = Book(authors: ["Alan Moore"], title: "Watchmen", id: "1")

        return [book1,
                book2,
                book3,
                book4,
                book5,
                book6,
                book7]
    }

}
