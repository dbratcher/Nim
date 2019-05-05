//
//  GameBoardViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/6/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class GameBoardViewController: NimViewController {
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!

    private let engine = MoveEngine()
    private var gameBoardView: GameBoardView?

    @IBAction func quit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func removeStones() {
        guard engine.selectedStones.count > 0 else { return }

        removeButton.isEnabled = false
        engine.endTurn()
    }

    override func loadView() {
        super.loadView()
        engine.delegate = self
        configureBoardView()
        engine.start()
    }

    func configureBoardView() {
        engine.configureBoard()

        let gameBoardView = GameBoardView(for: engine)
        self.gameBoardView = gameBoardView
        view.addSubview(gameBoardView)
        gameBoardView.topAnchor.constraint(greaterThanOrEqualTo: turnLabel.bottomAnchor, constant: 20).isActive = true
        gameBoardView.bottomAnchor.constraint(lessThanOrEqualTo: removeButton.topAnchor, constant: -20).isActive = true
        gameBoardView.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 20).isActive = true
        gameBoardView.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -20).isActive = true
        gameBoardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameBoardView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension GameBoardViewController: MoveEngineDelegate {
    func presentRandomModeAlert(firstMovePlayer: PlayerType) {
        var randomModeMessage = "Each game will have a random board and a random player will start first."
        randomModeMessage += "You can disble this mode in settings. This game \(firstMovePlayer.toString()) goes first."
        let alert = UIAlertController(title: "Random Mode", message: randomModeMessage, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            guard let mainMenu = self.presentingViewController as? MainMenuViewController else {
                assert(false, "\(self) could not find main menu while dismissing")
                return
            }
            self.dismiss(animated: true, completion: {
                mainMenu.navigateToSettings()
            })
        }
        alert.addAction(settingsAction)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.engine.updateGameState()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    func presentSameStackAlert() {
        let sameStackMessage = "You must select stones in the same stack."
        let alert = UIAlertController(title: "Same Stack Rule", message: sameStackMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    func updateViews(for state: GameState) {
        turnLabel.text = "\(state.currentPlayer.toString())'s Turn"
        removeButton.isEnabled = state.currentPlayer != .computer
    }

    func views(for stones: Int, in stack: Stack) -> [StoneView] {
        guard let gameBoardView = gameBoardView else {
            assert(false, "\(self) Could not get requested stones.")
            return []
        }

        guard let stoneStack = gameBoardView.arrangedSubviews.first(where: { (view) -> Bool in
            return (view as? StoneStackView)?.stackID == stack.identifier
        }) as? StoneStackView else {
            assert(false, "\(self) Could not get requested stack for stones.")
            return []
        }

        var views: [StoneView] = []
        for view in stoneStack.arrangedSubviews {
            guard views.count < stones else { break }
            guard let stoneView = view as? StoneView else { continue }
            guard stoneView.alpha > 0 else { continue }

            views.append(stoneView)
        }

        return views
    }

    func displayEndPrompt(for state: GameState) {
        let winner = state.currentPlayer.toString()
        let endGameMessage = "Play Again? You can also adjust the difficulty in settings."
        let alert = UIAlertController(title: "\(winner) Won!", message: endGameMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Main Menu", style: .default) { (_) in
            self.dismiss(animated: true)
        }
        alert.addAction(okAction)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            guard let mainMenu = self.presentingViewController as? MainMenuViewController else {
                assert(false, "\(self) could not find main menu while dismissing")
                return
            }
            self.dismiss(animated: true, completion: {
                mainMenu.navigateToSettings()
            })
        }
        alert.addAction(settingsAction)
        let playAgainAction = UIAlertAction(title: "New Game", style: .default) { (_) in
            self.gameBoardView?.removeFromSuperview()
            self.configureBoardView()
            self.engine.updateGameState()
        }
        alert.addAction(playAgainAction)
        present(alert, animated: true)
    }
}
