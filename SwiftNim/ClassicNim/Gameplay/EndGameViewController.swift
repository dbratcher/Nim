//
//  EndGameViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 5/5/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var backgroundView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!
    var winner = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.cornerRadius = 30
        titleLabel.text = "\(winner) Won!"
    }

    @IBAction private func mainMenu(_ sender: Any) {
        guard let parentViewController = self.presentingViewController else {
            assert(false, "We could not dismiss whoever presented this view controller.")
            return
        }
        dismiss(animated: true) {
            parentViewController.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction private func settings(_ sender: Any) {
        guard let parentViewController = self.presentingViewController else {
            assert(false, "We could not dismiss whoever presented this view controller.")
            return
        }
        guard let mainMenu = self.presentingViewController?.presentingViewController as? MainMenuViewController else {
            assert(false, "We could not find a reference to the main menu view controller.")
            return
        }
        dismiss(animated: true) {
            parentViewController.dismiss(animated: true, completion: {
                mainMenu.navigateToSettings()
            })
        }
    }

    @IBAction private func newGame(_ sender: Any) {
        guard let gameBoard = self.presentingViewController as? GameBoardViewController else {
            assert(false, "We could not find a reference to the game board view controller.")
            return
        }
        dismiss(animated: true) {
            gameBoard.gameBoardView?.removeFromSuperview()
            gameBoard.configureBoardView()
        }
    }
}
