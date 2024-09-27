//
//  Persistence.swift
//  CineTrackSwiftUI
//
//  Created by John on 26/09/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // Modo preview para SwiftUI
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true) // Banco de dados em memória
        let viewContext = result.container.viewContext
        
        // Adiciona dados de exemplo para visualização no preview
        for i in 0..<5 {
            let movie = Movie(context: viewContext)
            movie.originalTitle = "Title: \(i)"
            movie.overview = "Overview: \(i)"
            movie.releaseDate = "Release Date: \(i)"
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()

}
