//
//  LabeledStepper.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/20/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

protocol LabelStepperDelegate: class {
    func valueChanged(_ newValue: Int)
}

@IBDesignable
class LabeledStepper: UIStackView {
    private let label = UILabel(frame: .zero)
    private let countLabel = UILabel(frame: .zero)
    private let stepper = UIStepper(frame: .zero)
    
    private let maxValue = 7
    private let minValue = 1
    private let font = UIFont(name: "MarkerFelt-Thin", size: 24)
    private let color = UIColor.white
    
    public weak var delegate: LabelStepperDelegate?
    
    @IBInspectable
    var text: String = "Stepper:" {
        didSet {
            label.text = text
            label.isHidden = text.isEmpty
        }
    }
    
    @IBInspectable
    var value: Int = 1 {
        didSet {
            countLabel.text = "\(value)"
            stepper.value = Double(value)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addArrangedSubview(label)
        addArrangedSubview(countLabel)
        addArrangedSubview(stepper)
        distribution = .fillEqually
        
        label.font = font
        label.textColor = color
        label.textAlignment = .center
        label.numberOfLines = 0
        countLabel.font = font
        countLabel.textColor = color
        countLabel.textAlignment = .center
        stepper.maximumValue = Double(maxValue)
        stepper.minimumValue = Double(minValue)
        stepper.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    @objc func valueChanged() {
        value = Int(stepper.value)
        delegate?.valueChanged(value)
    }
}
