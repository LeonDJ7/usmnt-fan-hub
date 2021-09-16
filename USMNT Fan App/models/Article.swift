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
    let imageURL: String
    
    init(title: String, url: String, timestamp: Double, imageURL: String) {
        self.title = title
        self.url = url
        self.timestamp = timestamp
        self.imageURL = imageURL
    }
    
}
