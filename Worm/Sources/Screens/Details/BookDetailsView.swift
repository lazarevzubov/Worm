//
//  BookDetailsView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 16.2.2021.
//

import SwiftUI

/// The view with detailed information on a book.
struct BookDetailsView<Presenter: BookDetailsPresenter>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        HStack {
            Spacer()
            Button("CloseModalViewButtonTitle") { presented.toggle() }
                .padding()
        }
        Spacer()
        if let image = presenter.image {
            Image(uiImage: image)
            Spacer()
        }
        Text(presenter.title)
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        Text(presenter.authors)
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .padding([.top, .leading, .trailing])
        Spacer()
    }

    // MARK: Private properties

    @Binding
    private var presented: Bool
    @ObservedObject
    private var presenter: Presenter

    // MARK: - Initialization

    // TODO: Update HeaderDoc.
    /**
     Creates the view.
     - Parameter presenter: The presentation data provider.
     */
    init(presenter: Presenter, presented: Binding<Bool>) {
        self.presenter = presenter
        self._presented = presented
    }

}

// MARK: -

/// Produces the book details view preview for Xcode.
struct BookDetailsView_Previews: PreviewProvider {

    // MARK: - Properties

    // MARK: PreviewProvider protocol properties

    static var previews: some View { BookDetailsView(presenter: BookDetailsPreviewPresenter(),
                                                     presented: .constant(true)) }

}
