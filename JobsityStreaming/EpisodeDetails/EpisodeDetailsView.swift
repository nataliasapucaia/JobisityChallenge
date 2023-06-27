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
        }
        .onAppear{
            viewModel.onAppear()
        }

    }
}
