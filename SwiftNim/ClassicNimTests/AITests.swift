//
//  ClassicNimTests.swift
//  ClassicNimTests
//
//  Created by Drew Bratcher on 4/3/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

@testable import ClassicNim
import XCTest

class AIEngineTests: XCTestCase {
    func testEasyAI() {
        let easyAI = AIEngine(difficulty: .easy)

        let stack1 = Stack(identifier: UUID(), stoneCount: 4)
        let stack2 = Stack(identifier: UUID(), stoneCount: 4)
        let board = GameBoard(stacks: [stack1, stack2])

        let (stones, stack) = easyAI.nextMove(for: board)
        XCTAssert(stones > 0)
        XCTAssert(stones < 5)
        XCTAssert((stack.identifier == stack1.identifier) || (stack.identifier == stack2.identifier))
    }

    func testMediumAI() {
        let mediumAI = AIEngine(difficulty: .medium)

        let stack1 = Stack(identifier: UUID(), stoneCount: 4)
        let stack2 = Stack(identifier: UUID(), stoneCount: 4)
        let board = GameBoard(stacks: [stack1, stack2])

        let (stones, stack) = mediumAI.nextMove(for: board)
        XCTAssert(stones > 0)
        XCTAssert(stones < 5)
        XCTAssert((stack.identifier == stack1.identifier) || (stack.identifier == stack2.identifier))
    }

    func testHardAI() {
        let hardAI = AIEngine(difficulty: .hard)

        let stack1 = Stack(identifier: UUID(), stoneCount: 3)
        let stack2 = Stack(identifier: UUID(), stoneCount: 5)
        let stack3 = Stack(identifier: UUID(), stoneCount: 5)
        let board = GameBoard(stacks: [stack1, stack2, stack3])

        let (stones, stack) = hardAI.nextMove(for: board)
        XCTAssertEqual(stones, 3)
        XCTAssertEqual(stack.identifier, stack1.identifier)
    }
}

class LastStoneRuleTests: XCTestCase {
    private func board(_ counts: [Int]) -> GameBoard {
        GameBoard(stacks: counts.map { Stack(identifier: UUID(), stoneCount: $0) })
    }

    private func hardMove(_ counts: [Int], _ rule: LastStoneRule) -> (stones: Int, stackCount: Int) {
        let (stones, stack) = AIEngine(difficulty: .hard, lastStone: rule).nextMove(for: board(counts))
        return (stones, stack.stoneCount)
    }

    func testOneStackLeft() {
        // last stone loses: leave exactly one stone for the opponent
        XCTAssertEqual(hardMove([0, 0, 3], .loses).stones, 2)
        // last stone wins: take the whole stack
        XCTAssertEqual(hardMove([0, 0, 3], .wins).stones, 3)
    }

    func testStackOfOneAndStackOfTwo() {
        // last stone loses: empty the stack of two, opponent must take the last stone
        let loses = hardMove([1, 2], .loses)
        XCTAssertEqual(loses.stackCount, 2)
        XCTAssertEqual(loses.stones, 2)

        // last stone wins: balance the stacks at 1 and 1
        let wins = hardMove([1, 2], .wins)
        XCTAssertEqual(wins.stackCount, 2)
        XCTAssertEqual(wins.stones, 1)
    }

    func testWinsRuleLeavesZeroNimSum() {
        let counts = [3, 4, 5]
        let move = hardMove(counts, .wins)
        var remaining = counts
        let index = remaining.firstIndex(of: move.stackCount)!
        remaining[index] -= move.stones
        XCTAssertEqual(remaining.reduce(0, ^), 0)
    }
}

// Regression: rapid Next/Previous clicks crashed UIPageViewController on Mac (App Review 2.2.4)
import UIKit
class TutorialReproTests: XCTestCase {
    private func buttons(in view: UIView) -> [UIButton] {
        var out: [UIButton] = []
        for sub in view.subviews {
            if let button = sub as? UIButton { out.append(button) }
            out += buttons(in: sub)
        }
        return out
    }
    private func button(_ title: String, _ tutorial: UIViewController) -> UIButton? {
        buttons(in: tutorial.view).first { $0.title(for: .normal) == title && !$0.isHidden && $0.window != nil }
    }
    private func spin(_ seconds: TimeInterval) {
        RunLoop.main.run(until: Date().addingTimeInterval(seconds))
    }
    private func present() -> TutorialViewController {
        let root = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.windows.first }.first!.rootViewController!
        var top = root; while let presented = top.presentedViewController { top = presented }
        if top is TutorialViewController { top.dismiss(animated: false); spin(0.5); top = root }
        let tutorial = TutorialViewController.create()
        top.present(tutorial, animated: false)
        spin(1.0)
        return tutorial
    }
    func testWalkThroughSlowly() {
        let tutorial = present()
        for step in 0..<3 {
            guard let next = button("Next", tutorial) else { return XCTFail("no Next at step \(step)") }
            next.sendActions(for: .touchUpInside)
            spin(1.0)
        }
        XCTAssertNotNil(button("Let's Play!", tutorial))
        button("Let's Play!", tutorial)?.sendActions(for: .touchUpInside)
        spin(1.0)
    }
    func testDoubleClickNext() {
        let tutorial = present()
        let next = button("Next", tutorial)!
        for _ in 0..<10 {
            next.sendActions(for: .touchUpInside)
            spin(0.05)
        }
        spin(1.0)
        let prev = button("Previous", tutorial)
        for _ in 0..<10 {
            next.sendActions(for: .touchUpInside)
            prev?.sendActions(for: .touchUpInside)
            spin(0.02)
        }
        spin(1.5)
        // Should still be able to reach the end and finish.
        while let nextButton = button("Next", tutorial) {
            nextButton.sendActions(for: .touchUpInside)
            spin(1.0)
        }
        XCTAssertNotNil(button("Let's Play!", tutorial))
    }
}
