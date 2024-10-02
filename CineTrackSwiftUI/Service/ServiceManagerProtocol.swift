//
//  ServiceManagerProtocol.swift
//  CineTrackSwiftUI
//
//  Created by John on 26/09/24.
//

import Foundation

protocol ServiceManagerProtocol {
    func getMovie(segment: String, completion: @escaping (Result<[MovieJSON], NetworkError>) -> Void)
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetail, NetworkError>) -> Void)
    func fetchMovieCast(movieId: Int, completion: @escaping (Result<[Cast], NetworkError>) -> Void)
    func search(with query: String, completion: @escaping (Result<[MovieJSON], NetworkError>) -> Void)
}
