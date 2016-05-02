//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Yu-Jen Chang on 2/17/16.
//  Copyright © 2016 Yu-Jen Chang. All rights reserved.
//

import Foundation

// this class is for stored recorded audio file
class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    // Initializer
    init(filePathUrl: NSURL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}