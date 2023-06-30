import XCTest
import Combine
@testable import JobsityStreaming

class SeriesListViewModelTests: XCTestCase {
    var viewModel: SeriesListViewModel!
    var mockNetworkRequest: MockNetworkRequest!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = SeriesListViewModel()
        mockNetworkRequest = MockNetworkRequest()
        viewModel.networkRequest = mockNetworkRequest
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkRequest = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchSeries_Success() {
        let expectedSeries = [SeriesModel(id: 1,
                                          name: "Under the Dome",
                                          image: Images(medium: "https://static.tvmaze.com/uploads/images/medium_portrait/81/202627.jpg",
                                                           original: "https://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg"),
                                          genres: ["Drama", "Science-Fiction", "Thriller"],
                                          schedule: Schedule(time: "22:00", days: ["Thursday"]),
                                          summary: "<p><b>Under the Dome</b> is the story of a small town that is suddenly and inexplicably sealed off from the rest of the world by an enormous transparent dome. The town's inhabitants must deal with surviving the post-apocalyptic conditions while searching for answers about the dome, where it came from and if and when it will go away.</p>")]

        mockNetworkRequest.seriesModels = expectedSeries

        let expectation = XCTestExpectation(description: "Fetch series")
        viewModel.fetchSeries()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.series, expectedSeries)
            XCTAssertEqual(self.viewModel.requestState, .fetched)
            XCTAssertTrue(self.mockNetworkRequest.fetchSeriesCalled)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
    }

    func testFetchSeries_Failure() {
        let expectedError = NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)
        mockNetworkRequest.error = expectedError

        let expectation = XCTestExpectation(description: "Fetch series")
        viewModel.fetchSeries()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.viewModel.series, [])
            XCTAssertEqual(self.viewModel.requestState, .fetched)
            XCTAssertTrue(self.mockNetworkRequest.fetchSeriesCalled)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
    }

    func testDebounceTextChanges() {
        // Set up your test data
        let expectation = XCTestExpectation(description: "debounceTextChanges")
        let expectedKeyword = "Test"
        let expectedFilteredSeries = [SeriesModel(id: 1,
                                                  name: "Under the Dome",
                                                  image: Images(medium: "https://static.tvmaze.com/uploads/images/medium_portrait/81/202627.jpg",
                                                                   original: "https://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg"),
                                                  genres: ["Drama", "Science-Fiction", "Thriller"],
                                                  schedule: Schedule(time: "22:00", days: ["Thursday"]),
                                                  summary: "<p><b>Under the Dome</b> is the story of a small town that is suddenly and inexplicably sealed off from the rest of the world by an enormous transparent dome. The town's inhabitants must deal with surviving the post-apocalyptic conditions while searching for answers about the dome, where it came from and if and when it will go away.</p>")]
        mockNetworkRequest.searchSeriesModels = [SearchSeriesModel(show: SeriesModel(id: 1,
                                                                                     name: "Under the Dome",
                                                                                     image: Images(medium: "https://static.tvmaze.com/uploads/images/medium_portrait/81/202627.jpg",
                                                                                                      original: "https://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg"),
                                                                                     genres: ["Drama", "Science-Fiction", "Thriller"],
                                                                                     schedule: Schedule(time: "22:00", days: ["Thursday"]),
                                                                                     summary: "<p><b>Under the Dome</b> is the story of a small town that is suddenly and inexplicably sealed off from the rest of the world by an enormous transparent dome. The town's inhabitants must deal with surviving the post-apocalyptic conditions while searching for answers about the dome, where it came from and if and when it will go away.</p>"))]

        viewModel.searchText = expectedKeyword

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            XCTAssertEqual(self.viewModel.series, expectedFilteredSeries)
            XCTAssertEqual(self.viewModel.requestState, .fetched)
            XCTAssertTrue(self.mockNetworkRequest.fetchSearchSeriesCalled)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3.0)
    }
}
