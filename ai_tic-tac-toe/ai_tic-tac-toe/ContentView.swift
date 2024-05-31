//
//  ContentView.swift
//  ai_tic-tac-toe
//
//  Created by Arthur Nsereko Kahwa on 5/28/24.
//

import SwiftUI

struct ContentView: View {
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameBoardDisabled = false
    @State private var alertItem: AlertItem?
    
    var columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(0..<9) { j in
                    ZStack {
                        Circle()
                            .foregroundStyle(.blue).opacity(0.8)
                        //                                .frame(width: geometry.size.width / 3 - 8,
                        //                                       height: geometry.size.height / 3 - 96)
                        
                        Image(systemName: moves[j]?.indicator ?? "")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundStyle(.white)
                    }
                    .onTapGesture {
                        if isSquareOccupied(for: moves, atIndex: j) { return  }
                        
                        moves[j] = .init(player: .human, boardIndex: j)
                        
                        if checkWinCondition(for: .human, in: moves) {
                            alertItem = AlertContext.humanWin
                            
                            return
                        }
                        
                        if checkForDraw(in: moves) {
                            alertItem = AlertContext.draw
                            
                            return
                        }
                        
                        isGameBoardDisabled = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            let computerPosition = determineComputerMovePosition(in: moves)
                            
                            moves[computerPosition] = .init(player: .computer,
                                                            boardIndex: computerPosition)
                            
                            isGameBoardDisabled = false
                            
                            if checkWinCondition(for: .computer, in: moves) {
                                alertItem = AlertContext.computerWin
                                
                                return
                            }
                            
                            if checkForDraw(in: moves) {
                                alertItem = AlertContext.draw
                                
                                return
                            }
                        }
                    }
                }
            }
        }
        .disabled(isGameBoardDisabled)
        .padding()
        .alert(item: $alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: .default(alertItem.buttonTitle,
                                          action: { resetGame() })
            )
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
        if isSquareOccupied(for: moves, atIndex: centerSquare) {
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

#Preview {
    ContentView()
}
