//
//  MainView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 13.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

struct MainView: View {

    // MARK: - Properties

    var body: some View { Text("Hello, World!") }

    // MARK: Private properties

    private let model: MainViewModel

    // MARK: - Initialization

    init(model: MainViewModel) {
        self.model = model
    }

}

// MARK: -

struct MainView_Previews: PreviewProvider {

    // MARK: - Properties

    static var previews: some View {
        let model = MainViewPreviewModel()
        return MainView(model: model)
    }

}
