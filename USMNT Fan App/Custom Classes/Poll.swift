//
//  Poll.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 8/4/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import Foundation

class Poll {
    
    let question: String
    let author: String
    let authorUID: String
    let answer1: String
    let answer2: String
    let answer3: String
    let answer4: String
    let answer1Score: Double
    let answer2Score: Double
    let answer3Score: Double
    let answer4Score: Double
    let timestamp: Double
    let totalVotes: Double
    let totalAnswerOptions: Double
    var docID: String
    let userVote: Int
    
    init(question: String, author: String, authorUID: String, answer1: String, answer2: String, answer3: String, answer4: String, answer1Score: Double, answer2Score: Double, answer3Score: Double, answer4Score: Double, timestamp: Double, totalAnswerOptions: Double, docID: String, userVote: Int) {
        self.question = question
        self.author = author
        self.authorUID = authorUID
        self.answer1 = answer1
        self.answer2 = answer2
        self.answer3 = answer3
        self.answer4 = answer4
        self.answer1Score = answer1Score
        self.answer2Score = answer2Score
        self.answer3Score = answer3Score
        self.answer4Score = answer4Score
        self.timestamp = timestamp
        self.totalVotes = answer1Score + answer2Score + answer3Score + answer4Score
        self.totalAnswerOptions = totalAnswerOptions
        self.docID = docID
        self.userVote = userVote
    }
}
