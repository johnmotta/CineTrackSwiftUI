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
}
