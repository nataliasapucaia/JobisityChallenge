//
//  File.swift
//  JobsityStreaming
//
//  Created by Natália Sapucaia on 26/06/23.
//

import Foundation

struct SeriesModel: Codable, Identifiable {
    let id: Int
    let name: String
    let image: ShowImage?
    let genres: [String]
    let schedule: Schedule
    let summary: String
}


struct Schedule: Codable {
    let time: String
    let days: [String]
}

struct ShowImage: Codable {
    let medium: String?
    let original: String?
}
