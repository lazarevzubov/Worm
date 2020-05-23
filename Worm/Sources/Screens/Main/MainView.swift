//
//  MainView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 13.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
import SwiftUI

// TODO: Check accessibility.

// TODO: HeaderDoc.
struct MainView<Presenter: MainPresenter>: View {

    // TODO: LocalizedStringKeys.

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        VStack {
            SearchBar(placeholder: NSLocalizedString("SearchBarPlaceholder",
                                                     value: "Search books",
                                                     comment: "Search bar placeholder"),
                      text: $presenter.query)
            List(presenter.books) { book in
                VStack(alignment: .leading) {
                    Text(book.authors.joined(separator: ", "))
                        .font(.body)
                        .fontWeight(.light)
                        .foregroundColor(.secondary)
                    Text(book.title)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
            }
        }
        .navigationBarTitle(NSLocalizedString("MainScreenTitle", value: "Search", comment: "Main screen title"))
    }

    // MARK: Private properties

    @ObservedObject
    private var presenter: Presenter

    // MARK: - Initialization

    // TODO: HeaderDoc.
    init(presenter: Presenter) {
        self.presenter = presenter
    }

}

// MARK: -

// TODO: HeaderDoc.
struct MainView_Previews: PreviewProvider {

    // MARK: - Properties

    // MARK: PreviewProvider protocol properties

    static var previews: some View { MainView(presenter: MainPreviewPresenter()) }

}

// MARK: - Identifiable

extension Book: Identifiable { }
