//
//  MovieJSON.swift
//  CineTrackSwiftUI
//
//  Created by John on 26/09/24.
//

import Foundation

struct MoviesResponse: Codable {
    let results: [MovieJSON]
}

struct MovieJSON: Codable {
    let id: Int
    let mediaType: String?
    let originalName: String?
    let originalTitle: String?
    let posterPath: String?
    let overview: String?
    let voteCount: Int?
    let releaseDate: String?
    let voteAverage: Double
    var isFavorite: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case originalName = "original_name"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case overview
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case isFavorite
    }

}
