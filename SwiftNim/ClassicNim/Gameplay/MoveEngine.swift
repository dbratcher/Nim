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
    private let settings = GameSettingsStorage.load()
    private var gameState = GameState(currentPlayer: .player1, opponent: .computer)
    private var selectedStones: [StoneView] = []
    private var isAnimating = false
    
    var board = GameBoardStorage.load()
    weak var delegate: MoveEngineDelegate?
    
    func tap(on stone: StoneView, in stack: Stack) {
        if isAnimating { return }
        if gameState.currentPlayer == .computer { return }
        
        if selectedStones.contains(where: { $0.stack != stack }) {
            delegate?.presentSameStackAlert()
            return
        }
        
        selectedStones.append(stone)
        stone.isSelected.toggle()
    }
    
    func start() {
        gameState.currentPlayer = settings.player1GoesFirst ? .player1 : settings.opponent
        delegate?.updateViews(for: gameState)
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
                self.updateGameState()
            }
        }
    }
    
    private func animateRemovingStones(in dispatchGroup: DispatchGroup) {
        guard let firstStone = selectedStones.first, let stackIndex = board.stacks.firstIndex(of: firstStone.stack) else {
            return // empty or malformed selected stones
        }
        
        board.stacks[stackIndex].stoneCount -= selectedStones.count
        
        for stone in selectedStones {
            dispatchGroup.enter()
            guard let stoneStack = stone.superview as? StoneStackView else {
                let superviewString = String(describing: stone.superview)
                assert(false, "\(self) Encountered unexpected superview \(superviewString) for \(stone)")
                return
            }
            
            stoneStack.hide(stone) { _ in
                dispatchGroup.leave()
            }
        }
        
        selectedStones = []
    }
    
    private func updateGameState() {
        swapCurrentPlayer()
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
            guard let stoneViews = delegate?.views(for: randomInt, in: randomStack) else  {
                assert(false, "Can't get random stack")
                return
            }
            selectedStones = stoneViews
        case .medium: // random stack ideal number of stones if possible
            let randomStack = board.randomStack
            let randomInt = Int.random(in: 1...randomStack.stoneCount)
            let (idealStones, _) = idealMove()
            let removedStones = idealStones < randomStack.stoneCount ? idealStones : randomInt
            guard let stoneViews = delegate?.views(for: removedStones, in: randomStack) else  {
                assert(false, "Can't get random stack")
                return
            }
            selectedStones = stoneViews
        case .hard: // ideal stack ideal number of stones
            let (idealStones, idealStack) = idealMove()
            guard let stoneViews = delegate?.views(for: idealStones, in: idealStack) else  {
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
            // no way to win, stall
            return (1, board.randomStack)
        }
        
        for stack in board.stacks {
            if xorSum < stack.stoneCount {
                return (xorSum, stack)
            }
        }
        
        return (1, board.randomStack)
    }
}

