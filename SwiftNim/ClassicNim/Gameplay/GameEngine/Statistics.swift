//
//  Statistics.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 1/28/20.
//  Copyright © 2020 Drew Bratcher. All rights reserved.
//

import Foundation

typealias Seconds = Double

struct Statistics: Codable {
    private(set) var totalWins: UInt
    private(set) var totalLosses: UInt

    private(set) var easyWins: UInt
    private(set) var easyLosses: UInt

    private(set) var mediumWins: UInt
    private(set) var mediumLosses: UInt

    private(set) var hardWins: UInt
    private(set) var hardLosses: UInt

    var onePlayerTimePlayed: Seconds
    var twoPlayerTimePlayed: Seconds

    private static let statisticsKey = "statisticsKey"

    private static let empty = Statistics(totalWins: 0, totalLosses: 0,
                                          easyWins: 0, easyLosses: 0,
                                          mediumWins: 0, mediumLosses: 0,
                                          hardWins: 0, hardLosses: 0,
                                          onePlayerTimePlayed: 0, twoPlayerTimePlayed: 0)

    static var shared: Statistics = {
        guard let data = UserDefaults.standard.object(forKey: statisticsKey) as? Data else { return empty }
        let decodedStats = try? PropertyListDecoder().decode(Statistics.self, from: data)
        return decodedStats ?? empty
    }()

    static func reset() {
        Statistics.empty.save()
        Statistics.shared = Statistics.empty
    }

    func save() {
        let encodedStats = try? PropertyListEncoder().encode(self)
        UserDefaults.standard.set(encodedStats, forKey: Statistics.statisticsKey)
    }

    mutating func onePlayerGameEnded(with win: Bool, on difficulty: Difficulty) {
        win ? (totalWins += 1) : (totalLosses += 1)
        switch difficulty {
        case .easy:
            win ? (easyWins += 1) : (easyLosses += 1)

        case .medium:
            win ? (mediumWins += 1) : (mediumLosses += 1)

        case .hard:
            win ? (hardWins += 1) : (hardLosses += 1)
        }

        save()
    }
}
