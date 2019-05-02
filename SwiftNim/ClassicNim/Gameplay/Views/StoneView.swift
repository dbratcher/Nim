//
//  StoneView.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/29/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

protocol StoneViewDelegate: class {
    func tap(on view: StoneView, in stack: Stack) -> Bool
}

class StoneView: UIView {
    let stack: Stack
    var isSelected: Bool = false
    
    weak var delegate: StoneViewDelegate?
    
    init(for stack: Stack) {
        self.stack = stack
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = .white
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 2
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.width / 3
        super.draw(rect)
    }
    
    @objc func handleTap() {
        guard let delegate = delegate else {
            assert(false, "We need a delegate to check if taps are valid.")
            return
        }
        
        guard delegate.tap(on: self, in: stack) else {
            return
        }
        
        isSelected.toggle()
        backgroundColor = isSelected ? .gray : .white
        setNeedsDisplay()
    }
}
