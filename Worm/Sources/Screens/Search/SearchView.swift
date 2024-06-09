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
                if !viewModel.searchOnboardingShown {
                    VStack {
                        OnboardingView(text: "Start by searching your favourite books and marking them as favourites.",
                                       color: .favorites)
                            .accessibilityIdentifier("SearchOnboardingLabel")
                        Spacer()
                    }
                        .onTapGesture { viewModel.searchOnboardingShown = true }
                }
                if viewModel.searchOnboardingShown 
                       && !viewModel.recommendationsOnboardingShown {
                    VStack {
                        Spacer()
                        OnboardingView(text: "Then check your recommendations!", color: .recommendations)
                            .accessibilityIdentifier("RecommendationsOnboardingLabel")
                    }
                        .onTapGesture { viewModel.recommendationsOnboardingShown = true }
                }
            }
                .animation(.default, value: viewModel.searchOnboardingShown)
                .animation(.default, value: viewModel.recommendationsOnboardingShown)
                .searchable(text: $viewModel.query,
                            isPresented: $searchActive,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: "Search books")
                .sheet(item: $selectedBook) { BookDetailsView(viewModel: viewModel.makeDetailsViewModel(for: $0)) }
                .navigationTitle("Search")
                .toolbarColorScheme(.light, for: .navigationBar)
                .toolbarBackground(Color.search, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
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
