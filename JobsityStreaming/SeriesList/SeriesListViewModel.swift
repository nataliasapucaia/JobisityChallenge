import SwiftUI

class SeriesListViewModel: ObservableObject {
    var networkRequest = NetworkRequest()
    @Published var series: [SeriesModel] = []

    func onAppear() {
        Task {
            do {
                let fetchedSeries = try await networkRequest.fetchSeries()
                await MainActor.run {
                    self.series = fetchedSeries
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
