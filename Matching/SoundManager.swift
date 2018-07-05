//
//  SoundManager.swift
//  Matching
//
//  Created by aml on 6/21/18.
//  Copyright © 2018 aml. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    func playSound(effect:SoundEffect) {
        var sound = ""
        switch effect {
            case .flip:
                sound = "cardflip"
            case .shuffle:
                sound = "shuffle"
            case .match:
                sound = "dingcorrect"
            case .nomatch:
                sound = "dingwrong"
            default:
                sound = ""
        }
        let path = Bundle.main.path(forResource: sound, ofType: "wav")
        
        guard (path != nil) else {
            print("Couldn't find wav file")
            return
        }
        
        let soundURL = URL.init(fileURLWithPath: path!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        }
        catch {
            print("Couldn't create AudioPlayer from URL")
            return
        }
        
        
    }
}
