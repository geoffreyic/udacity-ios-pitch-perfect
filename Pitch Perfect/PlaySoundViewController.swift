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
	
	@IBOutlet weak var ErrorMessage: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		audioEngine = AVAudioEngine()
		
		do{
			try audioPlayer = AVAudioPlayer.init(contentsOfURL: recordedAudio.url)
		}catch{
			ErrorMessage.hidden = false
		}
		
		audioPlayer.enableRate = true
		
		do{
			try self.audioFile = AVAudioFile(forReading: recordedAudio.url)
		}catch{
			ErrorMessage.hidden = false
		}
		
		
	}
	
	func playWithPitch(pitch: Float){
		
		let audioTimePitch = AVAudioUnitTimePitch()
		audioTimePitch.pitch = pitch
		
		playAudioNodeEffect(audioTimePitch)
	}
	
	
	func playWithSpeed(speed: Float){
		stopResetAll()
		
		audioPlayer.rate = speed
		audioPlayer.currentTime = 0
		
		audioPlayer.play()
	}
	
	func playWithEcho(delay: Float){
		
		let audioUnitDelay = AVAudioUnitDelay()
		audioUnitDelay.delayTime = NSTimeInterval(delay)
		
		playAudioNodeEffect(audioUnitDelay)
	}
	
	func playWithReverb(preset:AVAudioUnitReverbPreset){
		
		let audioUnitReverb = AVAudioUnitReverb()
		audioUnitReverb.loadFactoryPreset(preset)
		audioUnitReverb.wetDryMix = 50
		
		playAudioNodeEffect(audioUnitReverb)
	}
	
	
	// new function that accepts AVAudioNode effect. thanks for the feedback!
	func playAudioNodeEffect(effect:AVAudioNode){
		stopResetAll()
		
		let audioNode = AVAudioPlayerNode()
		
		audioEngine.attachNode(audioNode)
		audioEngine.attachNode(effect)
		
		audioEngine.connect(audioNode, to:effect, format: nil)
		audioEngine.connect(effect as AVAudioNode, to:audioEngine.outputNode, format: nil)
		
		audioNode.scheduleFile(self.audioFile, atTime: nil, completionHandler: nil)
		do{
			try audioEngine.start()
		}catch{
			ErrorMessage.hidden = false
		}
		
		audioNode.play()
	}
	
	
	func stopResetAll(){
		audioPlayer.stop()
		audioEngine.stop()
		audioEngine.reset()
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	
	@IBAction func playChipmunk(sender: AnyObject) {
		playWithPitch(1000)
	}
	@IBAction func playVader(sender: AnyObject) {
		playWithPitch(-1000)
	}
	@IBAction func playFast(sender: AnyObject) {
		playWithSpeed(2.0)
	}
	@IBAction func playSlow(sender: AnyObject) {
		playWithSpeed(0.5)
	}
	@IBAction func playEcho(sender: AnyObject) {
		playWithEcho(0.2)
	}
	
	@IBAction func playReverb(sender: AnyObject) {
		playWithReverb(AVAudioUnitReverbPreset.LargeHall)
	}
	
	@IBAction func stopPlaying(sender: AnyObject) {
		stopResetAll()
	}
	
}

