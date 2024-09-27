//
//  ContentView.swift
//  CineTrackSwiftUI
//
//  Created by John on 26/09/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default
    )
    var movies: FetchedResults<Movie>
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Popular")
                    .font(.title)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(movies) { movie in
                            MoviePosterView(posterPath: movie.posterPath ?? "")
                                .frame(height: 150)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                viewModel.fetchMoviesIfNeeded(movies: movies, viewContext: viewContext)
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
