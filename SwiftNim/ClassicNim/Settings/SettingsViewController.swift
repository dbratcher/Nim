//
//  SettingsViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/5/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var firstMover: UISegmentedControl!
    @IBOutlet weak var difficulty: UISegmentedControl!
    @IBOutlet weak var randomize: UISwitch!
    @IBOutlet weak var customizeBoard: UIButton!
    
    private var settings: GameSettings = GameSettingsStorage.load()
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func randomizeChanged(_ sender: Any) {
        settings.randomizeBoard = randomize.isOn
        customizeBoard.isEnabled = randomize.isOn == false
        GameSettingsStorage.save(settings)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        settings = GameSettingsStorage.load()
        difficulty.selectSegment(titled: settings.difficulty.toString())
        randomize.isOn = settings.randomizeBoard
        customizeBoard.isEnabled = randomize.isOn == false
        
        let segmentTitle = settings.player1GoesFirst ? "Player 1" : "Opponent"
        firstMover.selectSegment(titled: segmentTitle)
    }
    
    @IBAction func firstMoverChanged(_ sender: UISegmentedControl) {
        settings.player1GoesFirst = firstMover.selectedTitle == "Player 1"
        GameSettingsStorage.save(settings)
    }
    
    @IBAction func difficultyChanged(_ sender: UISegmentedControl) {
        guard let difficulty = Difficulty(from: sender.selectedTitle) else {
            assert(false, "Unknown difficulty selected.")
            return
        }
        
        settings.difficulty = difficulty
        GameSettingsStorage.save(settings)
    }
}
