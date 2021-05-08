//
//  AlertView.swift
//  Tic-Tac-Toe
//
//  Created by Kunal Tyagi on 04/05/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You win!"), message: Text("You are so smart, you beat your own AI."), buttonTitle: Text("Hell Yeah"))
    static let computerWin = AlertItem(title: Text("You lost"), message: Text("You programmed a super AI."), buttonTitle: Text("Rematch"))
    static let draw = AlertItem(title: Text("Draw"), message: Text("What a battle of wits we have here..."), buttonTitle: Text("Try Again"))
}
