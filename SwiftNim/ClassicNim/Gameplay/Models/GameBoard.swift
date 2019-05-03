//
//  GameBoard.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/30/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import Foundation

struct Stack: Equatable {
    let identifier: UUID
    var stoneCount: Int
    
    static func == (lhs: Stack, rhs: Stack) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

struct GameBoard {
    var stacks: [Stack]
    var totalStones: Int {
        return stacks.reduce(0, {  $0 + $1.stoneCount })
    }
    
    var randomStack: Stack {
        let validStacks = stacks.filter { $0.stoneCount > 0 }
        guard let randomStack = validStacks.randomElement() else {
            assert(false, "\(self) Could not get random stack")
            return Stack(identifier: UUID(), stoneCount: 1)
        }
        
        return randomStack
    }
    
    init(stacks: [Stack]) {
        self.stacks = stacks
    }
    
    init() {
        let stack1 = Stack(identifier: UUID(), stoneCount: 4)
        let stack2 = Stack(identifier: UUID(), stoneCount: 5)
        let stack3 = Stack(identifier: UUID(), stoneCount: 3)
        
        self.init(stacks: [stack1, stack2, stack3])
    }
}

struct GameState {
    var currentPlayer: PlayerType
    var opponent: PlayerType
}
