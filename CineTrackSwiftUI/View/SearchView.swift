//
//  SearchView.swift
//  CineTrackSwiftUI
//
//  Created by John on 01/10/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var searchQuery = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchQuery, onSearchButtonClicked: performSearch)
                
                if searchViewModel.isLoading {
                    ProgressView()
                } else {
                    GeometryReader { geometry in
                        ScrollView {
                            let width = geometry.size.width
                            let itemWidth = (width - 30) / 2
                            
                            LazyVGrid(columns: [GridItem(.fixed(itemWidth)), GridItem(.fixed(itemWidth))], spacing: 10) {
                                ForEach(searchViewModel.searchResults, id: \.id) { movie in
                                    NavigationLink {
                                        MovieDetailView(movieId: movie.id)
                                    } label: {
                                        MoviePosterView(posterPath: movie.posterPath ?? "", width: itemWidth)
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Pesquisar Filmes")
            .navigationBarTitleDisplayMode(.large)
        }
        .onChange(of: searchQuery) { newValue in
            if newValue.isEmpty {
                searchViewModel.clearResults()
            }
        }
    }
    
    private func performSearch() {
        searchViewModel.search(query: searchQuery)
    }
}


#Preview {
    SearchView()
}
