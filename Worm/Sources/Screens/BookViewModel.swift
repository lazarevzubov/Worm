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
struct BookViewModel: Sendable {

    // MARK: - Properties

    /// Formatted authors list.
    let authors: String
    /// The book's description.
    var description: String
    /// The book ID.
    let id: String
    /// The URL of the book image.
    let imageURL: URL?
    /// Whether the book is in the favorites list.
    let favorite: Bool
    /// The book title.
    let title: String

    // MARK: - Initialization

    /// Creates a book data for a visual representation.
    /// - Parameters:
    ///   - id: The book ID.
    ///   - authors: Formatted authors list.
    ///   - title: The book title.
    ///   - description: The book's description.
    ///   - imageURL: The URL of the book image.
    ///   - favorite: Whether the book is in the favorites list.
    init(id: String, authors: String, title: String, description: String, imageURL: URL?, favorite: Bool) {
        self.id = id
        self.authors = authors
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.favorite = favorite
    }

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
        self.init(id: book.id, 
                  authors: book.authors.joined(separator: ", "),
                  title: book.title,
                  description: book.description,
                  imageURL: book.imageURL,
                  favorite: favorite)
    }

}
