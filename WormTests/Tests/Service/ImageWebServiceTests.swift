//
//  ImageWebServiceTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 29.4.2024.
//

@testable
import Worm
import XCTest

final class ImageWebServiceTests: XCTestCase {

    // MARK: - Methods

    func testImageReturned_fromWebService() async {
        let url = URL(string: "https://apple.com")!
        let image = Bundle(for: type(of: self)).image(forResource: "Worms.jpg")!
        let webService = WebMockService(data: [url : image.dataRepresentation!])

        let service = ImageWebService(webService: webService)
        let retrievedImage = await service.getImage(from: url)

        XCTAssertEqual(retrievedImage!.dataRepresentation!, image.dataRepresentation!, "Unexpected data received")
    }

    func testNilReturned_whenWebService_throws() async {
        let service = ImageWebService(webService: WebMockService())

        let image = await service.getImage(from: URL(string: "https://apple.com")!)
        XCTAssertNil(image, "Unexpected data received")
    }

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
