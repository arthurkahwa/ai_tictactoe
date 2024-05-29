//
//  Alerts.swift
//  ai_tic-tac-toe
//
//  Created by Arthur Nsereko Kahwa on 5/29/24.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"),
                                    message: Text("Your smarts are unbeatable."),
                                    buttonTitle: Text("Yeah!!"))
    
    static let computerWin = AlertItem(title: Text("AI Wio!"),
                                       message: Text("Cyberdyne would be proud.."),
                                       buttonTitle: Text("Oooops!!"))
    
    static let draw = AlertItem(title: Text("No one Wio!"),
                                message: Text("Find a compromise"),
                                buttonTitle: Text("Oh well!"))
}
