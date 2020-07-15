//
//  SearchView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 13.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI
import UIKit2SwiftUI

/// The book search screen.
struct SearchView<Presenter: SearchPresenter>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $presenter.query, placeholder: "SearchScreenSearchFieldPlaceholder") // TODO: Close on tap.
                List(presenter.books) {
                    SearchViewListCell(book: $0, presenter: self.presenter)
                }
            }
            .navigationBarTitle("SearchScreenTitle")
        }
        .onAppear {
            self.configureNavigationBar()
        }
    }

    // MARK: Private properties

    @ObservedObject
    private var presenter: Presenter

    // MARK: - Initialization

    /**
     Creates the screen.
     - Parameter presenter: The presentation logic handler.
     */
    init(presenter: Presenter) {
        self.presenter = presenter
    }

    // MARK: - Methods

    // MARK: Private methods

    private func configureNavigationBar() {
        UINavigationBar.appearance().backgroundColor = UIColor(red: (172.0 / 255.0),
                                                               green: (211.0 / 255.0),
                                                               blue: (214.0 / 255.0),
                                                               alpha: 1.0)

        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.black]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor.black]
    }

}

// MARK: -

/// Produces the book search screen preview for Xcode.
struct SearchView_Previews: PreviewProvider {

    // MARK: - Properties

    // MARK: PreviewProvider protocol properties

    static var previews: some View { SearchView(presenter: SearchPreviewPresenter()) }

}
