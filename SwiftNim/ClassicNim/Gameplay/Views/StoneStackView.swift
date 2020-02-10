//
//  StoneStackView.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/29/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class StoneStackView: UIStackView {
    private let soundManager = SoundManager()
    let stackID: UUID
    var hiddenStoneCount: Int {
        return subviews.filter({ $0 is StoneView && $0.alpha == 0 }).count
    }

    func hide(stoneViews: [StoneView], dispatchGroup: DispatchGroup) {
        for view in arrangedSubviews.reversed() {
            guard let stoneView = view as? StoneView else { continue }
            if stoneViews.contains(stoneView) {
                dispatchGroup.enter()
                hide(stoneView) { _ in
                    dispatchGroup.leave()
                }
            }
        }
    }

    func hide(_ stoneView: StoneView, completion: @escaping (Bool) -> Void) {
        guard let currentIndex = arrangedSubviews.firstIndex(of: stoneView) else {
            assert(false, "\(self) trying to remove not present stoneView: \(stoneView)")
            return
        }
        let newIndex = hiddenStoneCount
        let duration = Double(newIndex - currentIndex)

        soundManager.play(sound: .swoosh)
        UIView.animate(withDuration: duration, animations: {
            stoneView.removeFromSuperview()
            self.insertArrangedSubview(stoneView, at: newIndex)
            self.layoutSubviews()
        }, completion: { success in
            completion(success)
            UIView.animate(withDuration: 1, animations: {
                stoneView.alpha = 0
            })
        })
    }

    init(for stackID: UUID, with engine: MoveEngine) {
        self.stackID = stackID
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        alignment = .fill
        distribution = .fillEqually
        spacing = 10

        axis = .vertical

        guard let stack = engine.stack(for: stackID) else {
            assert(false, "\(self) could not setup for missing stack \(stackID)")
            return
        }

        for _ in 0..<stack.stoneCount {
            let stone = StoneView(for: stackID, with: engine)
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
