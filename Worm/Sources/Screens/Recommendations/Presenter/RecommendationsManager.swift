//
//  RecommendationsManager.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 9.7.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

// TODO: HeaderDoc.
protocol RecommendationsManager {

    // MARK: - Properties

    // TODO: HeaderDoc.
    var recommendations: [Book] { get }

    // MARK: - Methods

    // TODO: Syncronize with list instead of adding one by one.
    // TODO: HeaderDoc.
    func addRecommendation(id: String)

}

import GoodreadsService

// TODO: HeaderDoc.
final class RecommendationsDefaultManager: RecommendationsManager {

    // MARK: - Properties

    // MARK: RecommendationsManager protocol properties

    var recommendations: [Book] {
        return prioritizedRecommendations.map { $0.value }.sorted { $0.priority > $1.priority }.compactMap { $0.book }
    }

    // MARK: Private properties

    private let bookDownloader: (_ id: String, @escaping (_ book: Book?) -> Void) -> Void
    private var prioritizedRecommendations = [String: (priority: Int, book: Book?)]() // TODO: Sync.

    // MARK: - Initialization

    init(bookDownloader: @escaping (_ id: String, @escaping (_ book: Book?) -> Void) -> Void) {
        self.bookDownloader = bookDownloader
    }

    // MARK: - Methods

    // MARK: RecommendationsManager protocol methods

    func addRecommendation(id: String) {
        if let bookDescriptor = prioritizedRecommendations[id] {
            prioritizedRecommendations[id] = (bookDescriptor.priority + 1, bookDescriptor.book)
        } else {
            prioritizedRecommendations[id] = (1, nil)
            bookDownloader(id) { [weak self] in
                guard let self = self else {
                    return
                }
                if let bookDescriptor = self.prioritizedRecommendations[id],
                    bookDescriptor.book == nil {
                    self.prioritizedRecommendations[id] = (bookDescriptor.priority + 1, $0)
                }
            }
        }
    }

}
