//
//  EndGameViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 5/5/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    var winner = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.cornerRadius = 30
        let backgroundImage = #imageLiteral(resourceName: "Background")
        backgroundView.backgroundColor = UIColor(patternImage: backgroundImage)
        titleLabel.text = "\(winner) Won!"
    }

    @IBAction func mainMenu(_ sender: Any) {
        guard let parentViewController = self.presentingViewController else {
            assert(false, "We could not dismiss whoever presented this view controller.")
        }
        dismiss(animated: true) {
            parentViewController.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func settings(_ sender: Any) {
        guard let parentViewController = self.presentingViewController else {
            assert(false, "We could not dismiss whoever presented this view controller.")
        }
        guard let mainMenu = self.presentingViewController?.presentingViewController as? MainMenuViewController else {
            assert(false, "We could not find a reference to the main menu view controller.")
        }
        dismiss(animated: true) {
            parentViewController.dismiss(animated: true, completion: {
                mainMenu.navigateToSettings()
            })
        }
    }

    @IBAction func newGame(_ sender: Any) {
        guard let gameBoard = self.presentingViewController as? GameBoardViewController else {
            assert(false, "We could not find a reference to the game board view controller.")
        }
        dismiss(animated: true) {
            gameBoard.gameBoardView?.removeFromSuperview()
            gameBoard.configureBoardView()
        }
    }
}
