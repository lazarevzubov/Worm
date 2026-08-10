//
//  BlockedBooksDefaultViewModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 9.8.2026.
//

import Combine
import GoodreadsService
import Testing
@testable
import Worm

@MainActor
struct BlockedBooksDefaultViewModelTests {

    // MARK: - Methods

    @Test
    func blockedBooks_empty_initially() async {
        let vm: any BlockedBooksViewModel = await BlockedBooksDefaultViewModel(
            model: BlockedBooksMockModel(), imageService: ImageMockService()
        )
        #expect(vm.blockedBooks.isEmpty, "Blocked list is not empty initially.")
    }

    @Test
    func detailsViewModel_authors_asExpected() async {
        let vm: any BlockedBooksViewModel = await BlockedBooksDefaultViewModel(
            model: BlockedBooksMockModel(), imageService: ImageMockService()
        )

        let bookVM = BookViewModel(
            book: Book(
                id: "ID",
                authors: [
                    "Author1",
                    "Author2"
                ],
                title: "Title",
                description: "Desc"
            ),
            favorite: false
        )
        let bookDetailsVM = vm.makeDetailsViewModel(for: bookVM)

        #expect(bookDetailsVM.authors == bookVM.authors, "Unexpected authors string generated")
    }

    @Test
    func detailsViewModel_title_asExpected() async {
        let vm: any BlockedBooksViewModel = await BlockedBooksDefaultViewModel(
            model: BlockedBooksMockModel(), imageService: ImageMockService()
        )

        let bookVM = BookViewModel(
            book: Book(
                id: "ID",
                authors: [
                    "Author1",
                    "Author2"
                ],
                title: "Title",
                description: "Desc"
            ),
            favorite: false
        )
        let bookDetailsVM = vm.makeDetailsViewModel(for: bookVM)

        #expect(bookDetailsVM.title == bookVM.title, "Unexpected authors string generated")
    }

    @Test(.timeLimit(.minutes(1)))
    func blockedBooks_update_works() async {
        let id = "1"
        let book = Book(id: id, authors: [], title: "", description: "Desc")

        let vm: any BlockedBooksViewModel = await BlockedBooksDefaultViewModel(
            model: BlockedBooksMockModel(blocked: [book]), imageService: ImageMockService()
        )
        while vm.blockedBooks != [BookViewModel(book: book, favorite: false)] {
            await Task.yield()
        }
    }

    @Test(.timeLimit(.minutes(1)))
    func blockedBooks_update_onUnblocking() async {
        let id = "1"
        let book = Book(id: id, authors: [], title: "", description: "Desc")

        let vm: any BlockedBooksViewModel = await BlockedBooksDefaultViewModel(
            model: BlockedBooksMockModel(blocked: [book]), imageService: ImageMockService()
        )
        while vm.blockedBooks.isEmpty {
            await Task.yield()
        }

        vm.unblockBook(BookViewModel(book: book, favorite: false))
        while !vm.blockedBooks.isEmpty {
            await Task.yield()
        }
    }

    @Test(.timeLimit(.minutes(1)))
    func errorDisplayed_set_whenUnblockingFails() async {
        let book = Book(id: "1", authors: [], title: "", description: "Desc")
        let vm: any BlockedBooksViewModel = await BlockedBooksDefaultViewModel(
            model: BlockedBooksMockModel(blocked: [book], errorToThrow: MockError()), imageService: ImageMockService()
        )

        vm.unblockBook(BookViewModel(book: book, favorite: false))
        while !vm.errorDisplayed {
            await Task.yield()
        }
    }

    // MARK: -

    private actor BlockedBooksMockModel: BlockedBooksModel {

        // MARK: - Properties

        // MARK: BlockedBooksModel protocol properties

        var blockedBooksPublisher: Published<[Book]>.Publisher { $blockedBooks }
        @Published
        private(set) var blockedBooks: [Book]

        // MARK: Private properties

        private let errorToThrow: Error?

        // MARK: - Initialization

        init(blocked: [Book] = [], errorToThrow: Error? = nil) async {
            self.blockedBooks = blocked
            self.errorToThrow = errorToThrow
        }

        // MARK: - Methods

        // MARK: BlockedBooksModel protocol methods

        func unblockBook(withID id: String) throws {
            if let errorToThrow {
                throw errorToThrow
            }
            blockedBooks.removeAll { $0.id == id }
        }

    }

}
