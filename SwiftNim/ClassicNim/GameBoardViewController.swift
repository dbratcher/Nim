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
    
    @IBAction func quit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeStones(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        let settings = GameSettingsManager.loadSettings()
        turnLabel.text = settings.firstMover.toString()
        
        let board = GameBoardManager.board()
        var stoneStackViews: [UIStackView] = []
        for stack in board.stacks {
            let stoneStackView = UIStackView(arrangedSubviews: [])
            stoneStackView.translatesAutoresizingMaskIntoConstraints = false
            stoneStackView.axis = .vertical
            stoneStackView.spacing = 10
            for _ in 0..<stack.stoneCount {
                stoneStackView.addArrangedSubview(StoneView())
            }
            stoneStackViews.append(stoneStackView)
        }
        let horizontalStackView = UIStackView(arrangedSubviews: stoneStackViews)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.spacing = 20
        horizontalStackView.alignment = .lastBaseline
        view.addSubview(horizontalStackView)
        horizontalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        horizontalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

class StoneView: UIView {
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 10
        clipsToBounds = true
        widthAnchor.constraint(equalToConstant: 40).isActive = true
        heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    
}
