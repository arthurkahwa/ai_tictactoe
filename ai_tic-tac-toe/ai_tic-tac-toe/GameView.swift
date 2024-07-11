//
//  GameView.swift
//  ai_tic-tac-toe
//
//  Created by Arthur Nsereko Kahwa on 5/28/24.
//

import SwiftUI
import SwiftData

struct GameView: View {
    @State
    private var viewModel = ViewModel()
    
    @State private var isShowingPieChart = false
    
    var body: some View {
        NavigationStack {
            Text("Scores:")
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Human")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(viewModel.humanScore)")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                }
                
                HStack {
                    Text("A.I.")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(viewModel.computerScore)")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                }
            }
            .font(.title)
            
            Text(viewModel.message)
                .font(.callout)
            
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
                        Task {
                            await viewModel.processPlayerMove(for: position)
                        }
                    }
                }
            }
            .padding(.bottom, 32)
            .navigationTitle("AI Tic-Tac-Toe")
            .sheet(isPresented: $isShowingPieChart) {
                PieChartView(piechartValues: viewModel.pieChrtData)
            }
            .toolbar(content: {
                ToolbarItem {
                    Button(action: {
                        isShowingPieChart = true
                    }, label: {
                        Image(systemName: "chart.pie.fill")
                    })
                }
            })
            
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
