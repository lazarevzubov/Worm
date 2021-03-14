//
//  BookViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 15.7.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Foundation
import GoodreadsService

/// A book data for a visual representation.
struct BookViewModel {

    // MARK: - Properties

    /// Formatted authors list.
    let authors: String
    /// The book ID.
    let id: String
    /// The URL of the book image.
    let imageURL: URL?
    /// Whether the book is in the favorites list.
    let isFavorite: Bool
    /// The book title.
    let title: String

}

// MARK: - Hashable

extension BookViewModel: Hashable { }

// MARK: - Identifiable

extension BookViewModel: Identifiable { }

// MARK: -

extension Book {

    // MARK: - Methods

    /**
     Creates a visual representation data object from the model representation of book.
     - Parameter favorite: Whether the book is a favorite.
     - Returns: The book data for a visual representation.
     */
    func asViewModel(favorite: Bool) -> BookViewModel {
        let authors = self.authors.joined(separator: ", ")
        return BookViewModel(authors: authors,
                             id: id,
                             imageURL: imageURL,
                             isFavorite: favorite,
                             title: title)
    }

}
