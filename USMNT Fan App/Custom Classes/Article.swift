//
//  Article.swift
//  USMNT Fan App
//
//  Created by Leon Djusberg on 6/30/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import Foundation

class Article {
    
    let title: String
    let url: String
    let timestamp: Double
    
    init(title: String, url: String, timestamp: Double) {
        self.title = title
        self.url = url
        self.timestamp = timestamp
    }
    
}
