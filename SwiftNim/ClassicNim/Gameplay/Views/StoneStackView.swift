//
//  StoneStackView.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/29/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class StoneStackView: UIStackView {
    let stack: Stack
    var hiddenStoneCount: Int {
        return subviews.filter({ $0 is StoneView && $0.alpha == 0 }).count
    }
    
    var visibleStoneCount: Int {
        return stack.stoneCount - hiddenStoneCount
    }
    
    func hide(_ stoneView: StoneView, completion: @escaping (Bool) -> ()) {
        guard let currentIndex = arrangedSubviews.firstIndex(of: stoneView) else {
            assert(false, "\(self) trying to remove not present stoneView: \(stoneView)")
            return
        }
        let newIndex = hiddenStoneCount
        let duration = Double(newIndex - currentIndex) / 2
        
        UIView.animate(withDuration: duration, animations: {
            stoneView.removeFromSuperview()
            self.insertArrangedSubview(stoneView, at: newIndex)
            self.layoutSubviews()
        }, completion: { _ in
            UIView.animate(withDuration: 1, animations: {
                stoneView.alpha = 0
            }, completion: completion)
        })
    }
    
    init(for stack: Stack, with engine: MoveEngine) {
        self.stack = stack
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        spacing = 10
        
        for _ in 0..<stack.stoneCount {
            let stone = StoneView(for: stack, with: engine)
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
