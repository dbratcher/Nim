//
//  ViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/3/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import AVFoundation
import UIKit

class MainMenuViewController: NimViewController {
    @IBOutlet private var player1: UIButton!
    @IBOutlet private var player2: UIButton!
    @IBOutlet private var statistics: UIButton!
    @IBOutlet private var settings: UIButton!
    @IBOutlet private var help: UIButton!

    private var allButtons: [UIButton] {
        return [player1, player2, statistics, settings, help]
    }

    private let soundManager = SoundManager()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        var duration = 0.3
        for button in allButtons {
            button.alpha = 0.0
            duration += 0.3
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        var duration = 0.3
        for button in allButtons {
            UIView.animate(withDuration: duration) {
                button.alpha = 1.0
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
        super.prepare(for: segue, sender: sender)

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
