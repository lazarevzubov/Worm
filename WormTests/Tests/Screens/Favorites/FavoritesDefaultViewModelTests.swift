//
//  FavoritesDefaultViewModelTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 4.4.2024.
//

import Combine
import GoodreadsService
@testable
import Worm
import XCTest

final class FavoritesDefaultViewModelTests: XCTestCase {

    // MARK: - Methods

    func testFavorites_initiallyEmpty() {
        let vm: some FavoritesViewModel = FavoritesDefaultViewModel(model: FavoritesMockModel(),
                                                                    imageService: ImageMockService())
        XCTAssertTrue(vm.favorites.isEmpty)
    }

    func testFavorites_update() {
        let id = "1"
        let book = Book(id: id, authors: [], title: "", description: "Desc")

        let vm: some FavoritesViewModel = FavoritesDefaultViewModel(model: FavoritesMockModel(favorites: [book]),
                                                                    imageService: ImageMockService())

        let predicate = NSPredicate { vm, _ in
            guard let vm = vm as? any FavoritesViewModel else {
                return false
            }
            return vm.favorites == [BookViewModel(book: book, favorite: true)]
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: vm)

        wait(for: [expectation], timeout: 2.0)
    }

    func testFavorites_update_onAddingFavorite() async {
        let id = "1"
        let book = Book(id: id, authors: [], title: "", description: "Desc")

        let vm: some FavoritesViewModel = FavoritesDefaultViewModel(model: FavoritesMockModel(),
                                                                    imageService: ImageMockService())

        let predicate = NSPredicate { vm, _ in
            guard let vm = vm as? any FavoritesViewModel else {
                return false
            }
            return vm.favorites == [BookViewModel(book: book, favorite: true)]
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: vm)

        await vm.toggleFavoriteStateOfBook(withID: id)
        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func testFavorites_update_onRemovingFavorite() async {
        let id = "1"
        let book = Book(id: id, authors: [], title: "", description: "Desc")

        let vm: some FavoritesViewModel = FavoritesDefaultViewModel(model: FavoritesMockModel(favorites: [book]),
                                                                    imageService: ImageMockService())

        let predicate = NSPredicate { vm, _ in
            guard let vm = vm as? any FavoritesViewModel else {
                return false
            }
            return vm.favorites.isEmpty
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: vm)

        await vm.toggleFavoriteStateOfBook(withID: id)
        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func testDetailsViewModel_authors() {
        let vm: some FavoritesViewModel = FavoritesDefaultViewModel(model: FavoritesMockModel(),
                                                                    imageService: ImageMockService())

        let bookVM = BookViewModel(book: Book(id: "ID",
                                              authors: ["Author1", 
                                                        "Author2"],
                                              title: "Title",
                                              description: "Desc"),
                                   favorite: false)
        let bookDetailsVM = vm.makeDetailsViewModel(for: bookVM)

        XCTAssertEqual(bookDetailsVM.authors, bookVM.authors, "Unexpected authors string generated")
    }

    func testDetailsViewModel_title() {
        let vm: some FavoritesViewModel = FavoritesDefaultViewModel(model: FavoritesMockModel(),
                                                                    imageService: ImageMockService())

        let bookVM = BookViewModel(book: Book(id: "ID",
                                              authors: ["Author1", 
                                                        "Author2"],
                                              title: "Title",
                                              description: "Desc"),
                                   favorite: false)
        let bookDetailsVM = vm.makeDetailsViewModel(for: bookVM)

        XCTAssertEqual(bookDetailsVM.title, bookVM.title, "Unexpected authors string generated")
    }

    func testDetailsViewModel_image() {
        let imageURL = URL(string: "https://apple.com")!
        let image = UIImage()

        let vm: some FavoritesViewModel = FavoritesDefaultViewModel(
            model: FavoritesMockModel(), imageService: ImageMockService(images: [imageURL : image])
        )
        let bookVM = BookViewModel(book: Book(id: "ID", 
                                              authors: ["Author1",
                                                        "Author2"],
                                              title: "Title",
                                              description: "Desc",
                                              imageURL: URL(string: "https://apple.com")),
                                   favorite: false)

        let bookDetailsVM = vm.makeDetailsViewModel(for: bookVM)

        let predicate = NSPredicate { vm, _ in
            guard let vm = vm as? any BookDetailsViewModel else {
                return false
            }
            return vm.image == image
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: bookDetailsVM)

        wait(for: [expectation], timeout: 2.0)
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
