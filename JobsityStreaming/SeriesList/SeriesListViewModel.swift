import SwiftUI

class SeriesListViewModel: ObservableObject {
    var networkRequest = NetworkRequest()
    @Published var series: [SeriesModel] = []
    @Published var filteredSeries: [SearchSeriesModel] = []
    var initialSeries: [SeriesModel] = []

    func onAppear() {
        fetchSeries()
    }


    func fetchSeries() {
        Task {
            do {
                let fetchedSeries = try await networkRequest.fetchSeries()
                await MainActor.run {
                    self.series = fetchedSeries
                    self.initialSeries = series
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func filterSeries(with keyword: String) {
        Task {
            do {
                let filteredSeries = try await networkRequest.fetchSearchSeries(keyword: keyword)
                await MainActor.run {
                    self.filteredSeries = filteredSeries
                    let extractedSeries = filteredSeries.map { $0.show }
                    series = extractedSeries
                    if keyword.isEmpty {
                        series = initialSeries
                    } else if filteredSeries.count == 0 {
                        print("series nao encontras")
                    }
                    print("filteresSeries", self.filteredSeries)
                }
            } catch {
                print(error)
                print(error.localizedDescription)
            }
        }
    }
}
