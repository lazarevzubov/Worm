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
        NavigationView {
            List(viewModel.favorites) { book in
                Button { selectedBook = book } label: { BookListCell(book: book, viewModel: viewModel) }
            }
                .listStyle(.plain)
                .animation(.easeIn, value: viewModel.favorites)
                .sheet(item: $selectedBook) { BookDetailsView(viewModel: viewModel.makeDetailsViewModel(for: $0)) }
                .navigationTitle("Favourites")
                .toolbarColorScheme(.light, for: .navigationBar)
                .toolbarBackground(Color.favorites, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
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

#if DEBUG

#Preview { FavoritesView(viewModel: FavoritesPreviewsViewModel()) }

#endif
