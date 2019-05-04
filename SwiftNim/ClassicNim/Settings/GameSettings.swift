//
//  GameSettings.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/22/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import Foundation

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

struct GameSettings {
    var randomizeBoard: Bool = false
    var player1GoesFirst: Bool = true
    var opponent: PlayerType = .computer
    var difficulty: Difficulty = .easy
}

class GameSettingsStorage {
    static private let player1GoesFirstKey = "player1GoesFirst"
    static private let difficultyKey = "difficulty"
    static private let randomizeKey = "randomize"
    
    static func load() -> GameSettings {
        var settings = GameSettings()
        
        // use presence of difficulty key to determine if player1GoesFirst was stored too
        if let storedDifficulty = UserDefaults.standard.string(forKey: difficultyKey), let difficulty = Difficulty(rawValue: storedDifficulty) {
            settings.difficulty = difficulty
            settings.player1GoesFirst = UserDefaults.standard.bool(forKey: player1GoesFirstKey)
            settings.randomizeBoard = UserDefaults.standard.bool(forKey: randomizeKey)
        }
        
        return settings
    }
    
    static func save(_ settings: GameSettings) {
        UserDefaults.standard.set(settings.player1GoesFirst, forKey: player1GoesFirstKey)
        UserDefaults.standard.set(settings.difficulty.rawValue, forKey: difficultyKey)
        UserDefaults.standard.set(settings.randomizeBoard, forKey: randomizeKey)
    }
}
