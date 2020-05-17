//
//  ViewController3.swift
//  Tic-tac-toe
//
//  Created by Johnny Ramirez on 5/15/20.
//  Copyright © 2020 Johnny Ramirez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var gameMode = Title.X
    var difficulty = GameMode.Easy
    lazy var game = TicTacToe(mode: difficulty, playerTitle: gameMode)
    @IBOutlet private var buttonCollection: [UIButton]!
    @IBAction private func buttonPressed(_ sender: UIButton) {
        if let index = buttonCollection.firstIndex(of: sender) {
            game.isSelected(index: index)
            updateView()
        }
    }
    private func updateView() {
        for index in buttonCollection.indices {
            buttonCollection[index].setTitle(game.buttons[index].title.rawValue, for: .normal)
        }
        if let gameOver = game.gameOver {
            let alert = UIAlertController(
                title: "Game Over",
                message: gameOver == .Tie ? "Tie Game" : "\(gameOver.rawValue) won the game",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { Void in
                self.game.playerTitle = self.gameMode
                self.game.newGame()
                self.updateView()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            let stat = navigationController?.viewControllers[0] as! StatController
            stat.wins += game.totalWins
            stat.loss += game.totalLoss
            stat.ties += game.totalTies
            stat.games += game.totalGames
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        game = TicTacToe(mode: difficulty, playerTitle: gameMode)
        updateView()
    }
}

