//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Geoffrey Ching on 2/17/16.
//  Copyright © 2016 Geoffrey Ching. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var url: NSURL!
    var title: String!
    
    init(url:NSURL){
        self.url = url
    }
}