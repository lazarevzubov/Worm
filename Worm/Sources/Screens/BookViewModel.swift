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
    let favorite: Bool
    /// The book title.
    let title: String

}

// MARK: - Hashable

extension BookViewModel: Hashable { }

// MARK: - Identifiable

extension BookViewModel: Identifiable { }

// MARK: -

extension BookViewModel {

    // MARK: - Initialization

    /// Creates a visual representation data object from the model representation of book.
    /// - Parameters:
    ///   - book: A book meta-data object.
    ///   - favorite: Whether the book is a favorite.
    init(book: Book, favorite: Bool) {
        self.init(authors: book.authors.joined(separator: ", "),
                  id: book.id,
                  imageURL: book.imageURL,
                  favorite: favorite,
                  title: book.title)
    }

}
