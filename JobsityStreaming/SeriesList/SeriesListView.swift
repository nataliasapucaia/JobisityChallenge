import SwiftUI

//enum States {
//    case searching(let showsFound)
//    case fetching
//    case contentLoaded(let shows)
//}

struct SeriesListView: View {
    @StateObject var viewModel: SeriesListViewModel
    @State private var searchText = ""

    var body: some View {
        VStack {
            NavigationView {
                List(viewModel.series){ series in
                    NavigationLink(destination: SeriesDetailsView(viewModel: SeriesDetailsViewModel(seriesDetails: series))) {
                        HStack {
                            SeriesRowView(series: series)
                        }
                    }
                }
                .searchable(text: $searchText)
                .onChange(of: searchText) { newValue in
                    viewModel.filterSeries(with: newValue)
                }
                .navigationTitle("Series")
            }
        }
        .onAppear{
            viewModel.onAppear()
        }
    }
}

struct SeriesRowView: View {
    var series: SeriesModel

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: series.image?.original ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 200)
            } placeholder: {
                ProgressView()
            }

            Text(series.name)
        }
    }
}

