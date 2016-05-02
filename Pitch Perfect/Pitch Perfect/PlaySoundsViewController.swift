//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Yu-Jen Chang on 2/13/16.
//  Copyright © 2016 Yu-Jen Chang. All rights reserved.
//

import UIKit
// import AVFoundation to work with Audio
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var reverbPreset: AVAudioUnitReverb!
    var changePitchEffect: AVAudioUnitTimePitch!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // play the received recorded file 
        audioPlayer = try!
        AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        // open a file for reading, convert receivedAudio NSURL to AVAudioFile
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // play audio with different speed
    func playAudio(speed: Float) {
        // stop all audio before playback (avoid other sound effect overlapping)
        stopAudio()
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayback)
        
        audioPlayer.rate = speed
        // play from the beginning
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        // Play Audio slowly
        playAudio(0.5)
        
    }

    @IBAction func playFastAudio(sender: UIButton) {
        // Play Audio fast
        playAudio(2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        // play chipmunk sound effect (pitch: 1000)
        changePitchEffect = AVAudioUnitTimePitch()
        // set up the pitch, pitch range: -2400 to 2400
        changePitchEffect.pitch = 1000
        playWithDifferentAudioNode(changePitchEffect)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        // play darth vader effect (pitch: -1000)
        changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = -1000
        playWithDifferentAudioNode(changePitchEffect)
    }
    
    // this function is to attach & connect different audio nodes to audio engine for different sound effects
    func playWithDifferentAudioNode (AudioNode: AVAudioNode) {
        stopAudio()
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayback)
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(AudioNode)
        
        audioEngine.connect(audioPlayerNode, to: AudioNode, format: nil)
        audioEngine.connect(AudioNode, to: audioEngine.outputNode, format: nil)
        
        // play an entire audio file
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
    // this function is to stop all audio
    func stopAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func playEcho(sender: UIButton) {
        // echo: have both wet & dry signal, 50%
        // wetDryMix range: 0-100
        reverbPreset = AVAudioUnitReverb()
        // set up environment & wetDryMix rate
        reverbPreset.loadFactoryPreset(.Cathedral)
        reverbPreset.wetDryMix = 50
        playWithDifferentAudioNode(reverbPreset)
    }
    
    @IBAction func playReverb(sender: UIButton) {
        // reverb: full wet signal, 100%
        reverbPreset = AVAudioUnitReverb()
        reverbPreset.loadFactoryPreset(.Plate)
        reverbPreset.wetDryMix = 100
        playWithDifferentAudioNode(reverbPreset)
    }
    
    @IBAction func stopPlayAudio(sender: UIButton) {
        stopAudio()
        
    }

}
