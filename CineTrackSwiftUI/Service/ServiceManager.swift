//
//  ServiceManager.swift
//  CineTrackSwiftUI
//
//  Created by John on 26/09/24.
//

import Foundation

class ServiceManager: MovieProtocol {
    
    static let shared = ServiceManager()
    
    func getMovie(segment: String, completion: @escaping (Result<[MovieJSON], NetworkError>) -> Void) {
        let deviceLanguage = Locale.preferredLanguages.first ?? "en-US"
        let urlString = "\(Constants.baseURL)/3/movie/\(segment)?api_key=\(Constants.API)&language=\(deviceLanguage)&page=1"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL(urlString)))
            return
        }
        
        let session = URLSession.shared
                
        let task = session.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(.networkFailure(error)))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(MoviesResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
    }

    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetail, NetworkError>) -> Void) {
        let deviceLanguage = Locale.preferredLanguages.first ?? "en-US"
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(Constants.API)&language=\(deviceLanguage)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL(urlString)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkFailure(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let movieDetails = try JSONDecoder().decode(MovieDetail.self, from: data)
                completion(.success(movieDetails))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }

    
    func fetchMovieCast(movieId: Int, completion: @escaping (Result<[Cast], NetworkError>) -> Void) {
        let deviceLanguage = Locale.preferredLanguages.first ?? "en-US"
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=\(Constants.API)&language=\(deviceLanguage)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL(urlString)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkFailure(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let credits = try JSONDecoder().decode(Credits.self, from: data)
                completion(.success(credits.cast))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }

}
