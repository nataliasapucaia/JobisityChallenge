import SwiftUI
import Combine

enum RequestState {
    case searching
    case fetched
    case noResults
}

class SeriesListViewModel: ObservableObject {
    @Published var series: [SeriesModel] = []
    @Published var searchText = ""

    private var disposeBag = Set<AnyCancellable>()
    private var currentPage: Int = 0
    var networkRequest = NetworkRequest()
    var initialSeries: [SeriesModel] = []
    var requestState: RequestState = .searching

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
                    requestState = .fetched
                    self.series.append(contentsOf: fetchedSeries)
                    self.initialSeries.append(contentsOf: series)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func loadMoreSeries() {
        while currentPage < 278 {
            currentPage += 1
            fetchSeries(page: currentPage)
        }
    }

    func filterSeries(with keyword: String) {
        guard !keyword.isEmpty else {
            series = initialSeries
            requestState = .fetched
            return
        }
        Task {
            do {
                let filteredSeries = try await networkRequest.fetchSearchSeries(keyword: keyword)
                await MainActor.run {
                    requestState = .fetched
                    self.series = filteredSeries.map { $0.show }
                    if filteredSeries.isEmpty {
                        requestState = .noResults
                    }
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
