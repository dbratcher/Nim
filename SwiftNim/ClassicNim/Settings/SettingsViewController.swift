//
//  SettingsViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/5/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class SettingsViewController: NimViewController {
    @IBOutlet private var firstMover: UISegmentedControl!
    @IBOutlet private var difficulty: UISegmentedControl!
    @IBOutlet private var randomize: UISwitch!
    @IBOutlet private var customizeBoard: UIButton!
    @IBOutlet private var boardLayout: UISegmentedControl!

    @IBAction private func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func rateApp(_ sender: Any) {
        let urlString = "https://itunes.apple.com/us/app/classic-nim/id501414326?ls=1&mt=8&action=write-review"
        guard let validURL = URL(string: urlString) else { return }
        UIApplication.shared.open(validURL, options: [:], completionHandler: nil)
    }

    @IBAction private func layoutChanged(_ sender: UISegmentedControl) {
        settings.boardLayout = BoardLayout(from: sender.selectedTitle) ?? .vertical
        GameSettingsStorage.save(settings)
    }

    @IBAction private func randomizeChanged(_ sender: Any) {
        settings.randomizeBoard = randomize.isOn
        customizeBoard.isEnabled = randomize.isOn == false
        GameSettingsStorage.save(settings)
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

    private var settings: GameSettings = GameSettingsStorage.load()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        settings = GameSettingsStorage.load()
        difficulty.selectSegment(titled: settings.difficulty.toString())
        firstMover.selectSegment(titled: settings.firstMove.toString())
        randomize.isOn = settings.randomizeBoard
        boardLayout.selectSegment(titled: settings.boardLayout.toString())
        customizeBoard.isEnabled = randomize.isOn == false
    }
}
