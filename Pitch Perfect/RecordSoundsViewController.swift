//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Bernard Nghiem on 5/10/15.
//  Copyright (c) 2015 Bernard Nghiem. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var recordedAudio:RecordedAudio!
    var audioRecorder:AVAudioRecorder!
    var isRecording:Bool!
    var isStarted:Bool!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        
        // I've set these here because viewDidLoad() won't be called again if I push
        // back on my navigator from the play screen.
        isRecording = false;
        isStarted = false;
        
        // Reset UI when viw appears again (on load or back button)
        recordButton.enabled = true
        recordingLabel.text = "Tap to Record"
        recordingLabel.hidden = false
        pauseLabel.hidden = true
        stopButton.hidden = true
    }

    @IBAction func recordButtonToggle(sender: UIButton) {
        if isRecording! {
            audioRecorder.pause()
            recordingLabel.text = "recording is paused"
            pauseLabel.text = "tap to unpause"
            recordButton.setImage(UIImage(named:"microphone.png"),forState:UIControlState.Normal)
            isRecording = false
        }
        else {
            recordAudio()
        }
    }
    
    func recordAudio() {
        stopButton.hidden = false
        recordButton.setImage(UIImage(named:"pauseButton.png"),forState:UIControlState.Normal)
        recordingLabel.text = "recording in progress"
        pauseLabel.text = "tap to pause"
        recordingLabel.hidden = false
        
        if !isStarted! {
            pauseLabel.hidden = false
            createAudioFile()
        }
        
        audioRecorder.record()
        isRecording = true
    }
    
    func createAudioFile() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        isStarted = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        // If the recording finished succesfully, kick it off to the stopRecording segue
        // Otherwise, report error in console and set back UI
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            println("Recording was not succesful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Here we are send our recordedAudio object we created to the play controller
        if segue.identifier == "stopRecording" {
            let playSoundsVC : PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }
    @IBAction func stopRecordingAudio(sender: UIButton) {
        recordingLabel.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

