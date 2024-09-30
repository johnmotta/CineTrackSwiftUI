//
//  MoviePosterView.swift
//  CineTrackSwiftUI
//
//  Created by John on 27/09/24.
//

import SwiftUI

struct MoviePosterView: View {
    let posterPath: String
    var width: CGFloat = 100
    var height: CGFloat = 150
    @State private var image: UIImage? = nil
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .cornerRadius(8)
            } else {
                ProgressView()
                    .frame(width: 100, height: 150)
                    .cornerRadius(8)
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    private func loadImage() {
        if let cachedImage = ImageCache.shared.getImage(forKey: posterPath) {
            self.image = cachedImage
        } else {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
            
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let downloadedImage = UIImage(data: data) {
                    ImageCache.shared.saveImage(downloadedImage, forKey: posterPath)
                    DispatchQueue.main.async {
                        self.image = downloadedImage
                    }
                }
            }.resume()
        }
    }
}

class ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    private var cache = NSCache<NSString, UIImage>()
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func saveImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

