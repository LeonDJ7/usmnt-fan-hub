//
//  Event.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 1/14/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import Foundation

class Event {
    
    let name: String
    let month: Int
    let day: Int
    
    init(name: String, month: Int, day: Int) {
        self.name = name
        self.month = month
        self.day = day
    }
    
}
