//
//  Audio.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 4/13/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import AVFoundation

open class Audio
{
    static var player:AVAudioPlayer? = nil
    
    class func initialize()
    {
        play("Beep short 07",ofType:"mp3")
    }
    
    class func play(_ filename:String, ofType type:String,volume:Float = 1, pan:Float = 0, rate:Float = 1) -> AVAudioPlayer?
    {
        if Data.Manager.settingsGetBoolForKey(.SettingsAudioOn,defaultValue:true) {
            do
            {
                if let path             = Bundle.main.path(forResource: filename,ofType:type) {
                    
                    let url             = URL(fileURLWithPath: path)
                    
                    let player          = try AVAudioPlayer(contentsOf:url)
                    
                    player.volume       = volume
                    player.pan          = pan
                    player.rate         = rate
                    
                    print("Audio.play: \(filename).\(type), at path=\(path), playing")
                    
                    if !player.play() {
                        print("Audio.play: \(filename).\(type), failed")
                    }
                    
                    return player
                }
            }
            catch {
                print("Audio.play: \(filename).\(type), error=\(error)")
            }
        }
        
        return nil
    }
    
    class func play(_ filename:String) -> AVAudioPlayer?
    {
        let components          = filename.components(separatedBy: ".")
        
        if let prefix = components.first, let suffix = components.last {
            return play(prefix,ofType:suffix)
        }
        
        return nil
    }
    
    class func playItemDecrement() -> AVAudioPlayer?
    {
        player = play("Multimedia button click 194",ofType:"mp3")
        
        return player
    }
    
    class func playItemIncrement() -> AVAudioPlayer?
    {
        player = play("Multimedia button click 158",ofType:"mp3")
        
        return player
    }
    
    class func playItemCrossOut() -> AVAudioPlayer?
    {
        player = play("Multimedia button click 193",ofType:"mp3")
        
        return player
    }
    
    class func playItemDisappear() -> AVAudioPlayer?
    {
        player = play("Multimedia button click 54",ofType:"mp3")
        
        return player
    }
    
}

