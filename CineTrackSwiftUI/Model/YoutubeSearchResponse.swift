//
//  YoutubeSearchResponse.swift
//  CineTrackSwiftUI
//
//  Created by John on 02/10/24.
//

import Foundation

struct YoutubeSearchResponse: Decodable {
    let items: [VideoElement]
}

struct VideoElement: Decodable {
    let id: IdVideoElement
}

struct IdVideoElement: Decodable {
    let kind: String
    let videoId: String
}
