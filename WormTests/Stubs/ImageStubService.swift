//
//  ImageStubService.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 7.3.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

import UIKit
@testable
import Worm

struct ImageStubService: ImageService {

    // MARK: - Methods

    // MARK: ImageService protocol methods

    func getImage(for url: URL, resultCompletion: @escaping (UIImage?) -> Void) {
        // Do nothing.
    }

}
