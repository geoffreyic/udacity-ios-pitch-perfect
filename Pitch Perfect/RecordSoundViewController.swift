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
    
    var recorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        StopButton.hidden = true
        PauseResumeButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        }catch{
            
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
            RecordText.text = "Press resume to resume recording"
        }else{
            PauseResumeButton.setImage(UIImage(named: "Pause"), forState: .Normal)
            recorder.record()
            RecordText.text = "Recording..."
        }
    }

    @IBAction func stopRecording(sender: AnyObject) {
        RecordText.text = "Press Microphone to Record"
        Microphone.enabled = true
        PauseResumeButton.setImage(UIImage(named: "Pause"), forState: .Normal)
        
        recorder.stop()
        
        do{
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setActive(false)
        }catch{}
        
        recordedAudio = RecordedAudio(url: recorder.url)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        // do stuff on finish
        
        self.performSegueWithIdentifier("PlayRecordingSegue", sender: recordedAudio)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if(segue.identifier == "PlayRecordingSegue"){
            let vc:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let ra:RecordedAudio = sender as! RecordedAudio
            
            vc.recordedAudio = ra
            
            
        }
        
    }
    
}

