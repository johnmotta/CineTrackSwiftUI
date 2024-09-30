//
//  MovieDetail.swift
//  CineTrackSwiftUI
//
//  Created by John on 30/09/24.
//

import Foundation

struct MovieDetail: Codable {
    let title: String
    let genres: [Genre]
    let releaseDate: String
    let runtime: Int?
    let overview: String
    let backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case genres
        case releaseDate = "release_date"
        case runtime
        case overview
        case backdropPath = "backdrop_path"
    }
}

struct Genre: Codable {
    let name: String
}
