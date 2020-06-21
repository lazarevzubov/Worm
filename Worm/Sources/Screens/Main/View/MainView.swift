//
//  MainView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 13.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI
import UIKit2SwiftUI

// TODO: Check iPads.

/// The book search screen.
struct MainView<Presenter: MainPresenter>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        VStack {
            SearchBar(text: $presenter.query, placeholder: "SearchScreenSearchFieldPlaceholder") // TODO: Close on tap.
            List(presenter.books) { MainViewListCell(book: $0, presenter: self.presenter) }
        }
        .navigationBarTitle("SearchScreenTitle")
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
        configureNavigationBar()
    }

    // MARK: - Methods

    // MARK: Private methods

    private func configureNavigationBar() {
        // Complement: UIColor(red: (190.0 / 255.0), green: (142.0 / 255.0), blue: (155.0 / 255.0), alpha: 1.0)
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
struct MainView_Previews: PreviewProvider {

    // MARK: - Properties

    // MARK: PreviewProvider protocol properties

    static var previews: some View { MainView(presenter: MainPreviewPresenter()) }

}
