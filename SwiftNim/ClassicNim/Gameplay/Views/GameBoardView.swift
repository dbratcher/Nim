//
//  GameBoardView.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/29/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class GameBoardView: UIStackView {
    init(for board: GameBoard, with delegate: StoneViewDelegate) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        alignment = .lastBaseline
        distribution = .fillEqually
        spacing = 20
        
        for stack in board.stacks {
            addArrangedSubview(StoneStackView(for: stack, with: delegate))
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
