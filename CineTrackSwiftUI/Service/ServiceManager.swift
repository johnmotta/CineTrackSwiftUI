//
//  ServiceManager.swift
//  CineTrackSwiftUI
//
//  Created by John on 26/09/24.
//

import Foundation

class ServiceManager: ServiceManagerProtocol {
    
    static let shared = ServiceManager()
    
    private func buildURL(baseURL: String, endpoint: String, api: String, queryItems: [URLQueryItem]) -> URL? {
        let deviceLanguage = Locale.preferredLanguages.first ?? "en-US"
        var components = URLComponents(string: "\(baseURL)/3/\(endpoint)")
        
        var allQueryItems = [
            URLQueryItem(name: "api_key", value: api),
            URLQueryItem(name: "language", value: deviceLanguage)
        ]
        allQueryItems.append(contentsOf: queryItems)
        components?.queryItems = allQueryItems
        return components?.url
    }
    
    private func fetchData<T: Decodable>(baseURL: String, endpoint: String, api: String, additionalQueryItems: [URLQueryItem] = [], completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = buildURL(baseURL: baseURL, endpoint: endpoint, api: api, queryItems: additionalQueryItems) else {
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
    
    func getMovie(segment: Sections, completion: @escaping (Result<[MovieJSON], NetworkError>) -> Void) {
        let endpoint: String
        endpoint = "movie/\(segment.description)"
        let additionalQueryItems = [URLQueryItem(name: "page", value: "1")]
        fetchData(baseURL: Constants.baseURL, endpoint: endpoint, api: Constants.API, additionalQueryItems: additionalQueryItems) { (result: Result<MoviesResponse, NetworkError>) in
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
        fetchData(baseURL: Constants.baseURL, endpoint: endpoint, api: Constants.API, completion: completion)
    }
    
    func fetchMovieCast(movieId: Int, completion: @escaping (Result<[Cast], NetworkError>) -> Void) {
        let endpoint = "movie/\(movieId)/credits"
        fetchData(baseURL: Constants.baseURL, endpoint: endpoint, api: Constants.API) { (result: Result<Credits, NetworkError>) in
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
        fetchData(baseURL: Constants.baseURL, endpoint: endpoint, api: Constants.API, additionalQueryItems: additionalQueryItems) { (result: Result<MoviesResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getYoutubeTrailer(with query: String, completion: @escaping (Result<VideoElement, NetworkError>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let urlString = "\(Constants.youtubeBaseURL)q=\(encodedQuery)&key=\(Constants.youtubeAPI)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL(urlString)))
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
                let result = try decoder.decode(YoutubeSearchResponse.self, from: data)
                completion(.success(result.items[0]))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
    }
}
