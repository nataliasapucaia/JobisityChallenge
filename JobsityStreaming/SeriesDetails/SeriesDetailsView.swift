//
//  ShowDetailsView.swift
//  JobsityStreaming
//
//  Created by Natália Sapucaia on 26/06/23.
//

import SwiftUI

struct SeriesDetailsView: View {
    @StateObject var viewModel: SeriesDetailsViewModel

    init(viewModel: SeriesDetailsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        viewModel.onAppear()
    }

    var body: some View {
        let imageURL = URL(string: viewModel.seriesDetails.image?.original ?? "")
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }

                NameView(name: viewModel.seriesDetails.name)
                Divider()
                    .background(.gray)
                    .padding([.leading, .trailing])
                GenresView(genres: viewModel.seriesDetails.genres)
                NewEpisodesView(days: viewModel.parseScheduleDays(days: viewModel.seriesDetails.schedule.days), time: viewModel.seriesDetails.schedule.time)
                Divider()
                    .background(.gray)
                    .padding([.leading, .trailing])
                SummaryView(summary: viewModel.parseHTMLToPlainString(html: viewModel.seriesDetails.summary ?? ""))
                Divider()
                    .background(.gray)
                    .padding([.leading, .trailing])
                EpisodesView(viewModel: viewModel)
            }
        }
//        .navigationBarTitleDisplayMode(.inline)
        .background(
            Color("DarkBlue")
        )
        .navigationBarBackground()

    }
}
struct NameView: View {
    var name: String

    var body: some View {
        Text(name)
            .font(.title)
            .bold()
            .foregroundColor(.white)
            .padding(.leading)
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
            .foregroundColor(.white)
            .padding(.leading)
    }
}

struct GenresView: View {
    var genres: [String]

    var body: some View {
        HStack {
            ForEach(Array(genres.enumerated()), id: \.1) { index, genre in
                Text("\(genre)\(index != genres.count - 1 ? " •" : "")")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
        }
        .padding(.leading)
    }
}

struct SummaryView: View {
    var summary: String?

    var body: some View {
        Text("Summary")
            .font(.title2)
            .foregroundColor(.white)
            .padding(.leading)

        Text(summary ?? "")
            .font(.body)
            .padding([.leading, .trailing])
            .multilineTextAlignment(.leading)
            .foregroundColor(.white)

    }
}

struct EpisodesView: View {
    var viewModel: SeriesDetailsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.groupedEpisodes.keys.sorted(), id: \.self) { season in
                VStack(alignment: .leading) {
                    Text("Season \(season)")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()

                    ForEach(viewModel.groupedEpisodes[season] ?? [], id: \.self) { episode in
                        NavigationLink(destination: EpisodeDetailsView(viewModel: EpisodeDetailsViewModel(seriesId: viewModel.seriesDetails.id, season: episode.season, number: episode.number))) {
                            HStack {
                                Text("\(episode.number). \(episode.name)")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding(.leading)
                                    .padding(.top, 2)
                            }
                        }
                        Divider()
                            .background(.gray)
                            .padding([.leading, .trailing])
                    }
                }
                .padding(.vertical, 10)
            }
        }
    }
}
