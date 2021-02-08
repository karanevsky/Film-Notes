//
//  Film_NotesApp.swift
//  Film Notes
//
//  Created by Dmitry Karanevsky on 7.02.21.
//

import SwiftUI

@main
struct Film_NotesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
