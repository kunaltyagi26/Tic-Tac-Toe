//
//  GameView.swift
//  Tic-Tac-Toe
//
//  Created by Kunal Tyagi on 03/05/21.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                LazyVGrid(columns: viewModel.columns, spacing: 5, content: {
                    ForEach(0..<9) { index in
                        ZStack {
                            GameSquareView(proxy: geometry)
                            
                            if let imageName = viewModel.moves[index]?.indicator {
                                PlayerIndicator(systemImageName: imageName, proxy: geometry)
                            }
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: index)
                        }
                    }
                })
                
                Spacer()
            }
            .disabled(viewModel.isGameBoardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: {
                    viewModel.resetGame()
                }))
            }
        }
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .preferredColorScheme(.dark)
    }
}

struct GameSquareView: View {
    var proxy: GeometryProxy
    
    var body: some View {
        Circle()
            .foregroundColor(.red)
            .opacity(0.8)
            .frame(width: proxy.size.width / 3 - 15, height: proxy.size.width / 3 - 15)
            .zIndex(1.0)
    }
}

struct PlayerIndicator: View {
    var systemImageName: String
    var proxy: GeometryProxy
    
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: proxy.size.width / 10, height: proxy.size.width / 10)
            .foregroundColor(.white)
            .zIndex(2.0)
            .animation(.interactiveSpring())
    }
}
