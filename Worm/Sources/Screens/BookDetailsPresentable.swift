//
//  BookDetailsPresentable.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 24.2.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

// TODO: HeaderDoc.
protocol BookDetailsPresentable {

    /// The corresponding book details presenter type.
    associatedtype DetailsPresenter: BookDetailsPresenter

    // MARK: - Methods

    /**
     Creates a details presenter for corresponding to presented books.
     - Parameter favorite: The book to present details for.
     */
    func makeDetailsPresenter(for book: BookViewModel) -> DetailsPresenter

}
