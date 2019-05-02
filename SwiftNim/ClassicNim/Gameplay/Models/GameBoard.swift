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
}

struct GameBoard {
    var stacks: [Stack]
    
    init() {
        let stack1 = Stack(identifier: UUID(), stoneCount: 4)
        let stack2 = Stack(identifier: UUID(), stoneCount: 5)
        let stack3 = Stack(identifier: UUID(), stoneCount: 3)
        
        stacks = [stack1, stack2, stack3]
    }
    
    init(stacks: [Stack]) {
        self.stacks = stacks
    }
}