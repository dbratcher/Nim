//
//  ViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/3/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class MainMenuViewController: NimViewController {
    @IBOutlet weak var player1: UIButton!
    @IBOutlet weak var player2: UIButton!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var help: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let buttons = [player1, player2, settings, help]
        var duration = 0.3
        for button in buttons {
            button?.alpha = 0.0
            UIView.animate(withDuration: duration) {
                button?.alpha = 1.0
            }
            duration += 0.3
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let tutorialTitles = ["Each game starts with a board of stones",
                              "Select stones in a single stack to remove 🔘",
                              "Players take turns each removing stones 🤼",
                              "Last person to remove a stone loses 😁"]
        let tutorialImages = ["GameBoard", "SelectStones", "RemoveStones", "DontLose"]
        let tutorial = TutorialViewController(titles: tutorialTitles, images: tutorialImages, bgColor: #colorLiteral(red: 0.3529411765, green: 0.2862745098, blue: 0.2549019608, alpha: 1))
        self.present(tutorial, animated: true, completion: nil)
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
