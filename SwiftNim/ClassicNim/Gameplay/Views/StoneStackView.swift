//
//  StoneStackView.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/29/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class StoneStackView: UIStackView {
    init(for stack: Stack) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        spacing = 10
        
        for _ in 0..<stack.stoneCount {
            let stone = StoneView()
            addArrangedSubview(stone)
            stone.widthAnchor.constraint(equalTo: stone.heightAnchor).isActive = true
            let maxHeightConstraint = stone.heightAnchor.constraint(equalToConstant: 150)
            maxHeightConstraint.priority = .defaultLow
            maxHeightConstraint.isActive = true
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
