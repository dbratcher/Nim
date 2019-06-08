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
        XCTAssert(stones == 3)
        XCTAssert(stack.identifier == stack1.identifier)
    }
}
