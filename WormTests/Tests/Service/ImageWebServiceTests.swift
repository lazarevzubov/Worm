//
//  ImageWebServiceTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 29.4.2024.
//

import Foundation
import Testing
@testable
import Worm

struct ImageWebServiceTests {

    // MARK: - Methods

    @Test
    func image_returned_fromWebService() async {
        let url = URL(string: "https://apple.com")!
        let image = Bundle(for: type(of: BundleDetector())).image(forResource: "Worms.jpg")!
        let webService = WebMockService(data: [url : image.dataRepresentation!])

        let service = ImageWebService(webService: webService)
        let retrievedImage = await service.getImage(from: url)

        #expect(retrievedImage!.dataRepresentation! == image.dataRepresentation!, "Unexpected data received")
    }

    @Test
    func nil_returned_whenWebService_throws() async {
        let service = ImageWebService(webService: WebMockService())

        let image = await service.getImage(from: URL(string: "https://apple.com")!)
        #expect(image == nil, "Unexpected data received")
    }

    // MARK: -

    private final class BundleDetector { }

    // MARK: -

    private struct WebMockService: WebService {

        struct MockError: Error { }

        // MARK: - Properties

        // MARK: Private properties

        private let data: [URL : Data]

        // MARK: - Initialization

        init(data: [URL : Data] = [:]) {
            self.data = data
        }

        // MARK: - Methods

        // MARK: WebService protocol methods

        func data(from url: URL) async throws -> (Data, URLResponse) {
            if let data = data[url] {
                return (data, URLResponse())
            } else {
                throw MockError()
            }
        }

    }

}
