//
//  SearchDefaultViewModelTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 25.4.2024.
//

import Foundation
import GoodreadsService
import Testing
@testable
import Worm

struct SearchDefaultViewModelTests {

    // MARK: - Methods

    @MainActor
    @Test
    func searchOnboarding_state_asProvided_initially() async {
        let value = true
        let service = OnboardingMockService(onboardingShown: value)

        let vm: any SearchViewModel = await SearchDefaultViewModel(
            model: SearchMockModel(), onboardingService: service, imageService: ImageMockService()
        )
        #expect(vm.searchOnboardingShown == value, "Search onboarding has an unexpected initial value.")
    }

    @MainActor
    @Test
    func searchOnboarding_update_doesNotUpdatePersistence() async {
        let value = true
        let service = OnboardingMockService(onboardingShown: value)
        let vm: any SearchViewModel = await SearchDefaultViewModel(
            model: SearchMockModel(), onboardingService: service, imageService: ImageMockService()
        )

        let newValue = !value
        vm.searchOnboardingShown = newValue

        #expect(service.searchOnboardingShown == value, "Persistence was unexpectedly updated.")
    }

    @MainActor
    @Test
    func recommendationsOnboarding_state_asProvided_initially() async {
        let value = true
        let service = OnboardingMockService(onboardingShown: value)

        let vm: any SearchViewModel = await SearchDefaultViewModel(
            model: SearchMockModel(), onboardingService: service, imageService: ImageMockService()
        )
        #expect(vm.recommendationsOnboardingShown == value, "Search onboarding has an unexpected initial value.")
    }

    @MainActor
    @Test(.timeLimit(.minutes(1)))
    func recommendationsOnboarding_update_updatesPersistence() async {
        let value = true
        let service = OnboardingMockService(onboardingShown: value)
        let vm: any SearchViewModel = await SearchDefaultViewModel(
            model: SearchMockModel(), onboardingService: service, imageService: ImageMockService()
        )

        let newValue = !value
        vm.recommendationsOnboardingShown = newValue

        while service.searchOnboardingShown != newValue {
            await Task.yield()
        }
    }

    @MainActor
    @Test
    func query_empty_initially() async {
        let vm: any MainScreenViewModel = await SearchDefaultViewModel(
            model: SearchMockModel(), onboardingService: OnboardingMockService(), imageService: ImageMockService()
        )
        #expect(vm.query.isEmpty, "Query has an unexpected initial value.")
    }

    @MainActor
    @Test(.timeLimit(.minutes(1)))
    func query_update_searchedModel() async {
        let model = await SearchMockModel()
        let vm: any MainScreenViewModel = SearchDefaultViewModel(
            model: model, onboardingService: OnboardingMockService(), imageService: ImageMockService()
        )

        let query = "Query"
        vm.query = query

        while await model.query != query {
            await Task.yield()
        }
    }

    @MainActor
    @Test
    func books_empty_initially() async {
        let vm: any SearchViewModel = await SearchDefaultViewModel(
            model: SearchMockModel(), onboardingService: OnboardingMockService(), imageService: ImageMockService()
        )
        #expect(vm.books.isEmpty)
    }

    @MainActor
    @Test(.timeLimit(.minutes(1)))
    func books_update() async {
        let books: Set = [Book(id: "1", authors: [], title: "", description: "Desc")]
        let vm: any SearchViewModel = await SearchDefaultViewModel(
            model: SearchMockModel(books: books),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )

        while vm.books != [
            BookViewModel(book: Book(id: "1", authors: [], title: "", description: "Desc"), favorite: false)
        ] {
            await Task.yield()
        }
    }

    @MainActor
    @Test(.timeLimit(.minutes(1)))
    func books_update_withFavorite() async {
        let id = "1"
        let books: Set = [Book(id: id, authors: [], title: "", description: "Desc")]
        let vm: any SearchViewModel = await SearchDefaultViewModel(
            model: SearchMockModel(books: books, favoriteBookIDs: [id]),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )

        while vm.books != [
            BookViewModel(book: Book(id: id, authors: [], title: "", description: "Desc"), favorite: true)
        ] {
            await Task.yield()
        }
    }

    @MainActor
    @Test(.timeLimit(.minutes(1)))
    func books_update_afterTogglingFavorite() async {
        let id = "1"
        let books: Set = [Book(id: id, authors: [], title: "", description: "Desc")]
        let vm: any SearchViewModel = await SearchDefaultViewModel(
            model: SearchMockModel(books: books),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )

        vm.toggleFavoriteStateOfBook(withID: id)
        while vm.books != [
            BookViewModel(book: Book(id: id, authors: [], title: "", description: "Desc"), favorite: true)
        ] {
            await Task.yield()
        }
    }

    @MainActor
    @Test(.timeLimit(.minutes(1)))
    func togglingFavorite_togglesModel() async {
        let model = await SearchMockModel()
        let vm: any SearchViewModel = SearchDefaultViewModel(
            model: model, onboardingService: OnboardingMockService(), imageService: ImageMockService()
        )

        let id = "1"
        vm.toggleFavoriteStateOfBook(withID: id)

        while await !model.favoriteBookIDs.contains(id) {
            await Task.yield()
        }
    }

    @MainActor
    @Test
    func detailsViewModel_authors_asProvided() async {
        let vm: any SearchViewModel = await SearchDefaultViewModel(
            model: SearchMockModel(), onboardingService: OnboardingMockService(), imageService: ImageMockService()
        )

        let bookVM = BookViewModel(
            id: "ID",
            authors: "Authors",
            title: "Title",
            description: "Desc",
            imageURL: URL(string: "https://apple.com"),
            favorite: true
        )
        let bookDetailsVM = vm.makeDetailsViewModel(for: bookVM)

        #expect(bookDetailsVM.authors == bookVM.authors, "The authors of the source and the result don't match.")
    }

    @MainActor
    @Test
    func detailsViewModel_title_asProvided() async {
        let vm: any SearchViewModel = await SearchDefaultViewModel(
            model: SearchMockModel(), onboardingService: OnboardingMockService(), imageService: ImageMockService()
        )

        let bookVM = BookViewModel(
            id: "ID",
            authors: "Authors",
            title: "Title",
            description: "Desc",
            imageURL: URL(string: "https://apple.com"),
            favorite: true
        )
        let bookDetailsVM = vm.makeDetailsViewModel(for: bookVM)

        #expect(bookDetailsVM.title == bookVM.title, "The titles of the source and the result don't match.")
    }

    @MainActor
    @Test(.timeLimit(.minutes(1)))
    func detailsViewModel_image_asProvided() async {
        let imageURL = URL(string: "https://apple.com")!
        let image = UniversalImage()

        let vm: any SearchViewModel = await SearchDefaultViewModel(
            model: SearchMockModel(),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService(images: [imageURL : image])
        )
        let bookVM = BookViewModel(
            id: "ID",
            authors: "Authors",
            title: "Title",
            description: "Desc",
            imageURL: imageURL,
            favorite: true
        )

        let bookDetailsVM = vm.makeDetailsViewModel(for: bookVM)
        while bookDetailsVM.image != image {
            await Task.yield()
        }
    }

}
