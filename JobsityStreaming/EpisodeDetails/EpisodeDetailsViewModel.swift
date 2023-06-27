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


    func parseHTMLToPlainString(html: String) -> String? {
        guard let data = html.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        return attributedString.string
    }
}
