//
//  StatController.swift
//  Tic-tac-toe
//
//  Created by Johnny Ramirez on 5/15/20.
//  Copyright © 2020 Johnny Ramirez. All rights reserved.
//

import UIKit

class StatController: UIViewController {

    var wins = Int()
    var loss = Int()
    var ties = Int()
    var games = Int()
    var currentTitle = Title.X
    var difficulty = GameMode.Easy
    @IBOutlet weak var TotalWins: UILabel!
    @IBOutlet weak var TotalLoss: UILabel!
    @IBOutlet weak var TotalTies: UILabel!
    @IBOutlet weak var TotalGames: UILabel!
    @IBAction func titleSetting(_ sender: UISegmentedControl) {
        switch currentTitle {
        case .X: currentTitle = .O
        case .O: currentTitle =  .X
        default: break
        }
    }
    @IBAction func difficultySetting(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: difficulty = .Easy
        case 1: difficulty = .Medium
        case 2: difficulty = .Hard
        default: break
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TotalWins.text = "Total Wins: \(wins)"
        TotalLoss.text = "Total Loss: \(loss)"
        TotalTies.text = "Total Ties: \(ties)"
        TotalGames.text = "Total Games: \(games)"
        // Do any additional setup after loading the view.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? ViewController {
            vc.gameMode = currentTitle
            vc.difficulty = difficulty
        }
    }

}
