//
//  BlockedBookListCell.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 10.8.2026.
//  Copyright © 2026 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The table cell containing a blocked book's info.
struct BlockedBookListCell: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        HStack {
            BookInfoView(book: book)
            Spacer()
        }
    }

    // MARK: Private properties

    private let book: BookViewModel

    // MARK: - Initialization

    /// Creates a cell's displaying representation.
    /// - Parameter book: A book data for a visual representation.
    init(book: BookViewModel) {
        self.book = book
    }

}
