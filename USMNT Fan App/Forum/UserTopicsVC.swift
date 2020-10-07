//
//  AllUserTopicsVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 8/22/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class UserTopicsVC: UIViewController {
    
    var forumTopics: [Topic] = []
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.separatorStyle = .none
        tv.register(TopicCell.self, forCellReuseIdentifier: "userTopicsCell")
        return tv
    }()
    
    let descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "User Topics"
        lbl.font = UIFont(name: "Avenir-Book", size: 20)
        lbl.textColor = .white
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        getTopics()
        setupLayout()
        
    }
    
    func setupLayout() {
        
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(descriptionLbl)
        view.addSubview(tableView)
        
    }
    
    func applyAnchors() {
        
        if #available(iOS 11.0, *) {
            descriptionLbl.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        } else {
            descriptionLbl.anchors(top: view.topAnchor, topPad: 50, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        }
        
        tableView.anchors(top: descriptionLbl.bottomAnchor, topPad: 30, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)! - 40, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func getTopics() {
        
        forumTopics = []
    
        let uid = Auth.auth().currentUser?.uid
        
        Firestore.firestore().collection("Users").document(uid!).collection("UserTopics").getDocuments { (snap1, err) in
            
            guard err == nil else {
                print(err?.localizedDescription ?? "")
                return
            }
            
            if let snap = snap1 {
                
                for document in snap.documents {
                    
                    let docID = document.data()["docID"] as! String
                    
                    Firestore.firestore().collection("Topics").document(docID).getDocument { (snap2, err) in
                        
                        if let snap = snap2 {
                            
                            let data = snap.data()!
                            let timestamp = data["timestamp"] as! Double
                            let topic = data["topic"] as! String
                            let author = data["author"] as! String
                            let authorUID = data["authorUID"] as! String
                            let text = data["text"] as! String
                            let id = snap.documentID
                            let commentCount = data["commentCount"] as! Int
                            let dbref = Firestore.firestore().collection("Topics").document(id)
                            let isSensitive = data["isSensitive"] as! Bool
                            self.forumTopics.append(Topic(topic: topic, timestamp: timestamp, author: author, authorUID: authorUID, text: text, id: id, dbref: dbref, commentCount: commentCount, isSensitive: isSensitive))
                            self.forumTopics.sort { $0.timestamp > $1.timestamp }
                            self.tableView.reloadData()
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }

}

extension UserTopicsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forumTopics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTopicsCell") as! TopicCell
        
        cell.topicLbl.text = forumTopics[indexPath.row].topic
        cell.authorLbl.text = forumTopics[indexPath.row].author
        
        cell.setUserProfileImage(uid: forumTopics[indexPath.row].authorUID)
        
        let lastActiveDate = Date(timeIntervalSince1970: forumTopics[indexPath.row].timestamp)
        let diffInHours = Calendar.current.dateComponents([.hour], from: lastActiveDate, to: Date()).hour ?? 0
        
        if diffInHours >= 8760 {
            let diffInYears = diffInHours / 8760
            cell.lastActiveLbl.text = "last active \(diffInYears) years ago"
        } else if diffInHours >= 24 {
            let diffInDays = diffInHours / 24
            cell.lastActiveLbl.text = "last active \(diffInDays) days ago"
        } else if diffInHours != 0 {
            cell.lastActiveLbl.text = "last active \(diffInHours) hours ago"
        } else {
            cell.lastActiveLbl.text = "last active less than an hour ago"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = TopicVC()
        vc.topic = forumTopics[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
