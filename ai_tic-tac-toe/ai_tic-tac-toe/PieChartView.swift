//
//  PieChartView.swift
//  ai_tic-tac-toe
//
//  Created by Arthur Nsereko Kahwa on 6/7/24.
//

import SwiftUI
import Charts

struct PieChartView: View {
    @Environment(\.dismiss) private var dismiss
    
    var piechartValues: [PieChartValue]
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    ForEach(piechartValues) { element in
                        HStack {
                            Text(element.playerName)
                                .font(.title)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text("\(element.value)")
                                .font(.title)
                                .fontWeight(.black)
                        }
                    }
                }
                .padding()
                
                Chart {
                    ForEach(piechartValues, id: \.playerName) { element in
                        SectorMark(angle: .value("Score", element.value),
                                   innerRadius: .ratio(0.4),
                                   angularInset: 1)
                        .cornerRadius(8)
                            .foregroundStyle(by: .value("Player", element.playerName))
                    }
                    
                }
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 32, height: 32)))
                .padding()
                .padding(.bottom, 16)
                
                Spacer()
            }
            .navigationTitle("Game Stats")
            .border(.secondary)
            .padding()
            
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "arrow.down.right.and.arrow.up.left")
                    .resizable()
                    .foregroundStyle(.background)
                    .frame(width: 48, height: 48)
                    .buttonStyle(.borderedProminent)
            })
            .padding()
            .background(.orange)
            .clipShape(Circle())
        }
    }
}

#Preview {
    PieChartView(piechartValues: [.init(playerName: "Human", value: 24),
                                  .init(playerName: "The AI", value: 4),
                                  .init(playerName: "Draws", value: 12)])
}
