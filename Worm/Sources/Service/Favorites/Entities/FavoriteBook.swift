//
//  FavoriteBook.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 19.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftData

/// A persisted object representing a favorite book.
@Model
final class FavoriteBook {

    // MARK: - Properties

    /// The book's ID.
    @Attribute(.unique)
    let id: String

    // MARK: - Initialization

    /// Creates a persisted object representing a favorite book.
    /// - Parameter id: The book's ID.
    init(id: String) {
        self.id = id
    }

}
