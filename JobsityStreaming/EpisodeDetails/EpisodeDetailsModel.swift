//
//  EpisodeDetailsModel.swift
//  JobsityStreaming
//
//  Created by Natália Sapucaia on 27/06/23.
//

import Foundation

struct EpisodeDetailsModel: Codable, Equatable {
    static func == (lhs: EpisodeDetailsModel, rhs: EpisodeDetailsModel) -> Bool {
        lhs.id == rhs.id
    }

    let id: Int
    let name: String
    let number: Int
    let season: Int
    let summary: String
    let image: Images?
}
