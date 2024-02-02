//
//  BookDetailsPresentable.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 24.2.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

/// Manages book details presentation.
protocol BookDetailsPresentable {

    /// The corresponding book details view model type.
    associatedtype DetailsViewModel: BookDetailsViewModel

    // MARK: - Methods

    /// Creates a details view model for corresponding to presented books.
    /// - Parameter favorite: The book to present details for.
    func makeDetailsViewModel(for book: BookViewModel) -> DetailsViewModel

}
