//
//  SettingsViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/5/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class SettingsViewController: NimViewController {
    @IBOutlet private weak var firstMover: UISegmentedControl!
    @IBOutlet private weak var difficulty: UISegmentedControl!
    @IBOutlet private weak var randomize: UISwitch!
    @IBOutlet private weak var customizeBoard: UIButton!

    private var settings: GameSettings = GameSettingsStorage.load()

    @IBAction private func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func rateApp(_ sender: Any) {
        let urlString = "https://itunes.apple.com/us/app/classic-nim/id501414326?ls=1&mt=8&action=write-review"
        guard let validURL = URL(string: urlString) else { return }
        UIApplication.shared.open(validURL, options: [:], completionHandler: nil)
    }

    @IBAction private func randomizeChanged(_ sender: Any) {
        settings.randomizeBoard = randomize.isOn
        customizeBoard.isEnabled = randomize.isOn == false
        GameSettingsStorage.save(settings)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        settings = GameSettingsStorage.load()
        difficulty.selectSegment(titled: settings.difficulty.toString())
        firstMover.selectSegment(titled: settings.firstMove.toString())
        randomize.isOn = settings.randomizeBoard
        customizeBoard.isEnabled = randomize.isOn == false

    }

    @IBAction private func firstMoverChanged(_ sender: UISegmentedControl) {
        guard let firstMove = FirstMoveType(from: sender.selectedTitle) else {
            assert(false, "Unknown first move selected.")
            return
        }

        settings.firstMove = firstMove
        GameSettingsStorage.save(settings)
    }

    @IBAction private func difficultyChanged(_ sender: UISegmentedControl) {
        guard let difficulty = Difficulty(from: sender.selectedTitle) else {
            assert(false, "Unknown difficulty selected.")
            return
        }

        settings.difficulty = difficulty
        GameSettingsStorage.save(settings)
    }
}
