import Foundation
@testable import JobsityStreaming

class MockNetworkRequest: NetworkRequest {
    var fetchSeriesCalled = false
    var fetchSearchSeriesCalled = false
    var fetchEpisodesCalled = false
    var fetchEpisodeDetailsCalled = false
    var seriesModels: [SeriesModel] = [SeriesModel(id: 1,
                                                   name: "Under the Dome",
                                                   image: Images(medium: "https://static.tvmaze.com/uploads/images/medium_portrait/81/202627.jpg",
                                                                    original: "https://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg"),
                                                   genres: ["Drama", "Science-Fiction", "Thriller"],
                                                   schedule: Schedule(time: "22:00", days: ["Thursday"]),
                                                   summary: "<p><b>Under the Dome</b> is the story of a small town that is suddenly and inexplicably sealed off from the rest of the world by an enormous transparent dome. The town's inhabitants must deal with surviving the post-apocalyptic conditions while searching for answers about the dome, where it came from and if and when it will go away.</p>")]
    var searchSeriesModels: [SearchSeriesModel] = [SearchSeriesModel(show: SeriesModel(id: 1,
                                                                                       name: "Under the Dome",
                                                                                       image: Images(medium: "https://static.tvmaze.com/uploads/images/medium_portrait/81/202627.jpg",
                                                                                                        original: "https://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg"),
                                                                                       genres: ["Drama", "Science-Fiction", "Thriller"],
                                                                                       schedule: Schedule(time: "22:00", days: ["Thursday"]),
                                                                                       summary: "<p><b>Under the Dome</b> is the story of a small town that is suddenly and inexplicably sealed off from the rest of the world by an enormous transparent dome. The town's inhabitants must deal with surviving the post-apocalyptic conditions while searching for answers about the dome, where it came from and if and when it will go away.</p>"))]
    var episodeModels: [EpisodeModel] = [EpisodeModel(id: 1, season: 1, number: 1, name: "Pilot")]
    var episodeDetailsModel: EpisodeDetailsModel = EpisodeDetailsModel(id: 1,
                                                                       name: "Pilot",
                                                                       number: 1,
                                                                       season: 1,
                                                                       summary: "<p>When the residents of Chester's Mill find themselves trapped under a massive transparent dome with no way out, they struggle to survive as resources rapidly dwindle and panic quickly escalates.</p>",
                                                                       image: Images(medium: "https://static.tvmaze.com/uploads/images/medium_landscape/1/4388.jpg",
                                                                                     original: "https://static.tvmaze.com/uploads/images/original_untouched/1/4388.jpg"))
    var error: Error?

    override func fetchSeries(page: Int) async throws -> [SeriesModel] {
        fetchSeriesCalled = true
        if let error = error {
            throw error
        }
        return seriesModels
    }

    override func fetchSearchSeries(keyword: String) async throws -> [SearchSeriesModel] {
        fetchSearchSeriesCalled = true
        if let error = error {
            throw error
        }
        return searchSeriesModels
    }

    override func fetchEpisodes(with id: Int) async throws -> [EpisodeModel] {
        fetchEpisodesCalled = true
        if let error = error {
            throw error
        }
        return episodeModels
    }

    override func fetchEpisodeDetails(id: Int, season: Int, number: Int) async throws -> EpisodeDetailsModel {
        fetchEpisodeDetailsCalled = true
        if let error = error {
            throw error
        }
        return episodeDetailsModel
    }
}
