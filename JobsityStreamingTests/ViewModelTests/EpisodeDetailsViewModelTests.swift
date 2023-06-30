import Foundation
import XCTest
@testable import JobsityStreaming

class EpisodeDetailsViewModelTests: XCTestCase {
    var viewModel: EpisodeDetailsViewModel!

    override func setUp() {
        super.setUp()
        viewModel = EpisodeDetailsViewModel(seriesId: 1, season: 2, number: 3)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testOnAppear_Success() {
        let mockNetworkRequest = MockNetworkRequest()
        let episodeDetails = EpisodeDetailsModel(id: 1,
                                                 name: "Pilot",
                                                 number: 1,
                                                 season: 1,
                                                 summary: "<p>When the residents of Chester's Mill find themselves trapped under a massive transparent dome with no way out, they struggle to survive as resources rapidly dwindle and panic quickly escalates.</p>",
                                                 image: Images(medium: "https://static.tvmaze.com/uploads/images/medium_landscape/1/4388.jpg",
                                                               original: "https://static.tvmaze.com/uploads/images/original_untouched/1/4388.jpg"))
        mockNetworkRequest.episodeDetailsModel = episodeDetails
        viewModel.networkRequest = mockNetworkRequest

        let expectation = XCTestExpectation(description: "Fetch episode details")
        viewModel.onAppear()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.episodeDetails, episodeDetails)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
    }

    func testOnAppear_Failure() {
        let mockNetworkRequest = MockNetworkRequest()
        let expectedError = NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)
        mockNetworkRequest.error = expectedError
        viewModel.networkRequest = mockNetworkRequest

        viewModel.onAppear()

        XCTAssertNil(viewModel.episodeDetails)
    }

    func testParseHTMLToPlainString_WithValidHTML_ReturnsPlainText() {
        let html = "<h1>Hello, World!</h1>"
        let expectedPlainText = "Hello, World!\n"

        let plainText = viewModel.parseHTMLToPlainString(html: html)

        XCTAssertEqual(plainText, expectedPlainText)
    }
}
