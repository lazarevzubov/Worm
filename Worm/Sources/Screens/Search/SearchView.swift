//
//  SearchView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 13.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The book search screen.
struct SearchView<ViewModel: SearchViewModel>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        NavigationView {
            List(viewModel.books) { book in
                Button {
                    searchActive = false
                    detailsPresented = true
                } label: { BookListCell(book: book, viewModel: viewModel) }
                    .sheet(isPresented: $detailsPresented) {
                        BookDetailsView(viewModel: viewModel.makeDetailsViewModel(for: book),
                                        presented: $detailsPresented)
                    }
            }
                .listStyle(.plain)
                .searchable(text: $viewModel.query,
                            isPresented: $searchActive,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: "SearchScreenSearchFieldPlaceholder")
                .navigationTitle("SearchScreenTitle")
                .toolbarColorScheme(.light, for: .navigationBar)
                .toolbarBackground(Color(red: (172.0 / 255.0), green: (211.0 / 255.0), blue: (214.0 / 255.0)),
                                   for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
    }

    // MARK: Private properties

    @State
    private var detailsPresented = false
    @State
    private var searchActive = false
    @ObservedObject
    private var viewModel: ViewModel

    // MARK: - Initialization

    /// Creates the screen.
    /// - Parameter viewModel: The presentation logic handler.
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

}

#if DEBUG

// MARK: -

#Preview {
    SearchView(viewModel: SearchPreviewViewModel())
}

#endif
