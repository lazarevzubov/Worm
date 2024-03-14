//
//  BlockedBook.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 29.1.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftData

/// A persisted object representing a blocked from recommendations book.
@Model
final class BlockedBook {

    // MARK: - Properties

    /// The book's ID.
    @Attribute(.unique)
    let id: String // TODO: Check if can be let.

    // MARK: - Initialization

    /// Creates a persisted object representing a blocked from recommendations book.
    /// - Parameter id: The book's ID.
    init(id: String) {
        self.id = id
    }

}
