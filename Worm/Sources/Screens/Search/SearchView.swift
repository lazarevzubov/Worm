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
        GeometryReader { geometry in
            ZStack {
                List(viewModel.books) { book in
                    BookListCell(book: book, viewModel: viewModel) { selectedBook = book }
                }
                    .listStyle(.plain)
                if !viewModel.searchOnboardingShown {
                    VStack {
                        Button { viewModel.searchOnboardingShown = true } label: {
                            OnboardingView(
                                text: "Start by searching your favorite books and marking them as favorites.",
                                localizationComment: "A tooltip that appears on the first launch of the app, explaining how to use search",
                                color: .favorites
                            )
                        }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("SearchOnboardingLabel")
                        Spacer()
                    }
                }
                if viewModel.searchOnboardingShown
                        && !viewModel.recommendationsOnboardingShown {
                    VStack {
                        Spacer()
                        Button { viewModel.recommendationsOnboardingShown = true } label: {
                            OnboardingView(
                                text: "Then check your recommendations!",
                                localizationComment: "A tooltip that appears on the first launch of the app, explaining how to check recommendations",
                                color: .recommendations
                            )
                        }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("RecommendationsOnboardingLabel")
                    }
                }
            }
                .animation(.default, value: viewModel.searchOnboardingShown)
                .animation(.default, value: viewModel.recommendationsOnboardingShown)
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

    /// Creates the screen.
    /// - Parameter viewModel: The presentation logic handler.
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

}

// MARK: -

#Preview { SearchView(viewModel: SearchPreviewViewModel()) }
