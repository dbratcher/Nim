//
//  GameSettings.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/22/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import Foundation

enum FirstMoveType: String {
    case player1
    case opponent
    case random

    init?(from title: String?) {
        if title == "Player 1" {
            self = .player1
        } else if title == "Opponent" {
            self = .opponent
        } else if title == "Random" {
            self = .random
        } else {
            return nil
        }
    }

    func toString() -> String {
        switch self {
        case .player1: return "Player 1"
        case .opponent: return "Opponent"
        case .random: return "Random"
        }
    }
}

enum PlayerType: String {
    case player1
    case player2
    case computer

    init?(from title: String?) {
        if title == "Player 1" {
            self = .player1
        } else if title == "Player 2" {
            self = .player2
        } else if title == "Computer" {
            self = .computer
        } else {
            return nil
        }
    }

    func toString() -> String {
        switch self {
        case .player1: return "Player 1"
        case .player2: return "Player 2"
        case .computer: return "Computer"
        }
    }
}

enum Difficulty: String {
    case easy
    case medium
    case hard

    init?(from title: String?) {
        if title == "Easy" {
            self = .easy
        } else if title == "Medium" {
            self = .medium
        } else if title == "Hard" {
            self = .hard
        } else {
            return nil
        }
    }

    func toString() -> String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
}

enum GameSettingsStorage {
    private static let firstMoveKey = "firstMove"
    private static let difficultyKey = "difficulty"
    private static let randomizeKey = "randomize"
    private static let boardLayoutKey = "boardLayout"
    private static let opponentKey = "opponent"

    static func load() -> GameSettings {
        var settings = GameSettings()

        // use presence of difficulty key to determine if randomizeBoard was stored too
        if let difficulty = Difficulty(rawValue: UserDefaults.standard.string(forKey: difficultyKey) ?? "") {
            settings.difficulty = difficulty
            settings.randomizeBoard = UserDefaults.standard.bool(forKey: randomizeKey)
        }

        let loadedBoardLayout = UserDefaults.standard.string(forKey: boardLayoutKey)
        settings.boardLayout = BoardLayout(rawValue: loadedBoardLayout ?? "") ?? .vertical

        if let firstMove = FirstMoveType(rawValue: UserDefaults.standard.string(forKey: firstMoveKey) ?? "") {
            settings.firstMove = firstMove
        }

        if let opponent = PlayerType(rawValue: UserDefaults.standard.string(forKey: opponentKey) ?? "") {
            settings.opponent = opponent
        }

        return settings
    }

    static func save(_ settings: GameSettings) {
        UserDefaults.standard.set(settings.firstMove.rawValue, forKey: firstMoveKey)
        UserDefaults.standard.set(settings.difficulty.rawValue, forKey: difficultyKey)
        UserDefaults.standard.set(settings.randomizeBoard, forKey: randomizeKey)
        UserDefaults.standard.set(settings.boardLayout.rawValue, forKey: boardLayoutKey)
        UserDefaults.standard.set(settings.opponent.rawValue, forKey: opponentKey)
    }
}

enum BoardLayout: String {
    case vertical
    case horizontal

    init?(from title: String?) {
        if title == "Vertical" {
            self = .vertical
        } else if title == "Horizontal" {
            self = .horizontal
        } else {
            return nil
        }
    }

    func toString() -> String {
        switch self {
        case .vertical: return "Vertical"
        case .horizontal: return "Horizontal"
        }
    }
}

struct GameSettings {
    var randomizeBoard: Bool = false
    var boardLayout: BoardLayout = .vertical
    var firstMove: FirstMoveType = .player1
    var opponent: PlayerType = .computer
    var difficulty: Difficulty = .easy
}
