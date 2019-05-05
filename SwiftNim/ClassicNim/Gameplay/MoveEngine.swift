//
//  MoveEngine.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 5/2/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import Foundation

protocol MoveEngineDelegate: class {
    func presentSameStackAlert()
    func updateViews(for state: GameState)
    func views(for stones: Int, in stack: Stack) -> [StoneView]
    func displayEndPrompt(for state: GameState)
}

class MoveEngine {
    private var settings = GameSettingsStorage.load()
    private var gameState = GameState(currentPlayer: .player1, opponent: .computer)
    private var isAnimating = false

    var selectedStones: [StoneView] = []
    var board = GameBoardStorage.load()
    weak var delegate: MoveEngineDelegate?

    func tap(on stone: StoneView, in stackID: UUID) {
        if isAnimating { return }
        if gameState.currentPlayer == .computer { return }

        if selectedStones.contains(where: { $0.stackID != stackID }) {
            delegate?.presentSameStackAlert()
            return
        }

        selectedStones.removeAll(where: { $0 == stone })
        stone.isSelected.toggle()
        if stone.isSelected {
            selectedStones.append(stone)
        }
    }

    func stack(for stackID: UUID) -> Stack? {
        return board.stacks.first(where: { $0.identifier == stackID})
    }

    func configureBoard() {
        settings = GameSettingsStorage.load()
        switch settings.firstMove {
        case .player1:
            gameState.currentPlayer = .player1
            gameState.opponent = settings.opponent
        case .opponent:
            gameState.currentPlayer = settings.opponent
            gameState.opponent = .player1
        case .random :
            let mixItUp = Bool.random()
            gameState.currentPlayer = mixItUp ? settings.opponent : .player1
            gameState.opponent = mixItUp ? .player1 : settings.opponent
        }

        board = settings.randomizeBoard ? GameBoard.randomBoard() : GameBoardStorage.load()

        delegate?.updateViews(for: gameState)
        if gameState.currentPlayer == .computer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // wait a second for user to get bearings before moving computer
                self.updateGameState()
            }
        }
    }

    func endTurn() {
        let dispatchGroup = DispatchGroup()
        animateRemovingStones(in: dispatchGroup)
        isAnimating = true

        // wait for animation on a background thread before updating views
        DispatchQueue.global().async {
            dispatchGroup.wait()
            DispatchQueue.main.async {
                self.isAnimating = false
                self.swapCurrentPlayer()
                self.updateGameState()
            }
        }
    }

    private func animateRemovingStones(in dispatchGroup: DispatchGroup) {
        guard let firstStone = selectedStones.first else {
            assert(false, "\(self) was asked to animate removing stones when none are selected")
            return
        }

        guard let stackIndex = board.stacks.firstIndex(where: { $0.identifier == firstStone.stackID }) else {
            assert(false, "\(self) was asked to animate removing stones that are not in the board")
            return
        }

        board.stacks[stackIndex].stoneCount -= selectedStones.count

        guard let stoneStack = firstStone.superview as? StoneStackView else {
            let superviewString = String(describing: firstStone.superview)
            assert(false, "\(self) Encountered unexpected superview \(superviewString) for \(firstStone)")
            return
        }

        stoneStack.hide(stoneViews: selectedStones, dispatchGroup: dispatchGroup)

        selectedStones = []
    }

    func updateGameState() {
        delegate?.updateViews(for: gameState)

        if someoneWon() {
            delegate?.displayEndPrompt(for: gameState)
            return
        }

        if gameState.currentPlayer == .computer {
            moveForComputer()
        }
    }

    private func swapCurrentPlayer() {
        let newOpponent = gameState.currentPlayer
        gameState.currentPlayer = gameState.opponent
        gameState.opponent = newOpponent
    }

    private func someoneWon() -> Bool {
        if board.totalStones == 0 {
            return true
        }

        if board.totalStones == 1 {
            // on next turn current player loses
            swapCurrentPlayer()
            return true
        }

        return false
    }

    private func moveForComputer() {
        switch settings.difficulty {
        case .easy: // random stack random number of stones
            let randomStack = board.randomStack
            let randomInt = Int.random(in: 1...randomStack.stoneCount)
            guard let stoneViews = delegate?.views(for: randomInt, in: randomStack) else {
                assert(false, "Can't get random stack")
                return
            }
            selectedStones = stoneViews
        case .medium: // random move if more than 8 stones on the board
            var chosenStack = board.randomStack
            var chosenStones = Int.random(in: 1...chosenStack.stoneCount)
            if board.totalStones < 8 {
                (chosenStones, chosenStack) = idealMove()
            }
            guard let stoneViews = delegate?.views(for: chosenStones, in: chosenStack) else {
                assert(false, "Can't get random stack")
                return
            }
            selectedStones = stoneViews
        case .hard: // ideal stack ideal number of stones
            let (idealStones, idealStack) = idealMove()
            guard let stoneViews = delegate?.views(for: idealStones, in: idealStack) else {
                assert(false, "Can't get random stack")
                return
            }
            selectedStones = stoneViews
        }

        // chain selecting stones
        var delay: Double = 0.5
        for stone in selectedStones {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                stone.isSelected.toggle()
            }
            delay += 0.5
        }

        // on completion end turn
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.endTurn()
        }
    }

    private func idealMove() -> (Int, Stack) {
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
