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
    
    private var stacks: [LabeledStepper] {
        return [stack1, stack2, stack3, stack4, stack5]
    }
    
    @IBAction func stackNumberChanged(_ sender: Any) {
        if stackNumber.selectedSegmentIndex < 0 || stackNumber.selectedSegmentIndex > stackNumber.numberOfSegments {
            assert(false, "Number changed to invalid segment.")
        }
        // offset index instead of translating strings to numbers
        let currentNumber = stackNumber.selectedSegmentIndex + 3
        for index in 0..<stacks.count {
            // if the index matches the current number of stacks or is higher
            // then we should hide the stack (since indexs are 0 based)
            stacks[index].isHidden = index >= currentNumber
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    class LabelStepperHandler: LabelStepperDelegate {
        private let stackID: UUID = UUID()
        
        func valueChanged(_ newValue: Int) {
            UserDefaults.standard.set(newValue, forKey: stackID.uuidString)
        }
    }
}

