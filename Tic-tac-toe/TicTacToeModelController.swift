//
//  TicTacToeModelController.swift
//  Tic-tac-toe
//
//  Created by Johnny Ramirez on 2/9/18.
//  Copyright © 2018 Johnny Ramirez. All rights reserved.
//

import Foundation

class TicTacToe {
    var buttons = [Button]()
    var gameOver: GameOver? {
        didSet {
            switch gameOver {
            case .XWon:
                titleUsed == .X ? (totalWins += 1) : (totalLoss += 1)
            case .OWon:
                titleUsed == .O ? (totalWins += 1) : (totalLoss += 1)
            case .Tie: totalTies += 1
            default: break
            }
        }
    }
    var mode: GameMode
    var playerTitle: Title
    var titleUsed = Title.X
    var totalWins = 0
    var totalLoss = 0
    var totalTies = 0
    var totalGames: Int {
        return totalWins + totalLoss + totalTies
    }
    private var flippedUpButtons: [Button] {
        return buttons.filter({$0.isFacedUp})
    }
    var xButtons: [Button] {
        return buttons.filter({$0.title == .X})
    }
    var oButtons: [Button] {
        return buttons.filter({$0.title == .O})
    }
    private var winningCombo = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    init(mode: GameMode, playerTitle: Title) {
        self.mode = mode
        self.playerTitle = playerTitle
        if playerTitle == .O {
            computerMove()
        }
        newGame()
    }
    func computerMove() {
        let unPickedArray = buttons.filter({!$0.isFacedUp}).map({$0.index})
        if unPickedArray.count > 0 {
            let random = Int(arc4random_uniform(UInt32(unPickedArray.count)))
            var playerButtons = [Button]()
            var computerButtons = [Button]()
            switch playerTitle {
            case .X:
                playerButtons = xButtons
                computerButtons = oButtons
            case .O:
                playerButtons = oButtons
                computerButtons = xButtons
            default: break
            }
            let easy = unPickedArray[random]
            let medium = strategicMove(button: computerButtons) ?? unPickedArray[random]
            let hard = strategicMove(button: playerButtons) ?? strategicMove(button: computerButtons) ?? unPickedArray[random]
            switch mode {
            case .Easy: isSelected(index: easy)
            case .Medium: isSelected(index: medium)
            case .Hard: isSelected(index: hard)
            }
        }
    }
    private func strategicMove(button: [Button]) -> Int? {
        for combo in winningCombo where match(selectedIndex: button.map({$0.index}), comboIndex: combo) == 2 {
            let buttonIndex = button.map({$0.index})
            for i in combo.indices where !buttonIndex.contains(combo[i]) && !buttons[combo[i]].isFacedUp {
                return combo[i]
            }
        }
        return nil
    }
    private var index = 0
    func isSelected(index: Int) {
        if !buttons[index].isFacedUp {
            buttons[index].title = titleUsed
            didWin(buttons: titleUsed == .X ? xButtons : oButtons)
            titleUsed = titleUsed.flip()
            playerTitle = playerTitle.flip()
            if playerTitle == .O && gameOver == nil {
                computerMove()
            }
        }
    }
    private func match(selectedIndex: [Int], comboIndex: [Int]) -> Int {
        var matchCount = 0
        for i in selectedIndex.indices {
            if comboIndex.contains(selectedIndex[i]) {
                matchCount += 1
            }
        }
        return matchCount
    }
    private func didWin(buttons: [Button]) {
        if buttons.count >= 3 {
            for combo in winningCombo {
                let facedUpIndexes = buttons.map({$0.index})
                if match(selectedIndex: facedUpIndexes, comboIndex: combo) == 3 {
                    gameOver = titleUsed == .X ? .XWon : .OWon
                    break
                }
            }
            if gameOver == nil && flippedUpButtons.count == 9 {
                gameOver = .Tie
            }
        }
    }
    func newGame() {
        buttons.removeAll()
        for i in 0..<9 {
            self.buttons.append(Button(index: i))
        }
        gameOver = .none
        titleUsed = .X
        if playerTitle == .O {
            computerMove()
        }
    }
}
enum Title: String {
    case X
    case O
    case none = ""
    mutating func flip() -> Title {
        switch self {
        case .X: return .O
        case .O: return .X
        case .none: return .none
        }
    }
}
enum GameMode: String {
    case Easy
    case Medium
    case Hard
}
enum GameOver: String {
    case XWon = "X"
    case OWon = "O"
    case Tie
}
struct Button {
    var index: Int
    var title: Title = .none
    var isFacedUp: Bool {
        return self.title != .none
    }
    init(index: Int) {
        self.index = index
    }
}
