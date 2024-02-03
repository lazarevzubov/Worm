//
//  BookDetailsView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 16.2.2021.
//

import SwiftUI

/// The view with detailed information on a book.
struct BookDetailsView<ViewModel: BookDetailsViewModel>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        HStack {
            Spacer()
            Button("CloseModalViewButtonTitle") { presented.toggle() }
                .padding()
        }
        Spacer()
        if let image = viewModel.image {
            Image(uiImage: image)
            Spacer()
        }
        Text(viewModel.title)
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        Text(viewModel.authors)
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .padding([.top, .horizontal])
        Spacer()
    }

    // MARK: Private properties

    @Binding
    private var presented: Bool
    @ObservedObject
    private var viewModel: ViewModel

    // MARK: - Initialization

    // TODO: Update HeaderDoc.
    /// Creates the view.
    /// - Parameter viewModel: The presentation data provider.
    init(viewModel: ViewModel, presented: Binding<Bool>) {
        self.viewModel = viewModel
        _presented = presented
    }

}

#if DEBUG

// MARK: -

struct BookDetailsView_Previews: PreviewProvider {

    // MARK: - Properties

    // MARK: PreviewProvider protocol properties

    static var previews: some View {
        BookDetailsView(viewModel: BookDetailsPreviewViewModel(), presented: .constant(true))
    }

}

#endif
