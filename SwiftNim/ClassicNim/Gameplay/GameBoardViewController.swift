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
    
    @IBAction func quit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeStones(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        let settings = GameSettingsManager.loadSettings()
        turnLabel.text = settings.firstMover.toString()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let gameBoardView = GameBoardView(for: board)
        view.addSubview(gameBoardView)
        gameBoardView.topAnchor.constraint(greaterThanOrEqualTo: turnLabel.bottomAnchor, constant: 20).isActive = true
        gameBoardView.bottomAnchor.constraint(lessThanOrEqualTo: removeButton.topAnchor, constant: -20).isActive = true
        gameBoardView.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 20).isActive = true
        gameBoardView.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -20).isActive = true
        gameBoardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameBoardView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
