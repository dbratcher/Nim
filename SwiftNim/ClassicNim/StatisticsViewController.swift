//
//  StatisticsViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 1/28/20.
//  Copyright © 2020 Drew Bratcher. All rights reserved.
//

import UIKit

class StatisticsViewController: NimViewController {
    @IBOutlet private var totalWins: UILabel!
    @IBOutlet private var totalLosses: UILabel!
    @IBOutlet private var totalWinRate: UILabel!

    @IBOutlet private var easyWins: UILabel!
    @IBOutlet private var easyLosses: UILabel!
    @IBOutlet private var easyWinRate: UILabel!

    @IBOutlet private var mediumWins: UILabel!
    @IBOutlet private var mediumLosses: UILabel!
    @IBOutlet private var mediumWinRate: UILabel!

    @IBOutlet private var hardWins: UILabel!
    @IBOutlet private var hardLosses: UILabel!
    @IBOutlet private var hardWinRate: UILabel!

    @IBOutlet private var onePlayerTimePlayed: UILabel!
    @IBOutlet private var twoPlayerTimePlayed: UILabel!

    @IBAction private func resetStats(_ sender: Any) {
        Statistics.reset()
        loadStats()
    }

    @IBAction private func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadStats()
    }

    private func loadStats() {
        let stats = Statistics.shared

        update(labels: [totalWins, totalLosses, totalWinRate], wins: stats.totalWins, losses: stats.totalLosses)
        update(labels: [easyWins, easyLosses, easyWinRate], wins: stats.easyWins, losses: stats.easyLosses)
        update(labels: [mediumWins, mediumLosses, mediumWinRate], wins: stats.mediumWins, losses: stats.mediumLosses)
        update(labels: [hardWins, hardLosses, hardWinRate], wins: stats.hardWins, losses: stats.hardLosses)

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [ .hour, .minute ]

        let prettyOnePlayerTime = formatter.string(from: stats.onePlayerTimePlayed) ?? "Unknown"
        onePlayerTimePlayed.text = "One Player Time Played: \(prettyOnePlayerTime) minutes"
        let prettyTwoPlayerTime = formatter.string(from: stats.twoPlayerTimePlayed) ?? "Unknown"
        twoPlayerTimePlayed.text = "Two Player Time Played: \(prettyTwoPlayerTime) minutes"
    }

    private func update(labels: [UILabel], wins: UInt, losses: UInt) {
        labels[0].text = "Wins: \(wins)"
        labels[1].text = "Losses: \(losses)"
        let totalGames = losses + wins
        var winRate = round(Double(wins) / Double(totalGames) * 100)
        winRate = totalGames > 0 ? winRate : 0
        labels[2].text = "Win Rate: \(winRate)%"
    }
}
