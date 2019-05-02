//
//  GameBoard.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/24/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import Foundation

class GameBoardManager {
    static private let boardStackIDListKey = "boardStackIDList"
    static private let stackStoneCountKeySuffix = "-stoneCount"
    
    static func board() -> GameBoard {
        let defaultBoard = GameBoard()
        guard let stackIDList = UserDefaults.standard.string(forKey: boardStackIDListKey) else {
            return defaultBoard
        }
        
        let stackIDStrings = stackIDList.components(separatedBy: ",")
        let stackIDs = stackIDStrings.compactMap { UUID(uuidString: $0) }
        guard stackIDs.count > 0 else {
            return defaultBoard
        }
        
        var boardStacks: [Stack] = []
        for id in stackIDs {
            let stackStoneCountKey = id.uuidString + stackStoneCountKeySuffix
            let stoneCount = UserDefaults.standard.integer(forKey: stackStoneCountKey)
            guard stoneCount > 0 else {
                assert(false, "Invalid stone count for stack with id: \(id)")
                continue
            }
            
            boardStacks.append(Stack(identifier: id, stoneCount: stoneCount))
        }

        return GameBoard(stacks: boardStacks)
    }
    
    static func save(_ newBoard: GameBoard) {
        // clear any existing board first
        let oldBoard = board()
        UserDefaults.standard.removeObject(forKey: boardStackIDListKey)
        for stack in oldBoard.stacks {
            let stackStoneCountKey = stack.identifier.uuidString + stackStoneCountKeySuffix
            UserDefaults.standard.removeObject(forKey: stackStoneCountKey)
        }
        
        // save new board
        let stackIDs = newBoard.stacks.map { $0.identifier.uuidString }
        let stackIDList = stackIDs.joined(separator: ",")
        UserDefaults.standard.set(stackIDList, forKey: boardStackIDListKey)
        for stack in newBoard.stacks {
            let stackStoneCountKey = stack.identifier.uuidString + stackStoneCountKeySuffix
            UserDefaults.standard.set(stack.stoneCount, forKey: stackStoneCountKey)
        }
    }
}
