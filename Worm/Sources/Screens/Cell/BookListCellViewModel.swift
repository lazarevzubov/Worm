//
//  BookListCellViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 23.12.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

/// The presentation logic of the table cell representing a book info.
protocol BookListCellViewModel {

    // MARK: - Methods

    /// Toggles a favorite state of the book.
    /// - Parameter bookID: The book ID.
    func toggleFavoriteState(bookID: String)

}
