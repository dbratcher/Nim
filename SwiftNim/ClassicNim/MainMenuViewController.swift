//
//  ViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/3/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class MainMenuViewController: NimViewController {
    @IBOutlet weak var Player1: UIButton!
    @IBOutlet weak var Player2: UIButton!
    @IBOutlet weak var Settings: UIButton!
    @IBOutlet weak var Help: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let buttons = [Player1, Player2, Settings, Help]
        var duration = 0.3
        for button in buttons {
            button?.alpha = 0.0
            UIView.animate(withDuration: duration) {
                button?.alpha = 1.0
            }
            duration += 0.3
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var settings = GameSettingsStorage.load()
        if segue.identifier == "1 Player" {
            settings.opponent = .computer
        }
        if segue.identifier == "2 Player" {
            settings.opponent = .player2
        }
        GameSettingsStorage.save(settings)
    }

    func navigateToSettings() {
        performSegue(withIdentifier: "Settings", sender: self)
    }
}

