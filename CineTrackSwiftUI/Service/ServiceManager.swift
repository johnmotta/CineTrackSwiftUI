//
//  ServiceManager.swift
//  CineTrackSwiftUI
//
//  Created by John on 26/09/24.
//

import Foundation

class ServiceManager: ServiceManagerProtocol {
    
    static let shared = ServiceManager()
    
    private func buildURL(endpoint: String, queryItems: [URLQueryItem]) -> URL? {
        let deviceLanguage = Locale.preferredLanguages.first ?? "en-US"
        var components = URLComponents(string: "\(Constants.baseURL)/3/\(endpoint)")
        
        var allQueryItems = [
            URLQueryItem(name: "api_key", value: Constants.API),
            URLQueryItem(name: "language", value: deviceLanguage)
        ]
        allQueryItems.append(contentsOf: queryItems)
        components?.queryItems = allQueryItems
        return components?.url
    }
    
    private func fetchData<T: Decodable>(endpoint: String, additionalQueryItems: [URLQueryItem] = [], completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = buildURL(endpoint: endpoint, queryItems: additionalQueryItems) else {
            completion(.failure(.invalidURL(endpoint)))
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.networkFailure(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
    }
    
    func getMovie(segment: String, completion: @escaping (Result<[MovieJSON], NetworkError>) -> Void) {
        let endpoint: String
        switch segment.lowercased() {
        case "popular", "upcoming", "top_rated":
            endpoint = "movie/\(segment)"
        default:
            completion(.failure(.invalidURL("Invalid segment: \(segment)")))
            return
        }
        
        let additionalQueryItems = [URLQueryItem(name: "page", value: "1")]
        fetchData(endpoint: endpoint, additionalQueryItems: additionalQueryItems) { (result: Result<MoviesResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetail, NetworkError>) -> Void) {
        let endpoint = "movie/\(movieId)"
        fetchData(endpoint: endpoint, completion: completion)
    }
    
    func fetchMovieCast(movieId: Int, completion: @escaping (Result<[Cast], NetworkError>) -> Void) {
        let endpoint = "movie/\(movieId)/credits"
        fetchData(endpoint: endpoint) { (result: Result<Credits, NetworkError>) in
            switch result {
            case .success(let credits):
                completion(.success(credits.cast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func search(with query: String, completion: @escaping (Result<[MovieJSON], NetworkError>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let endpoint = "search/movie"
        let additionalQueryItems = [URLQueryItem(name: "query", value: encodedQuery)]
        fetchData(endpoint: endpoint, additionalQueryItems: additionalQueryItems) { (result: Result<MoviesResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
