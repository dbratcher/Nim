//
//  GameBoardViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/6/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController {
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    private var board = GameBoardManager.board()
    private let horizontalSpacing: CGFloat = 20
    private let verticalSpacing: CGFloat = 10
    
    private var selectedStones: [StoneView] = []
    
    @IBAction func quit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeStones(_ sender: Any) {
        selectedStones.forEach { stone in
            UIView.animate(withDuration: 2, animations: {
                if let stackView = stone.superview as? StoneStackView {
                    stone.removeFromSuperview()
                    stackView.insertArrangedSubview(stone, at: stackView.hiddenStoneCount)
                    stackView.layoutSubviews()
                }
            }, completion: { _ in
                UIView.animate(withDuration: 1, animations: {
                    stone.alpha = 0
                })
            })
        }
        selectedStones.removeAll()
    }
    
    override func viewDidLoad() {
        let settings = GameSettingsManager.loadSettings()
        turnLabel.text = settings.firstMover.toString()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let gameBoardView = GameBoardView(for: board, with: self)
        view.addSubview(gameBoardView)
        gameBoardView.topAnchor.constraint(greaterThanOrEqualTo: turnLabel.bottomAnchor, constant: 20).isActive = true
        gameBoardView.bottomAnchor.constraint(lessThanOrEqualTo: removeButton.topAnchor, constant: -20).isActive = true
        gameBoardView.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 20).isActive = true
        gameBoardView.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -20).isActive = true
        gameBoardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameBoardView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension GameBoardViewController: StoneViewDelegate {
    func tap(on view: StoneView, in stack: Stack) -> Bool {
        if view.isSelected {
            selectedStones.removeAll { $0 == view }
            return true
        }
        
        if let selectedStack = selectedStones.first?.stack, selectedStack != stack {
            let sameStackMessage = "You must select stones in the same stack."
            let alert = UIAlertController(title: "Same Stack Rule", message: sameStackMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return false
        }
        
        selectedStones.append(view)
        return true
    }
}
