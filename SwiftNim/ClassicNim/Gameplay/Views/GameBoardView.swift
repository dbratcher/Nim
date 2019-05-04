//
//  GameBoardView.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/29/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class GameBoardView: UIStackView {
    private var stoneStackViews: [StoneStackView] = []
    
    init(for engine: MoveEngine) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        alignment = .lastBaseline
        distribution = .fillEqually
        spacing = 20
        
        for stack in engine.board.stacks {
            let stoneStackView = StoneStackView(for: stack.identifier, with: engine)
            stoneStackViews.append(stoneStackView)
            addArrangedSubview(stoneStackView)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
