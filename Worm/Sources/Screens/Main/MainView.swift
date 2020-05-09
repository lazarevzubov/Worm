//
//  MainView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 13.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
import SwiftUI

struct MainView<Presenter: MainPresenter>: View {

    // MARK: - Properties

    var body: some View {
        VStack {
            SearchBar(placeholder: NSLocalizedString("SearchBarPlaceholder",
                                                     value: "Search books",
                                                     comment: "Search bar placeholder"),
                      text: $presenter.query)
            List(presenter.model.books) { book in
                VStack(alignment: .leading) {
                    Text(book.authors.joined(separator: ", "))
                        .font(.body)
                        .fontWeight(.light)
                        .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 1.0))
                    Text(book.title)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                }
            }
        }.navigationBarTitle(NSLocalizedString("MainScreenTitle", value: "Search", comment: "Main screen title"))
    }

    // MARK: Private properties

    @EnvironmentObject
    private var presenter: Presenter

}

// MARK: -

struct MainView_Previews: PreviewProvider {

    // MARK: - Properties

    // MARK: PreviewProvider protocol properties

    static var previews: some View {
        MainView<MainPreviewPresenter<MainDefaultModel>>().environmentObject(MainPreviewPresenter<MainDefaultModel>())
    }

}

// MARK: - Identifiable

extension Book: Identifiable { }
