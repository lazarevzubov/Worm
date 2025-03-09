//
//  RecommendationsView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 28.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The visual representation of the Recommendations screen.
struct RecommendationsView<ViewModel: RecommendationsViewModel>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                List {
                    ForEach(viewModel.recommendations) { book in
                        Button { selectedBook = book } label: {
                            BookListCell(book: book, viewModel: viewModel)
                                .background(Color.white.opacity(0.0001)) // For making empty space clickable/tappable.
                        }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button("Delete") {
                                    viewModel
                                        .recommendations
                                        .filter { $0.id == book.id }
                                        .forEach { viewModel.blockRecommendation($0) }
                                }
                            }
                    }
                        .onDelete { indexSet in
                            indexSet.forEach { viewModel.blockRecommendation(viewModel.recommendations[$0]) }
                        }
                }
                    .animation(.easeIn, value: viewModel.recommendations)
                    .listStyle(.plain)
                if !viewModel.onboardingShown {
                    VStack {
                        OnboardingView(
                            text: "Recommendations are shown in the order of their relevance and update as you turn some of them down or mark more books as favourites.",
                            color: .search
                        )
                            .accessibilityIdentifier("OnboardingLabel")
                        Spacer()
                    }
                        .onTapGesture { viewModel.onboardingShown = true }
                }
            }
                .animation(.default, value: viewModel.onboardingShown)
                .sheet(item: $selectedBook) {
                    BookDetailsView(viewModel: viewModel.makeDetailsViewModel(for: $0))
#if os(macOS)
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 1.2)
#endif
                }
        }
    }

    // MARK: Private properties

    @State
    private var selectedBook: BookViewModel?
    @ObservedObject
    private var viewModel: ViewModel

    // MARK: - Initialization

    /// Creates the view object.
    /// - Parameter viewModel: The object responsible for Recommendations screen presentation logic.
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

}

// MARK: -

#if DEBUG

#Preview { RecommendationsView(viewModel: RecommendationsPreviewViewModel()) }

#endif
