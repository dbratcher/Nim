//
//  GameBoardViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/6/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import StoreKit
import UIKit

class GameBoardViewController: NimViewController {
    @IBOutlet private var turnLabel: UILabel!
    @IBOutlet private var removeButton: UIButton!

    private let soundManager = SoundManager()
    private let engine = MoveEngine()
    private var start: DispatchTime?
    var gameBoardView: GameBoardView?
    var currentWinner = ""

    @IBAction private func quit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func removeStones() {
        guard engine.selectedStones.isEmpty == false else { return }

        removeButton.isEnabled = false
        engine.endTurn()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        engine.delegate = self
        configureBoardView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        start = DispatchTime.now()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        logTimePlayed()
    }

    private func logTimePlayed() {
        if let start = start {
            let recentTimePlayed = (DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
            if engine.settings.opponent == .computer {
                Statistics.shared.onePlayerTimePlayed += Double(recentTimePlayed)
            } else {
                Statistics.shared.twoPlayerTimePlayed += Double(recentTimePlayed)
            }
            Statistics.shared.save()
        }
        start = DispatchTime.now()
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
    func presentSameStackAlert() {
        performSegue(withIdentifier: "sameStack", sender: self)
        soundManager.play(sound: .endgame)
    }

    func updateViews(for state: GameState) {
        turnLabel?.text = "\(state.currentPlayer.toString())'s Turn"
        removeButton?.isEnabled = state.currentPlayer != .computer
    }

    func views(for stones: Int, in stack: Stack) -> [StoneView] {
        guard let gameBoardView = gameBoardView else {
            assert(false, "\(self) Could not get requested stones.")
            return []
        }

        guard let stoneStack = gameBoardView.arrangedSubviews.first(where: { view -> Bool in
            (view as? StoneStackView)?.stackID == stack.identifier
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
        logTimePlayed()
        currentWinner = state.currentPlayer.toString()
        performSegue(withIdentifier: "endGame", sender: self)
        soundManager.play(sound: .endgame)

        let askedForRatingKey = "askedForRating"
        if UserDefaults.standard.bool(forKey: askedForRatingKey) != true && (state.currentPlayer == .player1) {
            SKStoreReviewController.requestReview()
            UserDefaults.standard.set(true, forKey: askedForRatingKey)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let endGame = segue.destination as? EndGameViewController {
            endGame.winner = currentWinner
        }
    }
}
