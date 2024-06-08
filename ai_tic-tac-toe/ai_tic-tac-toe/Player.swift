//
//  Player.swift
//  ai_tic-tac-toe
//
//  Created by Arthur Nsereko Kahwa on 5/28/24.
//

import Foundation

enum Player: Codable {
    case human, computer
    
    var name: String {
        switch self {
        case .human:
            return "Human Player"
        case .computer:
            return "The AI"
        }
    }
}
