//
//  Score.swift
//  ai_tic-tac-toe
//
//  Created by Arthur Nsereko Kahwa on 5/31/24.
//

import Foundation
import SwiftData

@Model
class Score {
    var timestamp: Date
    var player: Player
    var value: Int
    
    init(timestamp: Date, player: Player, value: Int) {
        self.timestamp = timestamp
        self.player = player
        self.value = value
    }
}
