import SwiftUI

class EpisodeDetailsViewModel: ObservableObject {
    var networkRequest = NetworkRequest()
    @Published var episodeDetails: EpisodeDetailsModel?

    func onAppear() {
        Task {
            do {
                let fetchedEpisodeDetails = try await networkRequest.fetchEpisodeDetails(id: 1, season: 1, number: 1)
                await MainActor.run {
                    self.episodeDetails = fetchedEpisodeDetails
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
