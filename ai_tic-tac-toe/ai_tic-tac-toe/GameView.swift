//
//  GameView.swift
//  ai_tic-tac-toe
//
//  Created by Arthur Nsereko Kahwa on 5/28/24.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            LazyVGrid(columns: viewModel.columns, spacing: 4) {
                ForEach(0..<9) { position in
                    ZStack {
                        Circle()
                            .foregroundStyle(.blue).opacity(0.8)
                        
                        Image(systemName: viewModel.moves[position]?.indicator ?? "")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundStyle(.white)
                    }
                    .onTapGesture {
                        viewModel.processPlayerMove(for: position)
                    }
                }
            }
        }
        .disabled(viewModel.isGameBoardDisabled)
        .padding()
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: .default(alertItem.buttonTitle,
                                          action: { viewModel.resetGame() })
            )
        }
    }
}

#Preview {
    GameView()
}
