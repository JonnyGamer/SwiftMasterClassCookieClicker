//
//  Sounds.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/19/21.
//

import Foundation
import SpriteKit.SKAction
import AVFoundation

enum Sounds: String {
    case oneUp = "smb_1up"
    case bowserFire = "smb_bowserfire"
    case die = "smb_die"
    case breakBrickBlock = "break"
    case fireball = "smb_fireball"
    case flagpole = "smb_flagpole"
    case stomp = "smb_stomp"
    case jump = "smb_jump"
    case kick = "smb_kick"
}

enum MusicTracks: String {
    case overworldTheme = "overworld-theme"
}

extension SKAction {
    static func sound(_ this: Sounds) -> SKAction {
        return .playSoundFileNamed(this.rawValue, waitForCompletion: true)
    }
    static func soundAsync(_ this: Sounds) -> SKAction {
        return .playSoundFileNamed(this.rawValue, waitForCompletion: false)
    }
}

struct BackgroundMusic {
    
    private static var backgroundMusicPlayer: AVAudioPlayer!

    static func play(_ filename: MusicTracks) {
        backgroundMusicPlayer?.stop()

        let url = Bundle.main.url(forResource: filename.rawValue, withExtension: "mp3")

        if (url == nil) {
            print("Could not find the file \(filename)")
        }

        do { backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url!, fileTypeHint: nil) } catch let error as NSError { print(error.debugDescription)}

        if backgroundMusicPlayer == nil {
            print("Could not create audio player")
        }

        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    }
    
    static func stop() {
        backgroundMusicPlayer?.stop()
    }
    
}


//var Sound: AVAudioPlayer!
//
//func playSound(filename: String) {
//
//    let url = Bundle.main.url(forResource: filename, withExtension: "wav")
//
//    if (url == nil) {
//        print("Could not find the file \(filename)")
//    }
//
//    do { Sound = try AVAudioPlayer(contentsOf: url!, fileTypeHint: nil) } catch let error as NSError { print(error.debugDescription)}
//
//    if Sound == nil {
//        print("Could not create audio player")
//    }
//
//    Sound.prepareToPlay()
//    Sound.play()
//}
