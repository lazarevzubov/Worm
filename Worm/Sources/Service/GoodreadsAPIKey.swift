//
//  GoodreadsAPIKey.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 23.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService

// TODO: HeaderDoc.

enum ServiceSettings {

    // MARK: - Properties

    static let goodreadsAPIKey = "JQfiS9k0doIho3vm13Qxdg"

}

// MARK: -

protocol Service {

    // MARK: - Methods

    func searchBooks(_ query: String, resultCompletion: @escaping (_ ids: [String]) -> Void)
    func getBook(by id: String, resultCompletion: @escaping (_ book: Book?) -> Void)

}

// MARK: - Service

extension GoodreadsService: Service { }
