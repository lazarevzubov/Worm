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
            List(model.books) { book in
                VStack(alignment: .leading) {
                    Text(book.authors.joined(separator: ", "))
                        .font(.body)
                        .fontWeight(.light)
                        .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 1.0))
                    Text(book.title)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(Color.black)
                }
            }.navigationBarTitle("Search")
        }
    }

    // MARK: Private properties

    private let model: MainViewModel

    // MARK: - Initialization

    init(model: MainViewModel) {
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

// MARK: -

extension Book: Identifiable { }
