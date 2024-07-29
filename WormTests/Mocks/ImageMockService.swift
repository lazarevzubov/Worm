//
//  ImageMockService.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 5.4.2024.
//

import Foundation
@testable
import Worm

struct ImageMockService: ImageService {

    // MARK: - Properties

    let images: [URL : UniversalImage]

    // MARK: - Initialization

    init(images: [URL : UniversalImage] = [:]) {
        self.images = images
    }

    // MARK: - Methods

    // MARK: ImageService protocol methods

    func getImage(from url: URL) async -> UniversalImage? {
        images[url]
    }

}
