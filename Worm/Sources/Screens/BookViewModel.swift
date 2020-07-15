//
//  BookViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 15.7.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService

/// A book data for a visual representation.
struct BookViewModel {

    // MARK: - Properties

    /// Formatted authors list.
    let authors: String
    /// Whether the book is in the favorites list.
    let favorite: Bool
    /// The book ID.
    let id: String
    /// The book title.
    let title: String

}

// MARK: - Equatable

extension BookViewModel: Equatable { }

// MARK: - Identifiable

extension BookViewModel: Identifiable { }

// MARK: -

// MARK: -

extension Book {

    // MARK: - Methods

    // TODO: HeaderDoc.
    func asViewModel(favorite: Bool) -> BookViewModel {
        BookViewModel(authors: authors.joined(separator: ", "), favorite: favorite, id: id, title: title)
    }

}
