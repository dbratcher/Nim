//
//  SoundManager.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 5/22/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    private let player = AVQueuePlayer()

    func playEndGameSound() {
        if let url = Bundle.main.url(forResource: "endgame", withExtension: "m4a") {
            player.removeAllItems()
            player.insert(AVPlayerItem(url: url), after: nil)
            player.play()
        }
    }

    func playSelectSound() {
        if let url = Bundle.main.url(forResource: "select", withExtension: "m4a") {
            player.removeAllItems()
            player.insert(AVPlayerItem(url: url), after: nil)
            player.play()
        }
    }

    func playSwooshSound() {
        if let url = Bundle.main.url(forResource: "swoosh", withExtension: "m4a") {
            player.removeAllItems()
            player.insert(AVPlayerItem(url: url), after: nil)
            player.play()
        }
    }
}
