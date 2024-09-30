//
//  ContentView.swift
//  CineTrackSwiftUI
//
//  Created by John on 26/09/24.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @State private var segment = Sections.popular
    @StateObject private var viewModel = ViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest private var movies: FetchedResults<Movie>
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    init() {
        _movies = FetchRequest(
            entity: Movie.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "segment == %@", Sections.popular.segmentName),
            animation: .default
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(movies) { movie in
                            
                            NavigationLink {
                                MovieDetailView(movieId: Int(movie.id))
                            } label: {
                                MoviePosterView(posterPath: movie.posterPath ?? "")
                                    .frame(height: 150)
                            }

                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("\(segment.description) Movies")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ToolBarItemView(segment: $segment)
                }
            }
        }
        .onAppear {
            fetchMovies()
        }
        .onChange(of: segment) { newSegment in
            updateFetchRequest(for: newSegment)
            fetchMovies()
        }
    }
    
    private func fetchMovies() {
        viewModel.fetchMoviesIfNeeded(segment: segment, viewContext: viewContext)
    }
    
    private func updateFetchRequest(for newSegment: Sections) {
        movies.nsPredicate = NSPredicate(format: "segment == %@", newSegment.segmentName)
    }
}
#Preview {
    HomeView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
