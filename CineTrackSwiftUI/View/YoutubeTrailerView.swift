//
//  YoutubeTrailerView.swift
//  CineTrackSwiftUI
//
//  Created by John on 02/10/24.
//

import SwiftUI
import WebKit

struct YoutubeTrailerView: View {
    @Environment(\.dismiss) var dismiss
    let title: String
    @State private var youtubeURL: URL?
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .bold()
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    Text("Voltar")
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                }
            }
            .padding(.top)
            .padding(.leading)
            
            if let url = youtubeURL {
                WebView(url: url)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            Spacer()
        }
        .onAppear {
            ServiceManager.shared.getYoutubeTrailer(with: "\(title) trailer") { result in
                switch result {
                case .success(let videoElement):
                    let videoURLString = "https://www.youtube.com/embed/\(videoElement.id.videoId)"
                    if let url = URL(string: videoURLString) {
                        DispatchQueue.main.async {
                            youtubeURL = url
                        }
                    }
                case .failure(let error):
                    print("Erro ao carregar o trailer: \(error)")
                }
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
