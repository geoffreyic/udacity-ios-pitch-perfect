//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Geoffrey Ching on 2/15/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var Microphone: UIButton!
    @IBOutlet weak var RecordText: UILabel!
    @IBOutlet weak var StopButton: UIButton!
    @IBOutlet weak var PauseResumeButton: UIButton!
    @IBOutlet weak var ErrorMessage: UILabel!
    
    var recorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

    @IBAction func startRecording(sender: AnyObject) {
        RecordText.text = "Recording..."
        StopButton.hidden = false
        PauseResumeButton.hidden = false
        Microphone.enabled = false
        
        let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let fileName = formatter.stringFromDate(NSDate())+".wav"
        let pathArray = [directory, fileName]
        
        let filePath = NSURL.fileURLWithPathComponents(pathArray)!
        
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        }catch{
            ErrorMessage.hidden = false
        }
        
        recorder = try! AVAudioRecorder(URL: filePath, settings: [:])
        recorder.delegate = self
            
        recorder.meteringEnabled = true;
            
        recorder.record()
        
    }
    @IBAction func pauseResumeRecording(sender: AnyObject) {
        
        if(recorder.recording){
            PauseResumeButton.setImage(UIImage(named: "Resume"), forState: .Normal)
            recorder.pause()
            RecordText.text = "Tap resume to continue recording"
        }else{
            PauseResumeButton.setImage(UIImage(named: "Pause"), forState: .Normal)
            recorder.record()
            RecordText.text = "Recording..."
        }
    }

    @IBAction func stopRecording(sender: AnyObject) {
        RecordText.text = "Tap Microphone to Record"
        Microphone.enabled = true
        PauseResumeButton.setImage(UIImage(named: "Pause"), forState: .Normal)
        PauseResumeButton.hidden = true
        StopButton.hidden = true
        
        recorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do{
            try audioSession.setActive(false)
        }catch{
            ErrorMessage.hidden = false
        }
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(url: recorder.url)
            self.performSegueWithIdentifier("PlayRecordingSegue", sender: recordedAudio)
        }else{
            ErrorMessage.hidden = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if(segue.identifier == "PlayRecordingSegue"){
            let vc:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let ra:RecordedAudio = sender as! RecordedAudio
            
            vc.recordedAudio = ra
        }
    }
    
}

