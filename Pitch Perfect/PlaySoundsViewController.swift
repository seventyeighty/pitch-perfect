//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Bernard Nghiem on 5/11/15.
//  Copyright (c) 2015 Bernard Nghiem. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer : AVAudioPlayer!
    var receivedAudio : RecordedAudio!
    var audioPlayerNode : AVAudioPlayerNode!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioSetup()
        
    }
    
    func audioSetup() {
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithRate(0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithRate(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioModified("pitch", Amount: 1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioModified("pitch", Amount: -1000)
        
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudioModified("reverb", Amount: 80)
    }
    
    // Reset where in time our audio is playing and stop the player and engine
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.currentTime = 0.0
        stopAllAudio()
    }
    
    // This function plays the recorded audio with a speed based on the passed in rate (chipMunk Darth Vader)
    func playAudioWithRate(playRate: float_t) {
        stopAllAudio()
        audioPlayer.rate = playRate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioModified(Type: String, Amount: float_t) {
        stopAllAudio()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        switch Type {
            case "reverb" :
                var audioReverb = AVAudioUnitReverb()
                audioReverb.wetDryMix = Amount
                audioEngine.attachNode(audioReverb)
            
                audioEngine.connect(audioPlayerNode, to: audioReverb, format: nil)
                audioEngine.connect(audioReverb, to: audioEngine.outputNode, format: nil)
            case "pitch" :
                var audioTimePitch = AVAudioUnitTimePitch()
                audioTimePitch.pitch = Amount
                audioEngine.attachNode(audioTimePitch)
                
                audioEngine.connect(audioPlayerNode, to: audioTimePitch, format: nil)
                audioEngine.connect(audioTimePitch, to: audioEngine.outputNode, format: nil)
            default: println("No type was passed in")
        }
        audioPlay(audioFile)
        
    }
    
    func audioPlay(audiofile: AVAudioFile) {
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
