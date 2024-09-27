//
//  MovieProtocol.swift
//  CineTrackSwiftUI
//
//  Created by John on 26/09/24.
//

import Foundation

protocol MovieProtocol {
    func getMovie(segment: String, completion: @escaping (Result<[MovieJSON], NetworkError>) -> Void)
}
