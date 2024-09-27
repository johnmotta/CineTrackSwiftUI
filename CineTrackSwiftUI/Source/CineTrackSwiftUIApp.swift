//
//  CineTrackSwiftUIApp.swift
//  CineTrackSwiftUI
//
//  Created by John on 26/09/24.
//

import SwiftUI
import CoreData

@main
struct CineTrackSwiftUIApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
