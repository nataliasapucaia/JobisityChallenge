import SwiftUI

class SeriesDetailsViewModel: ObservableObject {
    var networkRequest = NetworkRequest()
    let seriesDetails: SeriesModel
    var numberOfEpisodes: Int = 0
    var numberOfSeasons: Int = 0
    @Published var episodes: [EpisodeModel] = []
    @Published var groupedEpisodes: [Int: [EpisodeModel]] = [:]

    public init(seriesDetails: SeriesModel ) {
        self.seriesDetails = seriesDetails
    }
    
    func onAppear() {
        Task {
            do {
                let fetchedEpisode = try await networkRequest.fetchEpisodes(with: seriesDetails.id)
                await MainActor.run {
                    self.episodes = fetchedEpisode
                    numberOfEpisodes = episodes.count
                    self.groupedEpisodes = Dictionary(grouping: fetchedEpisode, by: {$0.season})
                    numberOfSeasons = groupedEpisodes.count
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

    func parseScheduleDays(days: [String]) -> String {
        var allDays = ""
        for (index, day) in days.enumerated() {
            var myDay = "\(day)\(index != days.count - 1 ? ", " : "")"
            allDays.append(myDay)
        }
        return allDays
    }
}
