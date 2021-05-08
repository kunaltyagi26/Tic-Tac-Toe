//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Kunal Tyagi on 08/05/21.
//

import Foundation
import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        
        /// Human move processing
        if isSquareOccupied(in: moves, forIndex: position) { return }
        withAnimation {
            moves[position] = Move(player: .human, boardIndex: position)
        }
        isGameBoardDisabled = true
        
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        /// Computer move processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            let computerPosition = self.determineComputerMovePosition(in: self.moves)
            withAnimation {
                self.moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            }
            self.isGameBoardDisabled = false
            
            if self.checkWinCondition(for: .computer, in: self.moves) {
                self.alertItem = AlertContext.computerWin
                self.isGameBoardDisabled = true
                return
            }
            
            if self.checkForDraw(in: self.moves) {
                self.alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int)-> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputerMovePosition(in moves: [Move?])-> Int {
        /// If AI can win, then win
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let computerMove = processMove(for: .computer, andWinPatterns: winPatterns)
        if computerMove != -1 {
            return computerMove
        }
        
        /// If AI can't win, then block
        let humanMove = processMove(for: .human, andWinPatterns: winPatterns)
        if humanMove != -1 {
            return humanMove
        }
        
        /// If AI can't block, then take middle square
        let centreSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centreSquare) {
            return centreSquare
        }
        
        /// If AI can't take middle square, then tak random available square
        var movePosition = Int.random(in: moves.startIndex..<moves.endIndex)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: moves.startIndex..<moves.endIndex)
        }
        
        return movePosition
    }
    
    func processMove(for player: Player, andWinPatterns winPatterns: Set<Set<Int>>)-> Int {
        let playerMoves = moves.compactMap{ $0 }.filter({ $0.player == player })
        let playerPositions = Set(playerMoves.map({ $0.boardIndex }))
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(playerPositions)
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        return -1
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?])-> Bool {
        let winPatters: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap { $0 }.filter({ $0.player == player })
        let playerPositions = Set(playerMoves.map({ $0.boardIndex }))
        
        for pattern in winPatters where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?])-> Bool {
        return moves.compactMap({ $0 }).count == moves.count
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
        isGameBoardDisabled = false
    }
}
