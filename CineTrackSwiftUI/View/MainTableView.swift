//
//  MainTableView.swift
//  CineTrackSwiftUI
//
//  Created by John on 01/10/24.
//

import SwiftUI

struct MainTableView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme  

    var body: some View {
        TabView {
            Tab("Inicio", systemImage: "house") {
                HomeView()
                    .environment(\.managedObjectContext, viewContext)
            }
            
            Tab("Procurar", systemImage: "magnifyingglass") {
                SearchView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
        .accentColor(colorScheme == .dark ? .white : .black)
    }
}

#Preview {
    MainTableView()
}
