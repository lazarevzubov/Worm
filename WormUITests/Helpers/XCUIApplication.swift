//
//  XCUIApplication.swift
//  WormUITests
//
//  Created by Lazarev-Zubov, Nikita on 18.8.2026.
//  Copyright © 2026 Nikita Lazarev-Zubov. All rights reserved.
//

import XCTest

extension XCUIApplication {

    // MARK: - Methods

    func element(withIdentifier identifier: String) -> XCUIElement {
        descendants(matching: .any)[identifier]
    }

    func bookRow(titled title: String) -> XCUIElement {
        buttons.matching(NSPredicate(format: "label CONTAINS[c] %@", title)).firstMatch
    }

    func isTabSelected(withIdentifier identifier: String) -> Bool {
        let tab = element(withIdentifier: identifier)
        return tab.isSelected
            || (tab.value as? Int == 1)
    }

    func isScreenVisible(titled title: String) -> Bool {
        navigationBars[title].exists
            || (windows.firstMatch.title == title)
    }

}
