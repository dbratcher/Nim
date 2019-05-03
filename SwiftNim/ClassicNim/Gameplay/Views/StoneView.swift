//
//  StoneView.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/29/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class StoneView: UIView {
    private let engine: MoveEngine
    
    let stack: Stack
    var isSelected: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    init(for stack: Stack, with engine: MoveEngine) {
        self.stack = stack
        self.engine = engine
        
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
        backgroundColor = isSelected ? .gray : .white
        layer.cornerRadius = frame.width / 3
        super.draw(rect)
    }
    
    @objc func handleTap() {
        engine.tap(on: self, in: stack)
    }
}
