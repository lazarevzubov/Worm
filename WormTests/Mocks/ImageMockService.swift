//
//  ImageMockService.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 5.4.2024.
//

import UIKit
@testable
import Worm

struct ImageMockService: ImageService {

    // MARK: - Properties

    let images: [URL : UIImage]

    // MARK: - Initialization

    init(images: [URL : UIImage] = [:]) {
        self.images = images
    }

    // MARK: - Methods

    // MARK: ImageService protocol methods

    func getImage(from url: URL) async -> UIImage? {
        images[url]
    }

}
