//
//  HomeViewModel.swift
//  CineTrackSwiftUI
//
//  Created by John on 26/09/24.
//

import SwiftUI
import CoreData

class HomeViewModel: ObservableObject {
    private func lastUpdateKey(for segment: Sections) -> String {
        return "lastUpdateDate_\(segment.segmentName)"
    }
    
    func fetchMoviesIfNeeded(segment: Sections, viewContext: NSManagedObjectContext) {
        let lastUpdateKey = self.lastUpdateKey(for: segment)
        let lastUpdate = UserDefaults.standard.object(forKey: lastUpdateKey) as? Date
        let currentDate = Date()

        let updateInterval: TimeInterval = 60 * 60 * 24

        if let lastUpdate = lastUpdate, currentDate.timeIntervalSince(lastUpdate) < updateInterval {
            print("Filmes do segmento \(segment) já estão atualizados.")
            return
        }

        fetchMoviesFromAPI(segment: segment.segmentName, viewContext: viewContext)
        UserDefaults.standard.set(currentDate, forKey: lastUpdateKey)
    }

    private func fetchMoviesFromAPI(segment: String, viewContext: NSManagedObjectContext) {
        ServiceManager.shared.getMovie(segment: segment) { result in
            switch result {
            case .success(let moviesData):
                for movieData in moviesData {
                    let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %d AND segment == %@", movieData.id, segment)
                    
                    do {
                        let existingMovies = try viewContext.fetch(fetchRequest)
                        
                        if let existingMovie = existingMovies.first {
                            if existingMovie.originalTitle != movieData.originalTitle ||
                                existingMovie.overview != movieData.overview ||
                                existingMovie.releaseDate != movieData.releaseDate ||
                                existingMovie.posterPath != movieData.posterPath {
                                existingMovie.originalTitle = movieData.originalTitle
                                existingMovie.overview = movieData.overview
                                existingMovie.releaseDate = movieData.releaseDate
                                existingMovie.posterPath = movieData.posterPath
                                
                                print("Atualizando filme existente: \(existingMovie.originalTitle ?? "Sem título")")
                            }
                        } else {
                            let newMovie = Movie(context: viewContext)
                            newMovie.id = Int64(movieData.id)
                            newMovie.originalTitle = movieData.originalTitle
                            newMovie.overview = movieData.overview
                            newMovie.releaseDate = movieData.releaseDate
                            newMovie.posterPath = movieData.posterPath
                            newMovie.segment = segment
                            
                            print("Salvando novo filme: \(newMovie.originalTitle ?? "Sem título")")
                        }
                        
                        try viewContext.save()
                        
                    } catch {
                        print("Erro ao buscar ou salvar filmes: \(error)")
                    }
                }
                
            case .failure(let error):
                print("Erro ao buscar filmes da API: \(error)")
            }
        }
    }
}
