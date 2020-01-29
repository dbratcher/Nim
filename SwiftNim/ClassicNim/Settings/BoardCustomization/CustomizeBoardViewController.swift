//
//  CustomizeBoardViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/20/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class CustomizeBoardViewController: NimViewController {
    @IBOutlet private var stackNumber: UISegmentedControl!
    @IBOutlet private var stack1: LabeledStepper!
    @IBOutlet private var stack2: LabeledStepper!
    @IBOutlet private var stack3: LabeledStepper!
    @IBOutlet private var stack4: LabeledStepper!
    @IBOutlet private var stack5: LabeledStepper!

    @IBAction private func stackNumberChanged(_ sender: Any) {
        if stackNumber.selectedSegmentIndex < 0 || stackNumber.selectedSegmentIndex > stackNumber.numberOfSegments {
            assert(false, "Number changed to invalid segment.")
            return
        }
        // offset index instead of translating strings to numbers
        let currentNumber = stackNumber.selectedSegmentIndex + firstStackNumber
        showStacks(currentNumber)
        updateBoard()
    }

    @IBAction private func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    private let firstStackNumber = 3
    private var board = GameBoardStorage.load()

    private var stackSteppers: [LabeledStepper] {
        return [stack1, stack2, stack3, stack4, stack5]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        for stepper in stackSteppers {
            stepper.delegate = self
        }
        showStacks(board.stacks.count)
        stackNumber.selectedSegmentIndex = board.stacks.count - firstStackNumber
    }

    private func showStacks(_ visibleCount: Int) {
        // stacks are hidden if index (0 based) is greater or equal to visible count
        for index in 0..<stackSteppers.count {
            stackSteppers[index].isHidden = index >= visibleCount
            if index < board.stacks.count {
                stackSteppers[index].value = board.stacks[index].stoneCount
            }
        }
    }

    private func updateBoard() {
        var newStacks: [Stack] = []
        for index in 0..<stackSteppers.count {
            guard stackSteppers[index].isHidden == false else {
                continue
            }

            // create new stacks if needed
            guard index < board.stacks.count else {
                newStacks.append(Stack(identifier: UUID(), stoneCount: stackSteppers[index].value))
                continue
            }

            // otherwise use existing board stack and update it
            var stack = board.stacks[index]
            stack.stoneCount = stackSteppers[index].value
            newStacks.append(stack)
        }
        board.stacks = newStacks
        GameBoardStorage.save(board)
    }
}

extension CustomizeBoardViewController: LabelStepperDelegate {
    func valueChanged(_ newValue: Int) {
        updateBoard()
    }
}
