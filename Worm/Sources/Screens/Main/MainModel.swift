//
//  MainModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 20.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Foundation
import GoodreadsService

// TODO: HeaderDoc.
protocol MainModel: ObservableObject {

    // MARK: - Properties

    // TODO: HeaderDoc.
    var books: [Book] { get }

    // MARK: - Methods

    // TODO: HeaderDoc.
    func searchBooks(by query: String)

}

// MARK: -

// TODO: HeaderDoc.
final class MainDefaultModel: MainModel {

    // MARK: - Properties

    // MARK: MainModel protocol properties

    @Published
    private(set) var books = [Book]()

    // MARK: Private properties

    private let dispatchQueue: DispatchQueue
    private let service: Service
    private var currentSearchResult = [String]() {
        didSet { currentSearchResult.forEach { handleSearchResult($0) } }
    }
    private var currentSearchWorkItem: DispatchWorkItem?

    // MARK: - Initialization

    // TODO: HeaderDoc.
    init(service: Service = GoodreadsService(key: ServiceSettings.goodreadsAPIKey),
         dispatchQueue: DispatchQueue = DispatchQueue(label: "com.LazarevZubov.Worm.MainDefaultModel")) {
        self.service = service
        self.dispatchQueue = dispatchQueue
    }

    // MARK: - Methods

    // MARK: MainModel protocol methods

    func searchBooks(by query: String) {
        currentSearchWorkItem?.cancel()

        let newSearchWorkItem = makeSearchWorkItem(query: query)
        currentSearchWorkItem = newSearchWorkItem

        dispatchQueue.asyncAfter(deadline: .now() + .milliseconds(500), execute: newSearchWorkItem)
    }

    // MARK: Private methods

    private func makeSearchWorkItem(query: String) -> DispatchWorkItem {
        return DispatchWorkItem { [weak self] in
            self?.reset()
            if !query.isEmpty {
                self?.handle(searchQuery: query)
            }
        }
    }

    private func reset() {
        books.removeAll()
        currentSearchResult.removeAll()
    }

    private func handle(searchQuery: String) {
        service.searchBooks(searchQuery) { [weak self] in
            self?.currentSearchResult = $0
        }
    }

    private func handleSearchResult(_ result: String) {
        service.getBook(by: result) { [weak self] book in
            guard let book = book else {
                return
            }
            self?.appendIfNeeded(book: book)
        }
    }

    private func appendIfNeeded(book: Book) {
        if currentSearchResult.contains(book.id) {
            books.append(book)
        }
    }

}
