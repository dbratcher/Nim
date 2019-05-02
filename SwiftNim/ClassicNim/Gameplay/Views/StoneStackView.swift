//
//  StoneStackView.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/29/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class StoneStackView: UIStackView {
    var hiddenStoneCount: Int {
        return subviews.filter({ $0 is StoneView && $0.alpha == 0 }).count
    }
    
    init(for stack: Stack, with delegate: StoneViewDelegate) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        spacing = 10
        
        for _ in 0..<stack.stoneCount {
            let stone = StoneView(for: stack)
            stone.delegate = delegate
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
