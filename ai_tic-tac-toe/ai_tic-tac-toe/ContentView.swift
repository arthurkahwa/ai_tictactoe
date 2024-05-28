//
//  ContentView.swift
//  ai_tic-tac-toe
//
//  Created by Arthur Nsereko Kahwa on 5/28/24.
//

import SwiftUI

struct ContentView: View {
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isHumansTurn = true
    
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
                        moves[j] = .init(player: isHumansTurn ? .human : .computer,
                                         boardIndex: j)
                        
                        isHumansTurn.toggle()
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
