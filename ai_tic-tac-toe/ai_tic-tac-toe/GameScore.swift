//
//  GameScore.swift
//  ai_tic-tac-toe
//
//  Created by Arthur Nsereko Kahwa on 6/1/24.
//

import Foundation
import SwiftData

@Model
class GameScore {
    var timestamp: Date
    var player: Player
    var value: Int
    var draw: Bool
    
    init(timestamp: Date, player: Player, value: Int, draw: Bool) {
        self.timestamp = timestamp
        self.player = player
        self.value = value
        self.draw = draw
    }
}
