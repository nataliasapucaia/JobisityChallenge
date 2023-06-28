import SwiftUI
import Combine

class SeriesListViewModel: ObservableObject {
    private var disposeBag = Set<AnyCancellable>()
    private var currentPage: Int = 0
    var networkRequest = NetworkRequest()
    @Published var series: [SeriesModel] = []
    @Published var searchText = ""

    var initialSeries: [SeriesModel] = []

    init() {
        self.debounceTextChanges()
    }

    func onAppear() {
        fetchSeries()
    }


    func fetchSeries(page: Int = 0) {
        Task {
            do {
                let fetchedSeries = try await networkRequest.fetchSeries(page: currentPage)
                await MainActor.run {
                    self.series.append(contentsOf: fetchedSeries)
                    self.initialSeries.append(contentsOf: series)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func loadMoreSeries() {
        currentPage += 1
        fetchSeries(page: currentPage)
    }

    func filterSeries(with keyword: String) {
        guard !keyword.isEmpty else {
            series = initialSeries
            return
        }
        Task {
            do {
                let filteredSeries = try await networkRequest.fetchSearchSeries(keyword: keyword)
                await MainActor.run {
                    self.series = filteredSeries.map { $0.show }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func debounceTextChanges() {
        $searchText
            .debounce(for: 2, scheduler: RunLoop.main)
            .sink {
                self.filterSeries(with: $0)
            }
            .store(in: &disposeBag)
    }

}
