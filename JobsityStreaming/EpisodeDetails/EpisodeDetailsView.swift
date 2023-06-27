//
//  EpisodeDetailsView.swift
//  JobsityStreaming
//
//  Created by Natália Sapucaia on 27/06/23.
//

import SwiftUI

struct EpisodeDetailsView: View {
    @StateObject var viewModel: EpisodeDetailsViewModel

    var body: some View {
        VStack {

            Text(viewModel.episodeDetails?.name ?? "")
            Text(viewModel.episodeDetails?.summary ?? "")
            Text("Season \(viewModel.episodeDetails?.season ?? 0)")
            Text("Episode number \(viewModel.episodeDetails?.number ?? 0)")
        }
        .onAppear{
            viewModel.onAppear()
        }

    }
}
