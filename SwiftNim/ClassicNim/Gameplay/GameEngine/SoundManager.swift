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

    enum SoundName: String {
        case endgame
        case select
        case swoosh
    }

    func play(sound: SoundName) {
        try? AVAudioSession.sharedInstance().setCategory(.ambient)
        try? AVAudioSession.sharedInstance().setActive(true, options: [])
        if let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "m4a") {
            player.removeAllItems()
            player.insert(AVPlayerItem(url: url), after: nil)
            player.play()
        }
    }
}
