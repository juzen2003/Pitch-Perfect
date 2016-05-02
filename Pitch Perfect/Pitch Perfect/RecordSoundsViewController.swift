//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Yu-Jen Chang on 2/10/16.
//  Copyright © 2016 Yu-Jen Chang. All rights reserved.
//

import UIKit
// import AVFoundation to work with audio
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseAndResumeButton: UIButton!
   
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // button & label display
        pauseAndResumeButton.hidden = true
        stopButton.hidden = true
        recordButton.enabled = true
        recordingInProgress.text = "Tap to Record"
        recordingInProgress.hidden = false
    }


    @IBAction func recordAudio(sender: UIButton) {
        // button & label display
        stopButton.hidden = false
        pauseAndResumeButton.hidden = false
        recordingInProgress.text = "Recording in progess"
        recordingInProgress.hidden = false
        recordButton.enabled = false
        
        // create file name & get the path to the document directory where the recorded file is stored
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        // setup a singleton audio session with recording & playback category (we can use record category here)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryRecord)
    
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.meteringEnabled = true
        // audioRecorder's new delegate is RecordSoundsViewController
        audioRecorder.delegate = self
        
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // this function is from AVAudioRecorderDelegate
    // it's called by the system when recording is stopeed
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            // step1: save the recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            // step2: move to the next scene of the app aka perform a segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    // A good place for passing the Model (data)
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            // downcast the sender to RecordedAudio and pass the data
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.hidden = true
        audioRecorder.stop()
        // deactive recording session after recording
        // this is to allow other sounds to play just in case
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // pause and resume reocording
    @IBAction func pauseAndResume(sender: UIButton) {
        if sender.currentImage! == UIImage(named: "pause.png") {
            sender.setImage(UIImage(named: "resume.png"), forState: UIControlState.Normal)
            recordingInProgress.text = "Paused, tap to resuem"
            audioRecorder.pause()
            
        } else {
            sender.setImage(UIImage(named: "pause.png"), forState: UIControlState.Normal)
            recordingInProgress.text = "Recording in progess"
            audioRecorder.record()
        }
    }
    
}

