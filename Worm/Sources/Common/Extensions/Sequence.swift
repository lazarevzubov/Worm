//
//  Sequence.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 2.3.2024.
//  Copyright © 2024 Nikita Lazarev-Zubov. All rights reserved.
//

extension Sequence {

    // MARK: - Methods

    /// Returns the elements of the sequence, sorted using the given predicate as the comparison between elements.
    ///
    /// The sorting is stable.
    /// 
    /// - Parameters:
    ///   - areInIncreasingOrder: A predicate that returns `true` if its first argument should be ordered before its second argument;
    ///     otherwise, `false`.
    ///     - lhs: The element the goes first in the set of two compared elements.
    ///     - rhs: The element the goes second in the set of two compared elements.
    ///
    /// - Returns: A sorted array of the sequence’s elements.
    func stableSorted(by areInIncreasingOrder: (_ lhs: Element, _ rhs: Element) throws -> Bool) rethrows -> [Element] {
        try enumerated()
            .sorted {
                try areInIncreasingOrder($0.element, $1.element)
                        || (($0.offset < $1.offset)
                                && !areInIncreasingOrder($1.element, $0.element))
            }
            .map { $0.element }
    }

}
