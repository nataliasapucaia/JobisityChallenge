//
//  EpisodeDetailsView.swift
//  JobsityStreaming
//
//  Created by Natália Sapucaia on 27/06/23.
//

import SwiftUI

struct EpisodeDetailsView: View {
    @StateObject var viewModel: EpisodeDetailsViewModel

    init(viewModel: EpisodeDetailsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        viewModel.onAppear()
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    if let episodeDetails = viewModel.episodeDetails {
                        EpisodeImageView(imageURL: episodeDetails.image?.original ?? "")
                        EpisodeNameView(season: episodeDetails.season, number: episodeDetails.number, name: episodeDetails.name)
                        EpisodeSummaryView(summary: viewModel.parseHTMLToPlainString(html: episodeDetails.summary) ?? "")

                    }
                }
//                .background(
//                    Color("DarkBlue").edgesIgnoringSafeArea(.all)
//                )
            }

            .navigationBarBackground()
        }
        .background(
            Color("DarkBlue").edgesIgnoringSafeArea(.all)
        )

    }
}

struct EpisodeImageView: View {
    var imageURL: String

    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
        }

    }
}

struct EpisodeNameView: View {
    var season: Int
    var number: Int
    var name: String

    var body: some View {
        Text("S\(season):\(number) \(name)")
            .font(.title)
            .foregroundColor(.white)
            .padding(.bottom)

    }
}

struct EpisodeSummaryView: View {
    var summary: String

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
