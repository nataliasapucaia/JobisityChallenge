//
//  ShowDetailsView.swift
//  JobsityStreaming
//
//  Created by Natália Sapucaia on 26/06/23.
//

import SwiftUI

struct SeriesDetailsView: View {
    @StateObject var viewModel: SeriesDetailsViewModel

    var body: some View {
        NameView(name: viewModel.seriesDetails.name)
        let imageURL = URL(string: viewModel.seriesDetails.image?.original ?? "")
//        ScrollView {
            VStack(spacing: 10) {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray
                }

                GenresView(genres: viewModel.seriesDetails.genres)
                NewEpisodesView(days: viewModel.parseScheduleDays(days: viewModel.seriesDetails.schedule.days), time: viewModel.seriesDetails.schedule.time)
                SummaryView(summary: viewModel.parseHTMLToPlainString(html: viewModel.seriesDetails.summary))

                List(viewModel.episodes){ episode in
                    Text("\(episode.season) x \(episode.number) - \(episode.name)")
                }
            }
            .onAppear{
                viewModel.onAppear()
            }
//        }
    }


}

struct NameView: View {
    var name: String

    var body: some View {
        Text(name)
            .font(.title)
    }
}

struct GenresView: View {
    var genres: [String]

    var body: some View {
        HStack {
            ForEach(Array(genres.enumerated()), id: \.1) { index, genre in
                Text("\(genre)\(index != genres.count - 1 ? " •" : "")")
            }
        }
    }
}

struct NewEpisodesView: View {
    var days: String
    var time: String

    var body: some View {
        let episodesText: String

        if time.isEmpty && days.isEmpty {
            episodesText = "There are no more episodes"
        } else if time.isEmpty && !days.isEmpty{
            episodesText = "New episodes every \(days)"
        }
        else if !time.isEmpty && days.isEmpty {
            episodesText = "New episodes at \(time)"
        } else {
            episodesText = "New episodes every \(days) at \(time)"
        }
        return Text(episodesText)
    }
}

struct SummaryView: View {
    var summary: String?

    var body: some View {
        Text(summary ?? "")
            .padding()
            .multilineTextAlignment(.center)
    }
}
