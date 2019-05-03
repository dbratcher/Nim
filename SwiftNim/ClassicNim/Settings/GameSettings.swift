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
    var firstMover: PlayerType = .player1
    var opponent: PlayerType = .computer
    var difficulty: Difficulty = .easy
}

class GameSettingsStorage {
    static private let firstMoverKey = "firstMover"
    static private let difficultyKey = "difficulty"
    
    static func load() -> GameSettings {
        var settings = GameSettings()
        
        if let storedFirstMover = UserDefaults.standard.string(forKey: firstMoverKey), let firstMoverPlayerType = PlayerType(rawValue: storedFirstMover) {
            settings.firstMover = firstMoverPlayerType
        }
        
        if let storedDifficulty = UserDefaults.standard.string(forKey: difficultyKey), let difficulty = Difficulty(rawValue: storedDifficulty) {
            settings.difficulty = difficulty
        }
        
        return settings
    }
    
    static func save(_ settings: GameSettings) {
        UserDefaults.standard.set(settings.firstMover.rawValue, forKey: firstMoverKey)
        UserDefaults.standard.set(settings.difficulty.rawValue, forKey: difficultyKey)
    }
}
