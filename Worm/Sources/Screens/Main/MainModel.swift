//
//  MainModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 20.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import GoodreadsService

// TODO: HeaderDoc.

final class MainModel: ObservableObject {

    // MARK: - Properties

    // MARK: MainViewModel protocol properties

    @Published
    var query = "" {
        didSet {
            service.searchBooks(query) {
                // TODO: Fetch books.
                print($0)
            }
        }
    }
    private(set) var books = [Book]()

    // MARK: Private properties

    private lazy var service = GoodreadsService(key: goodreadsAPIKey)

}
