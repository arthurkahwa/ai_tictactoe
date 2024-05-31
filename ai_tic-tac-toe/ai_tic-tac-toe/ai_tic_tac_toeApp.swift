//
//  ai_tic_tac_toeApp.swift
//  ai_tic-tac-toe
//
//  Created by Arthur Nsereko Kahwa on 5/28/24.
//

import SwiftUI
import SwiftData

@main
struct ai_tic_tac_toeApp: App {
    
    let container: ModelContainer = {
        let schema = Schema([Score.self])
        
        let modelContainer = try! ModelContainer(for: schema, configurations: [])
        
        return modelContainer
    }()
    
    var body: some Scene {
        WindowGroup {
            GameView()
        }
        .modelContainer(container)
    }
}
