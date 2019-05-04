//
//  ViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/3/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
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

