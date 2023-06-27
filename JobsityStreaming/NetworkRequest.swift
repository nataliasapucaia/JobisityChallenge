//
//  NetworkRequest.swift
//  JobsityStreaming
//
//  Created by Natália Sapucaia on 26/06/23.
//

import Foundation

class NetworkRequest {
    public func fetchSeries() async throws -> [SeriesModel] {
        guard let url = URL(string: "https://api.tvmaze.com/shows?page=0") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([SeriesModel].self, from: data)
    }

    public func fetchEpisodes(with id: Int) async throws -> [EpisodesModel] {
        guard let url = URL(string: "https://api.tvmaze.com/shows/\(id)/episodes") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([EpisodesModel].self, from: data)
    }

}
