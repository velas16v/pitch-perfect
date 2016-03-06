//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Alejandro Velasco on 15/2/16.
//  Copyright © 2016 Las Voces de la Ciudad. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var filePathUrl: NSURL!

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        stopButton.hidden = true
        recordButton.enabled = true
    }
 
    @IBAction func recordAudio(sender: UIButton) {
        
        stopButton.hidden = false
        self.recordingInProgress.text = "Recording"
        recordButton.enabled = false

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as String

        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    @IBAction func stopAudio(sender: UIButton) {
        
        recordButton.hidden = false
        stopButton.hidden = true
        self.recordingInProgress.text = "Tap to Record"
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            _ = RecordedAudio.init(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)

            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
 
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        }else{
            
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "stopRecording"){
            
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            
            playSoundsVC.receivedAudio = data
        }
    }
}

