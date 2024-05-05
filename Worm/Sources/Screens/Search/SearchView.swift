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
            ZStack {
                List(viewModel.books) { book in
                    Button {
                        searchActive = false
                        selectedBook = book
                    } label: { BookListCell(book: book, viewModel: viewModel) }
                }
                    .listStyle(.plain)
                if !viewModel.onboardingShown {
                    VStack {
                        Text("Start by searching your favourite books and marking them as favourites.")
                            .foregroundStyle(
                                Color
                                    .black
                            )
                            .padding(8.0)
                            .background(
                                Color(red: (249.0 / 255.0), green: (231.0 / 255.0), blue: (132.0 / 255.0))
                                    .cornerRadius(4.0)
                            )
                            .padding(16.0)
                            .accessibilityIdentifier("OnboardingLabel")
                        Spacer()
                    }
                        .onTapGesture { viewModel.onboardingShown = true }
                }
            }
                .searchable(text: $viewModel.query,
                            isPresented: $searchActive,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: "Search books")
                .sheet(item: $selectedBook) { BookDetailsView(viewModel: viewModel.makeDetailsViewModel(for: $0)) }
                .navigationTitle("Search")
                .toolbarColorScheme(.light, for: .navigationBar)
                .toolbarBackground(Color(red: (172.0 / 255.0), green: (211.0 / 255.0), blue: (214.0 / 255.0)),
                                   for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
            .animation(.default, value: viewModel.onboardingShown)
    }

    // MARK: Private properties

    @State
    private var searchActive = false
    @State
    private var selectedBook: BookViewModel?
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

#Preview { SearchView(viewModel: SearchPreviewViewModel()) }

#endif
