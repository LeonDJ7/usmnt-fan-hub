//
//  ChatTopics.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 6/12/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import Foundation

class Topic {
    
    let topic: String
    let timestamp: Double
    let author: String
    let authorUID: String
    let description: String
    
    init(topic: String, timestamp: Double, author: String, authorUID: String, description: String) {
        self.topic = topic
        self.timestamp = timestamp
        self.author = author
        self.authorUID = authorUID
        self.description = description
    }
    
}
