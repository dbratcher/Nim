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
    
    var visibleStoneCount: Int {
        return stoneStackViews.reduce(0, { return $0 + $1.visibleStoneCount })
    }
    
    var currentVisibleBoard: GameBoard {
        var stacks: [Stack] = []
        for stoneStack in stoneStackViews {
            stacks.append(Stack(identifier: UUID(), stoneCount: stoneStack.visibleStoneCount))
        }
        
        return GameBoard(stacks: stacks)
    }
    
    init(for board: GameBoard, with engine: MoveEngine) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        alignment = .lastBaseline
        distribution = .fillEqually
        spacing = 20
        
        for stack in board.stacks {
            let stoneStackView = StoneStackView(for: stack, with: engine)
            stoneStackViews.append(stoneStackView)
            addArrangedSubview(stoneStackView)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
