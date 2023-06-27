import SwiftUI

class SeriesDetailsViewModel: ObservableObject {
    var networkRequest = NetworkRequest()
    @Published var episodes: [EpisodesModel] = []
    let seriesDetails: SeriesModel

    public init(seriesDetails: SeriesModel ) {
        self.seriesDetails = seriesDetails
    }
    func onAppear() {
        Task {
            do {
                let fetchedEpisode = try await networkRequest.fetchEpisodes(with: seriesDetails.id)
                await MainActor.run {
                    self.episodes = fetchedEpisode
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
