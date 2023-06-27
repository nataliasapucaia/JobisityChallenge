import SwiftUI

struct SeriesListView: View {
    @StateObject var viewModel: SeriesListViewModel

    var body: some View {
        VStack {
            NavigationView {
                List(viewModel.series){ series in
                    NavigationLink(destination: SeriesDetailsView(viewModel: SeriesDetailsViewModel(seriesDetails: series))) {
                        HStack {
                            AsyncImage(url: URL(string: series.image?.original ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 100)
                            } placeholder: {
                                ProgressView()
                            }

                            Text(series.name)
                        }
                    }
                }
            }
        }
        .onAppear{
            viewModel.onAppear()
        }
    }
}

