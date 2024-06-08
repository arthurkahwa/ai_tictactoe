//
//  PieChartValues.swift
//  ai_tic-tac-toe
//
//  Created by Arthur Nsereko Kahwa on 6/7/24.
//

import Foundation

struct PieChartValue: Identifiable, Hashable {
    let id = UUID()
    let playerName: String
    let value: Int
}
