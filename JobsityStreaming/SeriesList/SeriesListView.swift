import SwiftUI

struct SeriesListView: View {
    @StateObject var viewModel: SeriesListViewModel
    @State private var selectedShow: SeriesModel?

    var body: some View {
        VStack {
            NavigationView {
                List(viewModel.series){ series in
                    NavigationLink(destination: SeriesDetailsView(viewModel: SeriesDetailsViewModel(seriesDetails: series))) {
                        HStack {
                            Image(systemName: "bolt")
                                .frame(width: 50, height: 100)
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

