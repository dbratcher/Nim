//
//  AIEngine.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 5/30/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import Foundation

class AIEngine {
    let difficulty: Difficulty

    init(difficulty: Difficulty) {
        self.difficulty = difficulty
    }

    func nextMove(for board: GameBoard) -> (Int, Stack) {
        var stack = board.randomStack
        var stones = Int.random(in: 1...stack.stoneCount)

        switch difficulty {
        case .easy: // random stack if less than 6 stones on the board
            if board.totalStones < 6 {
                (stones, stack) = idealMove(for: board)
            }
        case .medium: // random move if less than 10 stones on the board
            if board.totalStones < 10 {
                (stones, stack) = idealMove(for: board)
            }
        case .hard: // ideal stack ideal number of stones
            (stones, stack) = idealMove(for: board)
        }

        return (stones, stack)
    }

    private func idealMove(for board: GameBoard) -> (Int, Stack) {
        // the ideal strategy is based on xor of all stack stone counts
        var xorSum: Int = 0
        for stack in board.stacks {
            xorSum = xorSum ^ stack.stoneCount
        }

        if xorSum == 0 {
            // hopefully we're in the endgame with stacks of one
            // otherwise there is no way to win, stall
            return (1, board.randomStack)
        }

        for stack in board.stacks {
            let stackXor = xorSum ^ stack.stoneCount
            if stackXor < stack.stoneCount {
                var idealStoneCount = stack.stoneCount - stackXor
                if board.stacks.allSatisfy({ $0.stoneCount <= 1 || $0.identifier == stack.identifier }) {
                    // handle endgame of stacks of 1
                    let stacksOfOne = board.stacks.filter({ $0.stoneCount == 1 }).count
                    if stacksOfOne % 2 == 0 {
                        idealStoneCount -= 1
                    } else {
                        idealStoneCount = stack.stoneCount
                    }
                }

                return (idealStoneCount, stack)
            }
        }

        assert(false, "\(self) we could not determine a way to win, there should be an ideal move if xorSum > 0")
        return (1, board.randomStack)
    }
}
