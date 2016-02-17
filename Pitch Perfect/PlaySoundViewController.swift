//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Geoffrey Ching on 2/15/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    var recordedAudio:RecordedAudio!
    
    var audioFile:AVAudioFile!
    var audioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        audioEngine = AVAudioEngine()
        
        print(recordedAudio.url)
        
        do{
            try audioPlayer = AVAudioPlayer.init(contentsOfURL: recordedAudio.url)
        }catch{}
        
        audioPlayer.enableRate = true
        
        do{
            try self.audioFile = AVAudioFile(forReading: recordedAudio.url)
        }catch{}
        
        
    }
    
    func playWithPitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioNode = AVAudioPlayerNode()
        let audioTimePitch = AVAudioUnitTimePitch()
        audioTimePitch.pitch = pitch
        
        audioEngine.attachNode(audioNode)
        audioEngine.attachNode(audioTimePitch)
        
        audioEngine.connect(audioNode, to:audioTimePitch, format: nil)
        audioEngine.connect(audioTimePitch as AVAudioNode, to:audioEngine.outputNode, format: nil)
        
        
        
        audioNode.scheduleFile(self.audioFile, atTime: nil, completionHandler: nil)
        do{
            try audioEngine.start()
        }catch{}
        
        audioNode.play()
    }
    
    
    func playWithSpeed(speed: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0
        
        audioPlayer.play()
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func playChipmunk(sender: AnyObject) {
        print("chipmunk")
        playWithPitch(1000)
    }
    @IBAction func playVader(sender: AnyObject) {
        print("I'm joinging the dark side!!!!")
        playWithPitch(-1000)
    }
    @IBAction func playFast(sender: AnyObject) {
        print("fast")
        playWithSpeed(2.0)
    }
    @IBAction func playSlow(sender: AnyObject) {
        print("slow")
        playWithSpeed(0.5)
    }

    
    
    
}
