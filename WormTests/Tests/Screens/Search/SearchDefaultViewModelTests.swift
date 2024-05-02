//
//  SearchDefaultViewModelTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 25.4.2024.
//

import GoodreadsService
@testable
import Worm
import XCTest

final class SearchDefaultViewModelTests: XCTestCase {

    // MARK: - Methods

    func testQuery_initiallyEmpty() {
        let vm: any SearchViewModel = SearchDefaultViewModel(model: SearchMockModel(), imageService: ImageMockService())
        XCTAssertTrue(vm.query.isEmpty)
    }

    func testQuery_update_searchedModel() {
        let model = SearchMockModel()
        let vm: any SearchViewModel = SearchDefaultViewModel(model: model, imageService: ImageMockService())

        let query = "Query"
        vm.query = query

        let predicate = NSPredicate { model, _ in
            guard let model = model as? SearchMockModel else {
                return false
            }
            return model.query == query
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: model)

        wait(for: [expectation], timeout: 2.0)
    }

    func testBooks_initiallyEmpty() {
        let vm: any SearchViewModel = SearchDefaultViewModel(model: SearchMockModel(), imageService: ImageMockService())
        XCTAssertTrue(vm.books.isEmpty)
    }

    func testBooks_update() {
        let books: Set = [Book(authors: [], title: "", id: "1")]
        let vm: any SearchViewModel = SearchDefaultViewModel(model: SearchMockModel(books: books),
                                                             imageService: ImageMockService())

        let predicate = NSPredicate { vm, _ in
            guard let vm = vm as? any SearchViewModel else {
                return false
            }
            return vm.books == [BookViewModel(book: Book(authors: [], title: "", id: "1"), favorite: false)]
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: vm)

        wait(for: [expectation], timeout: 2.0)
    }

    func testBooks_update_withFavorite() {
        let id = "1"
        let books: Set = [Book(authors: [], title: "", id: id)]
        let vm: any SearchViewModel = SearchDefaultViewModel(model: SearchMockModel(books: books,
                                                                                    favoriteBookIDs: [id]),
                                                             imageService: ImageMockService())

        let predicate = NSPredicate { vm, _ in
            guard let vm = vm as? any SearchViewModel else {
                return false
            }
            return vm.books == [BookViewModel(book: Book(authors: [], title: "", id: id), favorite: true)]
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: vm)

        wait(for: [expectation], timeout: 2.0)
    }

    func testBooks_update_afterTogglingFavorite() async {
        let id = "1"
        let books: Set = [Book(authors: [], title: "", id: id)]
        let vm: any SearchViewModel = SearchDefaultViewModel(model: SearchMockModel(books: books),
                                                             imageService: ImageMockService())

        let predicate = NSPredicate { vm, _ in
            guard let vm = vm as? any SearchViewModel else {
                return false
            }
            return vm.books == [BookViewModel(book: Book(authors: [], title: "", id: id), favorite: true)]
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: vm)

        await vm.toggleFavoriteStateOfBook(withID: id)
        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func testTogglingFavorite_togglesModel() async {
        let model = SearchMockModel()
        let vm: any SearchViewModel = SearchDefaultViewModel(model: model, imageService: ImageMockService())

        let id = "1"
        await vm.toggleFavoriteStateOfBook(withID: id)

        XCTAssertTrue(model.favoriteBookIDs.contains(id), "The favorite state of the book was not toggled.")
    }

    func testDetailsViewModel_authors() {
        let vm: any SearchViewModel = SearchDefaultViewModel(model: SearchMockModel(), imageService: ImageMockService())

        let bookVM = BookViewModel(authors: "Authors",
                                   id: "ID",
                                   imageURL: URL(string: "https://apple.com"),
                                   favorite: true,
                                   title: "Title")
        let bookDetailsVM = vm.makeDetailsViewModel(for: bookVM)

        XCTAssertEqual(bookDetailsVM.authors, bookVM.authors, "The authors of the source and the result don't match.")
    }

    func testDetailsViewModel_title() {
        let vm: any SearchViewModel = SearchDefaultViewModel(model: SearchMockModel(), imageService: ImageMockService())

        let bookVM = BookViewModel(authors: "Authors",
                                   id: "ID",
                                   imageURL: URL(string: "https://apple.com"),
                                   favorite: true,
                                   title: "Title")
        let bookDetailsVM = vm.makeDetailsViewModel(for: bookVM)

        XCTAssertEqual(bookDetailsVM.title, bookVM.title, "The titles of the source and the result don't match.")
    }

    func testDetailsViewModel_image() {
        let imageURL = URL(string: "https://apple.com")!
        let image = UIImage()

        let vm: any SearchViewModel = SearchDefaultViewModel(model: SearchMockModel(),
                                                             imageService: ImageMockService(images: [imageURL : image]))
        let bookVM = BookViewModel(authors: "Authors", id: "ID", imageURL: imageURL, favorite: true, title: "Title")

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

}