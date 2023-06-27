import SwiftUI

class EpisodeDetailsViewModel: ObservableObject {
    var networkRequest = NetworkRequest()
    @Published var episodeDetails: EpisodeDetailsModel?
    var seriesId: Int
    var season: Int
    var number: Int

    public init(seriesId: Int, season: Int, number: Int) {
        self.seriesId = seriesId
        self.season = season
        self.number = number
    }

    func onAppear() {
        Task {
            do {
                let fetchedEpisodeDetails = try await networkRequest.fetchEpisodeDetails(id: seriesId, season: season, number: number)
                await MainActor.run {
                    self.episodeDetails = fetchedEpisodeDetails
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
