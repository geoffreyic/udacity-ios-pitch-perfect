//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Geoffrey Ching on 2/15/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController {

    @IBOutlet weak var Microphone: UIButton!
    @IBOutlet weak var RecordText: UILabel!
    @IBOutlet weak var StopButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        StopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func startRecording(sender: AnyObject) {
        RecordText.text = "Recording..."
        StopButton.hidden = false
    }

    @IBAction func stopRecording(sender: AnyObject) {
        RecordText.text = "Press Microphone to Record"
        
        performSegueWithIdentifier("PlayRecordingSegue", sender: self)
    }
    
    // overide func prepareForSegue
    
}

