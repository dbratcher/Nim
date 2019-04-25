//
//  CustomizeBoardViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/20/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class CustomizeBoardViewController: UIViewController {
    @IBOutlet weak var stackNumber: UISegmentedControl!
    @IBOutlet weak var stack1: LabeledStepper!
    @IBOutlet weak var stack2: LabeledStepper!
    @IBOutlet weak var stack3: LabeledStepper!
    @IBOutlet weak var stack4: LabeledStepper!
    @IBOutlet weak var stack5: LabeledStepper!
    
    private let firstStackNumber = 3
    
    private var stacks: [LabeledStepper] {
        return [stack1, stack2, stack3, stack4, stack5]
    }
    
    @IBAction func stackNumberChanged(_ sender: Any) {
        if stackNumber.selectedSegmentIndex < 0 || stackNumber.selectedSegmentIndex > stackNumber.numberOfSegments {
            assert(false, "Number changed to invalid segment.")
        }
        // offset index instead of translating strings to numbers
        let currentNumber = stackNumber.selectedSegmentIndex + firstStackNumber
        showStacks(currentNumber)
        updateBoard()
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let board = GameBoardManager.board()
        showStacks(board.stacks.count)
        stackNumber.selectedSegmentIndex = board.stacks.count - firstStackNumber
    }
    
    private func showStacks(_ visibleCount: Int) {
        // stacks are hidden if index (0 based) is greater or equal to visible count
        for index in 0..<stacks.count {
            stacks[index].isHidden = index >= visibleCount
        }
    }
    
    private func updateBoard() {
        var board = GameBoardManager.board()
        var newStacks: [Stack] = []
        for index in 0..<stacks.count {
            guard stacks[index].isHidden == false else {
                continue
            }
            
            // create new stacks if needed
            guard index < board.stacks.count else {
                newStacks.append(Stack(identifier: UUID(), stoneCount: stacks[index].value))
                continue
            }
            
            // otherwise use existing board stack and update it
            var stack = board.stacks[index]
            stack.stoneCount = stacks[index].value
            newStacks.append(stack)
        }
        board.stacks = newStacks
        GameBoardManager.save(board)
    }
    
    private class LabelStepperHandler: LabelStepperDelegate {
        private let stackID: UUID = UUID()
        
        func valueChanged(_ newValue: Int) {
            UserDefaults.standard.set(newValue, forKey: stackID.uuidString)
        }
    }
}

