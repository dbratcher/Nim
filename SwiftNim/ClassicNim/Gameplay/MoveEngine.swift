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
        gameState.currentPlayer = settings.firstMover
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
        let newOpponent = gameState.currentPlayer
        gameState.currentPlayer = gameState.opponent
        gameState.opponent = newOpponent
        
        delegate?.updateViews(for: gameState)
        
        if someoneWon() { return }
        
        if gameState.currentPlayer == .computer {
            moveForComputer()
        }
    }
    
    private func someoneWon() -> Bool {
        return false
    }
    
    private func moveForComputer() {
        
    }
}

