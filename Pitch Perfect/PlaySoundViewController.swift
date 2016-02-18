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
		stopResetAll()
		
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
		}catch{
			ErrorMessage.hidden = false
		}
		
		audioNode.play()
	}
	
	
	func playWithSpeed(speed: Float){
		stopResetAll()
		
		audioPlayer.rate = speed
		audioPlayer.currentTime = 0
		
		audioPlayer.play()
	}
	
	func playWithEcho(delay: Float){
		stopResetAll()
		
		let audioNode = AVAudioPlayerNode()
		let audioUnitDelay = AVAudioUnitDelay()
		audioUnitDelay.delayTime = NSTimeInterval(delay)
		
		audioEngine.attachNode(audioNode)
		audioEngine.attachNode(audioUnitDelay)
		
		audioEngine.connect(audioNode, to:audioUnitDelay, format: nil)
		audioEngine.connect(audioUnitDelay as AVAudioNode, to:audioEngine.outputNode, format: nil)
		
		audioNode.scheduleFile(self.audioFile, atTime: nil, completionHandler: nil)
		do{
			try audioEngine.start()
		}catch{
			ErrorMessage.hidden = false
		}
		
		audioNode.play()
	}
	
	func playWithReverb(){
		stopResetAll()
		
		let audioNode = AVAudioPlayerNode()
		let audioUnitReverb = AVAudioUnitReverb()
		audioUnitReverb.loadFactoryPreset(.LargeHall)
		audioUnitReverb.wetDryMix = 50
		
		audioEngine.attachNode(audioNode)
		audioEngine.attachNode(audioUnitReverb)
		
		audioEngine.connect(audioNode, to:audioUnitReverb, format: nil)
		audioEngine.connect(audioUnitReverb as AVAudioNode, to:audioEngine.outputNode, format: nil)
		
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
		playWithReverb()
	}
	
	@IBAction func stopPlaying(sender: AnyObject) {
		stopResetAll()
	}
	
}
