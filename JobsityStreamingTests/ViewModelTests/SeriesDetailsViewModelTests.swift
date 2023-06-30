import Foundation
import XCTest
@testable import JobsityStreaming

class SeriesDetailsViewModelTests: XCTestCase {

    var viewModel: SeriesDetailsViewModel!
    var mockNetworkRequest: MockNetworkRequest!

    override func setUp() {
        super.setUp()
        mockNetworkRequest = MockNetworkRequest()
        let seriesDetails = SeriesModel(id: 1,
                                         name: "Under the Dome",
                                         image: Images(medium: "https://static.tvmaze.com/uploads/images/medium_portrait/81/202627.jpg",
                                                          original: "https://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg"),
                                         genres: ["Drama", "Science-Fiction", "Thriller"],
                                         schedule: Schedule(time: "22:00", days: ["Thursday"]),
                                         summary: "<p><b>Under the Dome</b> is the story of a small town that is suddenly and inexplicably sealed off from the rest of the world by an enormous transparent dome. The town's inhabitants must deal with surviving the post-apocalyptic conditions while searching for answers about the dome, where it came from and if and when it will go away.</p>")

        viewModel = SeriesDetailsViewModel(seriesDetails: seriesDetails)
        viewModel.networkRequest = mockNetworkRequest
    }

    func testOnAppear_Success() {
        let expectedEpisodes = [EpisodeModel(id: 1, season: 1, number: 1, name: "Pilot")]
        mockNetworkRequest.episodeModels = expectedEpisodes

        let expectation = XCTestExpectation(description: "Fetch episodes")
        viewModel.onAppear()


        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.episodes, expectedEpisodes)
            XCTAssertEqual(self.viewModel.numberOfEpisodes, expectedEpisodes.count)
            XCTAssertEqual(self.viewModel.groupedEpisodes.count, 1)
            XCTAssertEqual(self.viewModel.numberOfSeasons, 1)
            XCTAssertTrue(self.mockNetworkRequest.fetchEpisodesCalled)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)


    }

    func testParseHTMLToPlainString_WithValidHTML_ReturnsPlainText() {
        let html = "<h1>Hello, World!</h1>"
        let expectedPlainText = "Hello, World!\n"

        let plainText = viewModel.parseHTMLToPlainString(html: html)

        XCTAssertEqual(plainText, expectedPlainText)
    }

    func testParseScheduleDays_WithMultipleDays_ReturnsFormattedString() {
        let days = ["Monday", "Wednesday", "Friday"]
        let expectedFormattedString = "Monday, Wednesday, Friday"

        let formattedString = viewModel.parseScheduleDays(days: days)

        XCTAssertEqual(formattedString, expectedFormattedString)
    }

    func testParseScheduleDays_WithSingleDay_ReturnsUnmodifiedString() {
        let days = ["Monday"]

        let formattedString = viewModel.parseScheduleDays(days: days)

        XCTAssertEqual(formattedString, "Monday")
    }

}
