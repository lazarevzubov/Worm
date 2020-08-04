//
//  RecommendationsManager.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 9.7.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import GoodreadsService

// TODO: HeaderDoc.
protocol RecommendationsManager: ObservableObject {

    // MARK: - Properties

    // TODO: HeaderDoc.
    var recommendations: [Book] { get }

    // MARK: - Methods

    // TODO: HeaderDoc.
    func addRecommendation(id: String)

}

// MARK: -

// TODO: HeaderDoc.
final class RecommendationsDefaultManager: RecommendationsManager {

    // MARK: - Properties

    // MARK: RecommendationsManager protocol properties

    @Published
    var recommendations = [Book]()

    // MARK: Private properties

    private let bookDownloader: (_ id: String, @escaping (_ book: Book?) -> Void) -> Void
    private var prioritizedRecommendations = [String: (priority: Int, book: Book?)]() {
        didSet {
            recommendations = prioritizedRecommendations
                .map { $0.value }
                .sorted { $0.priority > $1.priority }
                .compactMap { $0.book }
        }
    }

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
                guard let self = self,
                    let bookDescriptor = self.prioritizedRecommendations[id],
                    bookDescriptor.book == nil else {
                    return
                }
                self.prioritizedRecommendations[id] = (bookDescriptor.priority + 1, $0)
            }
        }
    }

}
