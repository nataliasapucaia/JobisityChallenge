//
//  File.swift
//  JobsityStreaming
//
//  Created by Natália Sapucaia on 26/06/23.
//

import Foundation

struct SearchSeriesModel: Codable {
    let show: SeriesModel
}

struct SeriesModel: Codable, Identifiable, Equatable {
    static func == (lhs: SeriesModel, rhs: SeriesModel) -> Bool {
        lhs.id == rhs.id
    }

    let id: Int
    let name: String
    let image: Images?
    let genres: [String]
    let schedule: Schedule
    let summary: String?
}

struct Schedule: Codable {
    let time: String
    let days: [String]
}

struct Images: Codable {
    let medium: String?
    let original: String?
}
