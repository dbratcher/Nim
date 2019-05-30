//
//  ViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/3/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit
import AVFoundation

class MainMenuViewController: NimViewController {
    @IBOutlet weak var player1: UIButton!
    @IBOutlet weak var player2: UIButton!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var help: UIButton!

    private let soundManager = SoundManager()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let buttons = [player1, player2, settings, help]
        var duration = 0.3
        for button in buttons {
            button?.alpha = 0.0
            duration += 0.3
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let buttons = [player1, player2, settings, help]
        var duration = 0.3
        for button in buttons {
            UIView.animate(withDuration: duration) {
                button?.alpha = 1.0
            }
            duration += 0.3
        }

        if UserDefaults.standard.bool(forKey: "viewedTutorial") != true {
            self.present(TutorialViewController.create(), animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "viewedTutorial")
        }

        soundManager.play(sound: .endgame)
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
