//
//  FavoritesView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 11.1.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The visual representation of the Favorites screen.
struct FavoritesView<ViewModel: FavoritesViewModel>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        GeometryReader { geometry in
            List(viewModel.favorites) { book in
                BookListCell(book: book, viewModel: viewModel) { selectedBook = book }
            }
                .listStyle(.plain)
                .animation(.easeIn, value: viewModel.favorites)
                .sheet(item: $selectedBook) {
                    BookDetailsView(viewModel: viewModel.makeDetailsViewModel(for: $0))
#if os(macOS)
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 1.2)
#endif
                }
                .errorAlert($viewModel.errorDisplayed)
        }
    }

    // MARK: Private properties

    @State
    private var selectedBook: BookViewModel?
    @ObservedObject
    private var viewModel: ViewModel

    // MARK: - Initialization

    /// Creates the view.
    /// - Parameter viewModel: The object responsible for Favorites screen presentation logic.
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

}

// MARK: -

#Preview { FavoritesView(viewModel: FavoritesPreviewsViewModel()) }
