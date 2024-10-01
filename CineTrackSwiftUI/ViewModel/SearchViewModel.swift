//
//  SearchViewModel.swift
//  CineTrackSwiftUI
//
//  Created by John on 01/10/24.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchResults: [MovieJSON] = []
    @Published var isLoading = false
    
    func search(query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        isLoading = true
        
        ServiceManager.shared.search(with: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let movies):
                    self?.searchResults = movies
                case .failure(let error):
                    print("Search error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func clearResults() {
        searchResults = []
    }
}
