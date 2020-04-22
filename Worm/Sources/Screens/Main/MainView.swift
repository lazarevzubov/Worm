//
//  MainView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 13.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
import SwiftUI

struct MainView: View {

    // MARK: - Properties

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(placeholder: NSLocalizedString("SearchBarPlaceholder",
                                                         value: "Search books",
                                                         comment: "Search bar placeholder"),
                          text: $searchText)
                List { // TODO: Factor out.
                    ForEach(model.books.filter {
                        searchText.isEmpty
                            ? true
                            : $0.title.lowercased().contains(searchText.lowercased())
                        },
                            id: \.self) { book in
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
                }
            }.navigationBarTitle(NSLocalizedString("MainScreenTitle", value: "Search", comment: "Main screen title"))
        }
    }

    // MARK: Private properties

    private let model: MainModel
    @State
    private var searchText = ""

    // MARK: - Initialization

    init(model: MainModel) {
        self.model = model
    }

}

// MARK: -

struct MainView_Previews: PreviewProvider {

    // MARK: - Properties

    static var previews: some View {
        MainView(model: MainViewPreviewModel())
    }

}

// MARK: - Identifiable

extension Book: Identifiable { }
