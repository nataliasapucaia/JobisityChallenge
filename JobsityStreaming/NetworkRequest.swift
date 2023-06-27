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

    public func fetchSearchSeries(keyword: String) async throws -> [SearchSeriesModel] {
        guard let url = URL(string: "https://api.tvmaze.com/search/shows?q=\(keyword)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([SearchSeriesModel].self, from: data)
    }

    public func fetchEpisodes(with id: Int) async throws -> [EpisodeModel] {
        guard let url = URL(string: "https://api.tvmaze.com/shows/\(id)/episodes") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([EpisodeModel].self, from: data)
    }

    public func fetchEpisodeDetails(id: Int, season: Int, number: Int) async throws -> EpisodeDetailsModel {
        guard let url = URL(string: "https://api.tvmaze.com/shows/\(id)/episodebynumber?season=\(season)&number=\(number)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(EpisodeDetailsModel.self, from: data)
    }

}
