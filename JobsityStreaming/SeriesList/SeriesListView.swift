import SwiftUI

struct SeriesListView: View {
    @StateObject var viewModel: SeriesListViewModel

    var body: some View {
        VStack {
            NavigationView {
                ScrollView {
                    switch viewModel.requestState {
                    case .fetched:
                        list
                    case .searching:
                        ZStack {
                            Color("DarkBlue")
                            ProgressView()
                        }

                    case .noResults:
                        noResult
                    }
                }
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
                .foregroundColor(.white)
                .background(
                    Color("DarkBlue")
                )
            }

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
        LazyVStack {
            ForEach(viewModel.series.lazy, id: \.id) { series in
                NavigationLink(destination: SeriesDetailsView(viewModel: SeriesDetailsViewModel(seriesDetails: series))) {
                    SeriesRowView(series: series)
                }
                .onAppear{
                    if series.id == viewModel.series.last?.id {
                        viewModel.loadMoreSeries()
                    }
                }
            }
        }
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
        VStack(alignment: .center, spacing: 0) {
            AsyncImage(url: URL(string: series.image?.original ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(10)
                    .frame(maxWidth: 200)
            } placeholder: {
                ProgressView()
                    .frame(width: 150, height: 300)
            }
            Text(series.name)
                .bold()
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.bottom, 20)
        }
    }
}
