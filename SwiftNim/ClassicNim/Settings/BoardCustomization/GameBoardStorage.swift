//
//  GameBoard.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/24/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import Foundation

class GameBoardStorage {
    static private let boardStackIDListKey = "boardStackIDList"
    static private let stackStoneCountKeySuffix = "-stoneCount"

    static func load() -> GameBoard {
        let defaultBoard = GameBoard()
        guard let stackIDList = UserDefaults.standard.string(forKey: boardStackIDListKey) else {
            print("\(self) using a fresh board due to no board customization in user defaults")
            return defaultBoard
        }

        let stackIDStrings = stackIDList.components(separatedBy: ",")
        let stackIDs = stackIDStrings.compactMap { UUID(uuidString: $0) }
        guard stackIDs.isEmpty == false else {
            assert(false, "\(self) Invalid empty stack list")
            return defaultBoard
        }

        var boardStacks: [Stack] = []
        for stackID in stackIDs {
            let stackStoneCountKey = stackID.uuidString + stackStoneCountKeySuffix
            let stoneCount = UserDefaults.standard.integer(forKey: stackStoneCountKey)
            guard stoneCount > 0 else {
                assert(false, "\(self) Invalid stone count for stack with id: \(stackID)")
                return defaultBoard
            }

            boardStacks.append(Stack(identifier: stackID, stoneCount: stoneCount))
        }

        return GameBoard(stacks: boardStacks)
    }

    static func save(_ newBoard: GameBoard) {
        // clear any existing board first
        let oldBoard = load()
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
