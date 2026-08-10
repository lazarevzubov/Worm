//
//  BlockedBooksView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 10.8.2026.
//  Copyright © 2026 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The visual representation of the Blocked screen.
struct BlockedBooksView<ViewModel: BlockedBooksViewModel>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        GeometryReader { geometry in
            List {
                ForEach(viewModel.blockedBooks) { book in
                    Button { selectedBook = book } label: {
                        BlockedBookListCell(book: book)
                            // For making empty space clickable/tappable.
                            .background(Color.white.opacity(0.0001))
                    }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button("Unblock", role: .cancel) { viewModel.unblockBook(book) }
                        }
                        .swipeActions {
                            Button("Unblock", role: .cancel) { viewModel.unblockBook(book) }
                        }
                }
            }
                .listStyle(.plain)
                .animation(.easeIn, value: viewModel.blockedBooks)
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

    /// Creates the view object.
    /// - Parameter viewModel: The object responsible for Blocked screen presentation logic.
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

}

// MARK: -

#Preview { BlockedBooksView(viewModel: BlockedBooksPreviewViewModel()) }
