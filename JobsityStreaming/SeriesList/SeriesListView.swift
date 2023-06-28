import SwiftUI

struct SeriesListView: View {
    @StateObject var viewModel: SeriesListViewModel

    var body: some View {
        VStack {
            NavigationView {
                switch viewModel.requestState {
                case .fetched:
                    list
                case .searching:
                    ProgressView()
                case .noResults:
                    noResult
                }
            }
            .searchable(text: $viewModel.searchText)
            .foregroundColor(.white)
        }
        .onAppear{
            viewModel.onAppear()
        }
    }

    var noResult: some View {
        ZStack {
            Color("DarkBlue").edgesIgnoringSafeArea(.all)
            Text("No results found\n):")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .foregroundColor(.white)

        }
    }

    var list: some View {
        List(viewModel.series){ series in
            NavigationLink(destination: SeriesDetailsView(viewModel: SeriesDetailsViewModel(seriesDetails: series))) {
                HStack {
                    SeriesRowView(series: series)
                }
            }
            .onAppear{
                if series.id == viewModel.series.last?.id {
                    viewModel.loadMoreSeries()
                }
            }
            .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
        .background(
            Color("DarkBlue")
        )
        .navigationTitle("Series")
        .navigationBarBackground()
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
                    .cornerRadius(25)
                    .frame(width: 150, height: 300)
            } placeholder: {
                ProgressView()
                    .frame(width: 150, height: 300)
            }
            Text(series.name)
                .foregroundColor(.white)
        }
    }
}

