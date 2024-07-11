//
//  ViewModel.swift
//  ai_tic-tac-toe
//
//  Created by Arthur Nsereko Kahwa on 5/31/24.
//

import SwiftUI
import SwiftData

@Observable
final class ViewModel {
    var columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    var moves: [Move?] = Array(repeating: nil, count: 9)
    var isGameBoardDisabled = false
    var alertItem: AlertItem?
    var message = ""
    var computerScore = 0
    var humanScore = 0
    var drawScore = 0
    var pieChrtData: [PieChartValue] = []
        
    let modelContainer = try! ModelContainer(for: GameScore.self)
    
    init() {
        Task {
            await updateLeaderBoard()
        }
    }
    
    @MainActor
    private func fetchScores(for player: Player, isDraw: Bool = false) async -> Int {
        do {
            var scoreQuery = FetchDescriptor<GameScore>()
            scoreQuery.includePendingChanges = true
            let results = try modelContainer.mainContext.fetch(scoreQuery)
            let playerResults = results
                .filter { $0.player == player }
                .filter { $0.draw == isDraw }
            let scores = playerResults.reduce(0) { $0 + $1.value }
            
            return scores
        }
        catch {
            dump(error)
            return 0
        }
    }
    
    private func updateLeaderBoard() async {
        humanScore = await fetchScores(for: .human)
        computerScore = await fetchScores(for: .computer)
        
        drawScore = await fetchScores(for: .human, isDraw: true)
        
        pieChrtData = [
            .init(playerName: Player.human.name, value: humanScore ),
            .init(playerName: Player.computer.name, value: computerScore),
            .init(playerName: "Draws", value: drawScore)
        ]
    }
    
    @MainActor
    private func addScore(for player: Player, isDraw draw: Bool = false) async {
        let score = GameScore(timestamp: .now, player: player, value: 1, draw: draw)
        modelContainer.mainContext.insert(score)
        
        await updateLeaderBoard()
    }
    
    func processPlayerMove(for position: Int) async {
        if isSquareOccupied(for: moves, atIndex: position) { return  }
        
        moves[position] = .init(player: .human, boardIndex: position)
        
        if checkWinCondition(for: .human, in: moves) {
            await addScore(for: .human)
            
            alertItem = AlertContext.humanWin
            
            return
        }
        
        if checkForDraw(in: moves) {
            await addScore(for: .human,isDraw: true)
            await addScore(for: .computer, isDraw: true)
            
            alertItem = AlertContext.draw
            
            return
        }
        
        isGameBoardDisabled = true
        
        
        try! await Task.sleep(nanoseconds: 500_000_000)
        
        let computerPosition = determineComputerMovePosition(in: moves)
        
        moves[computerPosition] = .init(player: .computer,
                                        boardIndex: computerPosition)
        
        isGameBoardDisabled = false
        
        if checkWinCondition(for: .computer, in: moves) {
            Task {
                await addScore(for: .computer)
            }
            
            alertItem = AlertContext.computerWin
            
            return
        }
        
        if checkForDraw(in: moves) {
            await addScore(for: .human,isDraw: true)
            await addScore(for: .computer, isDraw: true)
            
            alertItem = AlertContext.draw
            
            return
        }
    }
    
    func isSquareOccupied(for moves: [Move?], atIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        // AI tries to win
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let computerMoves = moves
            .compactMap { $0 }
            .filter {  $0.player == .computer }
        
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                let isPositionAvailable = !isSquareOccupied(for: moves, atIndex: winPositions.first!)
                
                if isPositionAvailable { return winPositions.first! }
            }
        }
        
        // AI tries to block move
        let humanMoves = moves
            .compactMap { $0 }
            .filter {  $0.player == .human }
        
        let humanPosition = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPosition)
            
            if winPositions.count == 1 {
                let isPositionAvailable = !isSquareOccupied(for: moves, atIndex: winPositions.first!)
                
                if isPositionAvailable { return winPositions.first! }
            }
        }
        
        // AI tries to take middle square
        let centerSquare = 4
        if !isSquareOccupied(for: moves, atIndex: centerSquare) {
            return centerSquare
        }
        
        // AI takes a random position
        var movePosition: Int = .random(in: 0..<9)
        
        while isSquareOccupied(for: moves, atIndex: movePosition) {
            movePosition = .random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves
            .compactMap { $0 }
            .filter {  $0.player == player }
        
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
