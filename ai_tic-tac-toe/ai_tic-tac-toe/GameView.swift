//
//  GameView.swift
//  ai_tic-tac-toe
//
//  Created by Arthur Nsereko Kahwa on 5/28/24.
//

import SwiftUI

struct GameView: View {
    @Bindable
    private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("Scores:")
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundStyle(.secondary)
                .padding(.top, 8)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Human")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("100")
                }
                
                HStack {
                    Text("Computer")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("100")
                }
            }
            .font(.title)
            .padding(.bottom, 64)
            
            
            Text("Message")
                .font(.callout)
                .padding(.bottom, 24)
            
            
            LazyVGrid(columns: viewModel.columns, spacing: 4) {
                ForEach(0..<9) { position in
                    ZStack {
                        Circle()
                            .foregroundStyle(.blue).opacity(0.8)
                            .shadow(radius: 0.4)
 
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
            .padding(.bottom, 64)
            
            Button(action: {
                viewModel.resetGame()
            }, label: {
                Image(systemName: "restart.circle.fill")
                    .resizable()
                    .foregroundStyle(.orange)
                    .frame(width: 84, height: 84)
                    .buttonStyle(.borderedProminent)
            })
        }
        .disabled(viewModel.isGameBoardDisabled)
        .padding()
        .alert(item: $viewModel.alertItem) { item in
            Alert(title: item.title,
                  message: item.message,
                  dismissButton: .default(item.buttonTitle,
                                          action: { viewModel.resetGame() })
            )
        }
    }
}

#Preview {
    GameView()
}
