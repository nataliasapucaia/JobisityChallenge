//
//  EpisodeDetailsModel.swift
//  JobsityStreaming
//
//  Created by Natália Sapucaia on 27/06/23.
//

import Foundation

struct EpisodeDetailsModel: Codable {
    let id: Int
    let name: String
    let number: Int
    let season: Int
    let summary: String
    let image: EpisodeImage?
}


struct EpisodeImage: Codable {
    let medium: String?
    let original: String?
}
