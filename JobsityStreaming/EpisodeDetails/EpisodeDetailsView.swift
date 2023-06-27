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
        ScrollView {
            VStack {
                if let episodeDetails = viewModel.episodeDetails {
                    EpisodeNameView(season: episodeDetails.season, number: episodeDetails.number, name: episodeDetails.name)
                    EpisodeSummaryView(summary: viewModel.parseHTMLToPlainString(html: episodeDetails.summary) ?? "")

                    AsyncImage(url: URL(string: episodeDetails.image?.original ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
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
    }
}

struct EpisodeSummaryView: View {
    var summary: String

    var body: some View {
        Text(summary)
            .padding()
            .font(.body)
            .multilineTextAlignment(.leading)
    }
}
