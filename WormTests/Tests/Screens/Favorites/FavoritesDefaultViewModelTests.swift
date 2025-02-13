//
//  FavoritesDefaultViewModelTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 4.4.2024.
//

import Combine
import Foundation
import GoodreadsService
import Testing
@testable
import Worm

struct FavoritesDefaultViewModelTests {

    // MARK: - Methods

    @MainActor
    @Test
    func favorites_empty_initially() {
        let vm: any FavoritesViewModel = FavoritesDefaultViewModel(
            model: FavoritesMockModel(), imageService: ImageMockService()
        )
        #expect(vm.favorites.isEmpty, "Favorites are not empty initially.")
    }

    @MainActor
    @Test
    func detailsViewModel_authors_asExpected() {
        let vm: any FavoritesViewModel = FavoritesDefaultViewModel(
            model: FavoritesMockModel(), imageService: ImageMockService()
        )

        let bookVM = BookViewModel(
            book: Book(id: "ID",
                       authors: [
                        "Author1",
                        "Author2"
                       ],
                       title: "Title",
                       description: "Desc"),
            favorite: false
        )
        let bookDetailsVM = vm.makeDetailsViewModel(for: bookVM)

        #expect(bookDetailsVM.authors == bookVM.authors, "Unexpected authors string generated")
    }

    @MainActor
    @Test
    func testDetailsViewModel_title() {
        let vm: any FavoritesViewModel = FavoritesDefaultViewModel(
            model: FavoritesMockModel(), imageService: ImageMockService()
        )

        let bookVM = BookViewModel(
            book: Book(id: "ID",
                       authors: [
                        "Author1",
                        "Author2"
                       ],
                       title: "Title",
                       description: "Desc"),
            favorite: false
        )
        let bookDetailsVM = vm.makeDetailsViewModel(for: bookVM)

        #expect(bookDetailsVM.title == bookVM.title, "Unexpected authors string generated")
    }

    @MainActor
    @Test(.timeLimit(.minutes(1)))
    func favorites_update() async {
        let id = "1"
        let book = Book(id: id, authors: [], title: "", description: "Desc")

        let vm: any FavoritesViewModel = FavoritesDefaultViewModel(
            model: FavoritesMockModel(favorites: [book]), imageService: ImageMockService()
        )
        while vm.favorites != [BookViewModel(book: book, favorite: true)] {
            await Task.yield()
        }
    }

    @MainActor
    @Test(.timeLimit(.minutes(1)))
    func favorites_update_onRemovingFavorite() async {
        let id = "1"
        let book = Book(id: id, authors: [], title: "", description: "Desc")

        let vm: any FavoritesViewModel = FavoritesDefaultViewModel(
            model: FavoritesMockModel(favorites: [book]), imageService: ImageMockService()
        )

        vm.toggleFavoriteStateOfBook(withID: id)
        while !vm.favorites.isEmpty {
            await Task.yield()
        }
    }

    @MainActor
    @Test(.timeLimit(.minutes(1)))
    func detailsViewModel_image() async {
        let imageURL = URL(string: "https://apple.com")!
        let image = UniversalImage()

        let vm: any FavoritesViewModel = FavoritesDefaultViewModel(
            model: FavoritesMockModel(), imageService: ImageMockService(images: [imageURL : image])
        )
        let bookVM = BookViewModel(
            book: Book(id: "ID",
                       authors: [
                        "Author1",
                        "Author2"
                       ],
                       title: "Title",
                       description: "Desc",
                       imageURL: URL(string: "https://apple.com")),
            favorite: false
        )

        let bookDetailsVM = vm.makeDetailsViewModel(for: bookVM)
        while bookDetailsVM.image != image {
            await Task.yield()
        }
    }

    // MARK: -

    private final class FavoritesMockModel: @unchecked Sendable, FavoritesModel {

        // MARK: - Properties

        // MARK: FavoritesModel protocol properties

        var favoritesPublisher: Published<[Book]>.Publisher { $favorites }
        @Published
        private(set) var favorites: [Book]

        // MARK: Private properties

        private let synchronisationQueue = DispatchQueue(label: "com.lazarevzubov.FavoritesMockModel")

        // MARK: - Initialization

        init(favorites: [Book] = [Book]()) {
            self.favorites = favorites
        }

        // MARK: - Methods

        // MARK: FavoritesModel protocol methods

        func toggleFavoriteStateOfBook(withID id: String) {
            synchronisationQueue.sync {
                if favorites.contains(where: { $0.id == id }) {
                    favorites.removeAll { $0.id == id }
                } else {
                    favorites.append(Book(id: id, authors: [], title: "", description: "Desc"))
                }
            }
        }

    }

}
