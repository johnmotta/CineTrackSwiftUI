//
//  Cast.swift
//  CineTrackSwiftUI
//
//  Created by John on 30/09/24.
//

import Foundation

struct Credits: Codable {
    let cast: [Cast]
}

struct Cast: Codable {
    let name: String
    let character: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case name
        case character
        case profilePath = "profile_path"
    }
}
