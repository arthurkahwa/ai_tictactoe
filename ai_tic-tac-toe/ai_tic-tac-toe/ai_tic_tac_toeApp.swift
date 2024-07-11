//
//  ai_tic_tac_toeApp.swift
//  ai_tic-tac-toe
//
//  Created by Arthur Nsereko Kahwa on 5/28/24.
//

import SwiftUI
import SwiftData

@Model
class Foo {
    var name: String
    var birthDay: Date
    
    init(name: String, birthDay: Date) {
        self.name = name
        self.birthDay = birthDay
    }
}

@main
struct ai_tic_tac_toeApp: App {
    var body: some Scene {
        WindowGroup {
            GameView()
        }
    }
}
