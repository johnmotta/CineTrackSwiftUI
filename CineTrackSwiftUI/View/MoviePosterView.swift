//
//  MoviePosterView.swift
//  CineTrackSwiftUI
//
//  Created by John on 27/09/24.
//

import SwiftUI

struct MoviePosterView: View {
    let posterPath: String
    let width: CGFloat
    let height: CGFloat
    @State private var image: UIImage? = nil
    
    init(posterPath: String, width: CGFloat) {
        self.posterPath = posterPath
        self.width = width
        self.height = width * 1.5
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ProgressView()
            }
        }
        .frame(width: width, height: height)
        .clipped()
        .onAppear {
            loadImage()
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
