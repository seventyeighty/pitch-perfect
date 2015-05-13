//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Bernard Nghiem on 5/12/15.
//  Copyright (c) 2015 Bernard Nghiem. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    // Initialize object with the passed in recordedAudio properties
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}