//
//  MovieDetailView.swift
//  CineTrackSwiftUI
//
//  Created by John on 30/09/24.
//

import SwiftUI

struct MovieDetailView: View {
    @State private var movieDetail: MovieDetail?
    @State private var movieCast: [Cast] = []
    
    let movieId: Int
    
    var body: some View {
        VStack {
            if let movieDetail = movieDetail {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movieDetail.backdropPath ?? "")"))
                    .scaledToFit()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(movieDetail.title)
                            .font(.title2)
                            .bold()
                        
                        Text(movieDetail.releaseDate.prefix(4))
                            .padding(.leading, 5)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("\(movieDetail.runtime ?? 0)m")
                        Text(" | ")
                        Text(movieDetail.genres.map { $0.name }.joined(separator: ", "))
                    }
                    .padding(.horizontal)
                    .lineLimit(2)
                    ScrollView {

                    Divider()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(movieCast.prefix(10), id: \.name) { cast in
                                VStack {
                                    if let profilePath = cast.profilePath {
                                        AsyncImage(
                                            url: URL(string: "https://image.tmdb.org/t/p/w185\(profilePath)")
                                        ) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 150)
                                                .cornerRadius(8)
                                        } placeholder: {
                                            Color.gray
                                                .frame(width: 100, height: 150)
                                                .cornerRadius(8)
                                        }
                                    } else {
                                        // Caso o ator não tenha imagem
                                        Color.gray
                                            .frame(width: 100, height: 150)
                                            .cornerRadius(8)
                                    }
                                    
                                    Text(cast.name)
                                        .font(.caption)
                                        .frame(width: 100)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(cast.character)
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                        .frame(width: 100)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    Divider()
                    
                        Text(movieDetail.overview)
                            .padding(.bottom, 20)
                            .padding(.horizontal)
                    }
                }
            } else {
                Text("Carregando detalhes do filme...")
                
            }
        }
        .onAppear {
            ServiceManager.shared.fetchMovieDetails(movieId: movieId) { result in
                switch result {
                case .success(let details):
                    DispatchQueue.main.async {
                        self.movieDetail = details
                    }
                case .failure(let error):
                    print("Erro ao carregar detalhes do filme: \(error)")
                }
            }
            
            ServiceManager.shared.fetchMovieCast(movieId: movieId) { result in
                switch result {
                case .success(let cast):
                    DispatchQueue.main.async {
                        self.movieCast = cast
                    }
                case .failure(let error):
                    print("Erro ao carregar elenco: \(error)")
                }
            }
        }
    }
}

#Preview {
    MovieDetailView(movieId: 0)
}
