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
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithPitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithPitch(-1000)
        
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudioWithReverb(80)
    }
    // Reset where in time our audio is playing and stop the player and engine
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.currentTime = 0.0
        stopAllAudio()
    }
    
    // This function plays the recorded audio with a speed based on the passed in rate (chipMunk Darth Vader)
    func playAudio(playRate: float_t) {
        stopAllAudio()
        audioPlayer.rate = playRate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    // This function plays the recorded audio based on the pitch amount passed in
    // We require an AVAudioEngine, AVAudioPlayerNode, and AVAudioUnitTimePitch instance all wired up to accomplish this
    func playAudioWithPitch(pitchAmount: float_t) {
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var audioTimePitch = AVAudioUnitTimePitch()
        audioTimePitch.pitch = pitchAmount
        audioEngine.attachNode(audioTimePitch)
        
        audioEngine.connect(audioPlayerNode, to: audioTimePitch, format: nil)
        audioEngine.connect(audioTimePitch, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()

    }
    // Same as playAudioWithPitch but I switch out the AVAudioUnitTimePitch with AVAudioUnitReverb
    @IBAction func playAudioWithReverb(reverbAmount: float_t) {
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var audioReverb = AVAudioUnitReverb()
        audioReverb.wetDryMix = reverbAmount
        audioEngine.attachNode(audioReverb)
        
        audioEngine.connect(audioPlayerNode, to: audioReverb, format: nil)
        audioEngine.connect(audioReverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
    // Rather than keep calling all 3 lines in each play audio call
    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
