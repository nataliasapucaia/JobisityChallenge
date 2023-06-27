//
//  EpisodesModel.swift
//  JobsityStreaming
//
//  Created by Natália Sapucaia on 26/06/23.
//

import Foundation

struct EpisodesModel: Codable, Identifiable {
    let id: Int
    let season: Int
    let number: Int
    let name: String
}
