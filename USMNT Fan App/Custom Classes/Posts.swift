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
    var commentCount: Int
    var dbref: DocumentReference
    var isSensitive: Bool
    
    init() {
        self.topic = ""
        self.timestamp = 0.0
        self.author = ""
        self.authorUID = ""
        self.text = ""
        self.id = ""
        self.commentCount = 0
        self.dbref = Firestore.firestore().collection("Inits").document()
        self.isSensitive = false
    }
    
    init(topic: String, timestamp: Double, author: String, authorUID: String, text: String, id: String, dbref: DocumentReference, commentCount: Int, isSensitive: Bool) {
        
        self.topic = topic
        self.timestamp = timestamp
        self.author = author
        self.authorUID = authorUID
        self.text = text
        self.id = id
        self.dbref = dbref
        self.commentCount = commentCount
        self.isSensitive = isSensitive
        
        dbref.collection("Comments").order(by: "likes").getDocuments { (snap, error) in
            
            for document in snap!.documents {
                
                let data = document.data()
                let topic = self.topic
                let timestamp = data["timestamp"] as! Double
                let author = data["author"] as! String
                let authorUID = data["authorUID"] as! String
                let text = data["text"] as! String
                let id = document.documentID
                let likes = data["likes"] as! Int
                let dbref = self.dbref.collection("Comments").document(id)
                let topicID =  self.id
                let commentCount = data["commentCount"] as! Int
                let isDeleted = data["isDeleted"] as! Bool
                let isSensitive = data["isSensitive"] as! Bool
                let comment = Comment(topic: topic, topicID: topicID, timestamp: timestamp, author: author, authorUID: authorUID, text: text, id: id, likes: likes, depth: 0, dbref: dbref, commentCount: commentCount, isDeleted: isDeleted, isSensitive: isSensitive)
                self.comments.append(comment)
                
            }
            
        }
        
    }
    
    func addComment(timestamp: Double, author: String, authorUID: String, text: String) {
        
        let data: [String:Any] = [
                    "author":author,
                    "authorUID":authorUID,
                    "text":text,
                    "timestamp":timestamp,
                    "likes":0,
                    "commentCount":0,
                    "isDeleted":false,
                    "isSensitive":false
                    ]
        
        var ref: DocumentReference? = nil
        ref = dbref.collection("Comments").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                let comment = Comment(topic: self.topic, topicID: self.id, timestamp: timestamp, author: author, authorUID: authorUID, text: text, id: ref!.documentID, likes: 0, depth: 0, dbref: self.dbref.collection("Comments").document(ref!.documentID), commentCount: 0, isDeleted: false, isSensitive: false)
                self.comments.append(comment)
            }
        }
        
        self.commentCount += 1
        
        // update topic timestamp as well, to inform lastActiveLbl
        
        Firestore.firestore().collection("Topics").document(self.id).getDocument { (snap, err) in
            
            guard err == nil else {
                print(err?.localizedDescription ?? "")
                return
            }
            
            if let snap = snap {
                
                let FIRCommentCount = snap.data()!["commentCount"] as! Int
                snap.reference.updateData(["commentCount" : FIRCommentCount + 1, "timestamp" : Date().timeIntervalSince1970])
                
            }
            
        }
        
    }
    
    
}

class Comment {
    
    var likes: Int
    var topicID: String
    var depth: Int
    let topic: String
    let timestamp: Double
    let author: String
    let authorUID: String
    let text: String
    let id: String
    var comments: [Comment] = []
    var commentCount: Int
    var dbref: DocumentReference
    var userHasVoted = false
    var voteWasLike = true
    var isDeleted: Bool
    var isSensitive: Bool
    
    init() {
        self.likes = 0
        self.topicID = ""
        self.depth = 0
        self.topic = ""
        self.timestamp = 0.0
        self.author = ""
        self.authorUID = ""
        self.text = ""
        self.id = ""
        self.commentCount = 0
        self.dbref = Firestore.firestore().collection("Inits").document()
        self.isDeleted = false
        self.isSensitive = false
    }
    
    init(topic: String, topicID: String, timestamp: Double, author: String, authorUID: String, text: String, id: String, likes: Int, depth: Int, dbref: DocumentReference, commentCount: Int, isDeleted: Bool, isSensitive: Bool) {
        
        self.likes = likes
        self.topicID = topicID
        self.depth = depth
        self.topic = topic
        self.timestamp = timestamp
        self.author = author
        self.authorUID = authorUID
        self.text = text
        self.id = id
        self.dbref = dbref
        self.commentCount = commentCount
        self.isDeleted = isDeleted
        self.isSensitive = isSensitive
        
        // load comments
        
        dbref.collection("Comments").order(by: "likes").getDocuments { (snap, error) in
            
            for document in snap!.documents {
                
                let data = document.data()
                let topic = self.topic
                let timestamp = data["timestamp"] as! Double
                let author = data["author"] as! String
                let authorUID = data["authorUID"] as! String
                let text = data["text"] as! String
                let id = document.documentID
                let likes = data["likes"] as! Int
                let dbref = self.dbref.collection("Comments").document(id)
                let topicID = self.topicID
                let commentCount = data["commentCount"] as! Int
                let isDeleted = data["isDeleted"] as! Bool
                let isSensitive = data["isSensitive"] as! Bool
                let comment = Comment(topic: topic, topicID: topicID, timestamp: timestamp, author: author, authorUID: authorUID, text: text, id: id, likes: likes, depth: self.depth+1, dbref: dbref, commentCount: commentCount, isDeleted: isDeleted, isSensitive: isSensitive)
                self.comments.append(comment)
                
            }
            
        }
        
        // set flag as to whether user has voted on this comment yet
        
        if let user = Auth.auth().currentUser {
            
            Firestore.firestore().collection("Users").document(user.uid).collection("votedOnComments").whereField("docID", isEqualTo: id).getDocuments { (snap, err) in
                
                guard err == nil else {
                    return
                }
                
                if let snap = snap {
                    
                    if snap.documents.count > 0 {
                        self.userHasVoted = true
                        
                        for document in snap.documents {
                            let data = document.data()
                            if data["voteWasLike"] as! Bool == false {
                                self.voteWasLike = false
                            }
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func addComment(timestamp: Double, author: String, authorUID: String, text: String) {
        
        let data: [String:Any] = [
                    "author":author,
                    "authorUID":authorUID,
                    "text":text,
                    "timestamp":timestamp,
                    "likes":0,
                    "commentCount":0,
                    "isDeleted":false,
                    "isSensitive":false
                    ]
        
        var ref: DocumentReference? = nil
        ref = dbref.collection("Comments").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                let comment = Comment(topic: self.topic, topicID: self.topicID, timestamp: timestamp, author: author, authorUID: authorUID, text: text, id: ref!.documentID, likes: 0, depth: self.depth+1, dbref: self.dbref.collection("Comments").document(ref!.documentID), commentCount: 0, isDeleted: false, isSensitive: false)
                self.comments.append(comment)
            }
        }
        
        self.commentCount += 1
        
        // update topic timestamp as well, to inform lastActiveLbl
        
        Firestore.firestore().collection("Topics").document(self.topicID).updateData(["timestamp" : Date().timeIntervalSince1970])
        
        self.dbref.getDocument { (snap, err) in
            
            guard err == nil else {
                print(err?.localizedDescription ?? "")
                return
            }
            
            if let snap = snap {
                
                let FIRCommentCount = snap.data()!["commentCount"] as! Int
                snap.reference.updateData(["commentCount" : FIRCommentCount + 1])
                
            }
            
        }
    }
    
    func like(user: User) {
        
        if userHasVoted == false {
            
            likes += 1
            
            dbref.getDocument { (snap, err) in
                
                guard err == nil else {
                    return
                }
                
                let data = snap?.data()
                let FIRlikes = data?["likes"] as? Int
                
                if let FIRlikes = FIRlikes {
                    self.dbref.updateData(["likes" : FIRlikes + 1])
                }
                
                // mark that user has voted on comment, and whether it was a like or dislike
                
                self.userHasVoted = true
                self.voteWasLike = true
                
                Firestore.firestore().collection("Users").document(user.uid).collection("votedOnComments").addDocument(data: ["docID" : self.id, "voteWasLike" : true])
                
            }
            
        } else if voteWasLike == true {
            
            likes -= 1
            
            dbref.getDocument { (snap, err) in
                
                guard err == nil else {
                    return
                }
                
                let data = snap?.data()
                let FIRlikes = data?["likes"] as? Int
                
                if let FIRlikes = FIRlikes {
                    self.dbref.updateData(["likes" : FIRlikes - 1])
                }
                
            }
            
            // mark that user has not voted on comment
            
            self.userHasVoted = false
            
            Firestore.firestore().collection("Users").document(user.uid).collection("votedOnComments").whereField("docID", isEqualTo: id).getDocuments { (snap, err) in
                
                guard err == nil else {
                    return
                }
                
                if let snap = snap {
                    
                    for document in snap.documents {
                        document.reference.delete()
                    }
                    
                }
                
            }
            
            
        } else { // user has voted, but it was a dislike
            
            likes += 2
            
            dbref.getDocument { (snap, err) in
                
                guard err == nil else {
                    return
                }
                
                let data = snap?.data()
                let FIRlikes = data?["likes"] as? Int
                
                if let FIRlikes = FIRlikes {
                    self.dbref.updateData(["likes" : FIRlikes + 2])
                }
                
            }
            
            // update user vote details in firestore
            
            self.voteWasLike = true
            
            Firestore.firestore().collection("Users").document(user.uid).collection("votedOnComments").whereField("docID", isEqualTo: self.id).getDocuments { (snap, err) in
                
                guard err == nil else {
                    return
                }
                
                if let snap = snap {
                    
                    for document in snap.documents {
                        document.reference.updateData(["voteWasLike" : true])
                    }
                    
                }
                
            }
            
        }
        
        
        
    }
    
    func dislike(user: User) {
        
        if userHasVoted == false {
            
            likes -= 1
            
            dbref.getDocument { (snap, err) in
                
                guard err == nil else {
                    return
                }
                
                let data = snap?.data()
                let FIRlikes = data?["likes"] as? Int
                
                if let FIRlikes = FIRlikes {
                    self.dbref.updateData(["likes" : FIRlikes - 1])
                }
                
                // mark that user has voted on comment, and whether it was a like or dislike
                
                self.userHasVoted = true
                self.voteWasLike = false
                
                Firestore.firestore().collection("Users").document(user.uid).collection("votedOnComments").addDocument(data: ["docID" : self.id, "voteWasLike" : false])
                
            }
            
        } else if voteWasLike == false {
            
            likes += 1
            
            dbref.getDocument { (snap, err) in
                
                guard err == nil else {
                    return
                }
                
                let data = snap?.data()
                let FIRlikes = data?["likes"] as? Int
                
                if let FIRlikes = FIRlikes {
                    self.dbref.updateData(["likes" : FIRlikes + 1])
                }
                
            }
            
            // mark that user has not voted on comment
            
            self.userHasVoted = false
            
            Firestore.firestore().collection("Users").document(user.uid).collection("votedOnComments").whereField("docID", isEqualTo: id).getDocuments { (snap, err) in
                
                guard err == nil else {
                    return
                }
                
                if let snap = snap {
                    
                    for document in snap.documents {
                        document.reference.delete()
                    }
                    
                }
                
                
            }
            
            
        } else { // user has voted, but it was a like
            
            likes -= 2
            
            dbref.getDocument { (snap, err) in
                
                guard err == nil else {
                    return
                }
                
                let data = snap?.data()
                let FIRlikes = data?["likes"] as? Int
                
                if let FIRlikes = FIRlikes {
                    self.dbref.updateData(["likes" : FIRlikes - 2])
                }
                
            }
            
            // update user vote details in firestore
            
            self.voteWasLike = false
            
            Firestore.firestore().collection("Users").document(user.uid).collection("votedOnComments").whereField("docID", isEqualTo: self.id).getDocuments { (snap, err) in
                
                guard err == nil else {
                    return
                }
                
                if let snap = snap {
                    
                    for document in snap.documents {
                        document.reference.updateData(["voteWasLike" : false])
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
