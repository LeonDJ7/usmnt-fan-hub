//
//  ChatTopics.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 6/12/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Topic {
    
    let topic: String
    let timestamp: Double
    let author: String
    let authorUID: String
    let text: String
    let id: String
    var comments: [Comment] = []
    var dbref: DocumentReference
    
    init() {
        self.topic = ""
        self.timestamp = 0.0
        self.author = ""
        self.authorUID = ""
        self.text = ""
        self.id = ""
        self.dbref = Firestore.firestore().collection("Inits").document()
    }
    
    init(topic: String, timestamp: Double, author: String, authorUID: String, text: String, id: String, dbref: DocumentReference) {
        self.topic = topic
        self.timestamp = timestamp
        self.author = author
        self.authorUID = authorUID
        self.text = text
        self.id = id
        self.dbref = dbref
    }
    
    func loadComments() {
        
        dbref.collection("Comments").getDocuments { (snap, error) in
            
            for document in snap!.documents {
                
                let data = document.data()
                let topic = data["topic"] as! String
                let timestamp = data["timestamp"] as! Double
                let author = data["author"] as! String
                let authorUID = data["authorUID"] as! String
                let text = data["text"] as! String
                let id = document.documentID
                let likes = data["likes"] as! Int
                let dbref = self.dbref.collection("Comments").document(id)
                let comment = Comment(topic: topic, timestamp: timestamp, author: author, authorUID: authorUID, text: text, id: id, likes: likes, dbref: dbref)
                self.comments.append(comment)
                
            }
            
        }
        
    }
    
    func addComment(topic: String, timestamp: Double, author: String, authorUID: String, text: String) {
        
        let data: [String:Any] = [
                    "topic":topic,
                    "author":author,
                    "authorUID":authorUID,
                    "text":text,
                    "timestamp":timestamp,
                    ]
        
        var ref: DocumentReference? = nil
        ref = dbref.collection("Comments").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                let comment = Comment(topic: topic, timestamp: timestamp, author: author, authorUID: authorUID, text: text, id: ref!.documentID, likes: 0, dbref: self.dbref.collection("Comments").document(ref!.documentID))
                self.comments.append(comment)
            }
        }
        
    }
    
    
}

class Comment: Topic {
    
    var likes: Int
    
    override init() {
        self.likes = 0
        super.init()
    }
    
    init(topic: String, timestamp: Double, author: String, authorUID: String, text: String, id: String, likes: Int, dbref: DocumentReference) {
        self.likes = likes
        super.init(topic: topic, timestamp: timestamp, author: author, authorUID: authorUID, text: text, id: id, dbref: dbref)
    }
    
}
