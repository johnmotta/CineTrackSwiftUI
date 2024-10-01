//
//  Sections.swift
//  CineTrackSwiftUI
//
//  Created by John on 27/09/24.
//

import Foundation

enum Sections: Int, CaseIterable {
    case upcoming
    case popular
    case topRated
    
    var description: String {
        switch self {
        case .upcoming:
            return "Por vir"
        case .popular:
            return "Popular"
        case .topRated:
            return "Mais votados"
        }
    }
    
    var segmentName: String {
        switch self {
        case .upcoming:
            return "upcoming"
        case .popular:
            return "popular"
        case .topRated:
            return "top_rated"
        }
    }
}
