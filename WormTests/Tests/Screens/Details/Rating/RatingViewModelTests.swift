import Testing
@testable 
import Worm

struct RatingViewModelTests {
    
    // MARK: - Methods

    @Test
    func rating_storedCorrectly_afterInitialization() {
        let rating = 3.5
        let viewModel = RatingViewModel(rating: rating)

        #expect(viewModel.rating == rating)
    }

    @Test
    func maxRating_defaultsToFive_whenNotSpecified() {
        let viewModel = RatingViewModel(rating: 3.5)
        #expect(viewModel.units.count == 5)
    }
    
    @Test
    func maxRating_usedCorrectly_whenSpecified() {
        let maxRating = 10
        let viewModel = RatingViewModel(rating: 3.5, maxRating: maxRating)

        #expect(viewModel.units.count == maxRating)
    }

    @Test
    func allUnits_empty_whenRating_isZero() {
        let viewModel = RatingViewModel(rating: .zero)
        #expect(viewModel.units.allSatisfy { $0 == .empty })
    }
    
    @Test
    func allUnits_full_whenRating_max() {
        let rating = 5.0
        let viewModel = RatingViewModel(rating: rating, maxRating: Int(rating))

        #expect(viewModel.units.allSatisfy { $0 == .full })
    }

    @Test
    func firstUnit_empty_whenRating_01() {
        let viewModel = RatingViewModel(rating: 0.1)

        #expect(viewModel.units[0] == .empty)
        #expect(viewModel.units.dropFirst(1).allSatisfy { $0 == .empty })
    }

    @Test
    func firstUnit_empty_whenRating_04() {
        let viewModel = RatingViewModel(rating: 0.4)

        #expect(viewModel.units[0] == .empty)
        #expect(viewModel.units.dropFirst(1).allSatisfy { $0 == .empty })
    }

    @Test
    func firstUnit_halfEmpty_whenRating_05() {
        let viewModel = RatingViewModel(rating: 0.5)

        #expect(viewModel.units[0] == .halfEmpty)
        #expect(viewModel.units.dropFirst(1).allSatisfy { $0 == .empty })
    }

    @Test
    func firstUnit_halfEmpty_whenRating_06() {
        let viewModel = RatingViewModel(rating: 0.6)

        #expect(viewModel.units[0] == .halfEmpty)
        #expect(viewModel.units.dropFirst(1).allSatisfy { $0 == .empty })
    }

    @Test
    func firstUnit_halfEmpty_whenRating_09() {
        let viewModel = RatingViewModel(rating: 0.9)

        #expect(viewModel.units[0] == .halfEmpty)
        #expect(viewModel.units.dropFirst(1).allSatisfy { $0 == .empty })
    }

    @Test
    func firstUnit_full_whenRating_1() {
        let viewModel = RatingViewModel(rating: 1.0)

        #expect(viewModel.units[0] == .full)
        #expect(viewModel.units.dropFirst(1).allSatisfy { $0 == .empty })
    }
    
    @Test
    func firstUnit_full_secondUnit_halfEmpty_whenRating_oneAndHalf() {
        let rating = 1.5
        let viewModel = RatingViewModel(rating: rating)

        #expect(viewModel.units[0] == .full)
        #expect(viewModel.units[1] == .halfEmpty)
        #expect(viewModel.units.dropFirst(2).allSatisfy { $0 == .empty })
    }
    
    @Test
    func allUnits_full_whenRating_five() {
        let viewModel = RatingViewModel(rating: 5.0)
        #expect(viewModel.units.allSatisfy { $0 == .full })
    }
    
    @Test
    func allUnits_empty_whenRating_negative() {
        let viewModel = RatingViewModel(rating: -1.0)
        #expect(viewModel.units.allSatisfy { $0 == .empty })
    }
    
    @Test
    func allUnits_full_whenRating_exceedsMax() {
        let viewModel = RatingViewModel(rating: 6.0, maxRating: 5)
        #expect(viewModel.units.allSatisfy { $0 == .full })
    }

}
