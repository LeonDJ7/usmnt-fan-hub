//
//  SavedTopicsVC.swift
//  USMNT Fan App
//
//  Created by Leon Djusberg on 6/6/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class SavedTopicsVC: UIViewController {
    
    var forumTopics: [Topic] = []
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.separatorStyle = .none
        tv.register(TopicCell.self, forCellReuseIdentifier: "savedTopicsCell")
        return tv
    }()
    
    let descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Saved Topics"
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
        
        Firestore.firestore().collection("Users").document(uid!).collection("SavedTopics").getDocuments { (snap1, err) in
            
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
                            let lastActiveTimestamp = data["lastActiveTimestamp"] as! Double
                            let timestamp = data["timestamp"] as! Double
                            let topic = data["topic"] as! String
                            let author = data["author"] as! String
                            let authorUID = data["authorUID"] as! String
                            let text = data["text"] as! String
                            let id = snap.documentID
                            let commentCount = data["commentCount"] as! Int
                            let dbref = Firestore.firestore().collection("Topics").document(id)
                            let isSensitive = data["isSensitive"] as! Bool
                            self.forumTopics.append(Topic(topic: topic, lastActiveTimestamp: lastActiveTimestamp, timestamp: timestamp, author: author, authorUID: authorUID, text: text, id: id, dbref: dbref, commentCount: commentCount, isSensitive: isSensitive))
                            self.forumTopics.sort { $0.lastActiveTimestamp > $1.lastActiveTimestamp }
                            self.tableView.reloadData()
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }

}

extension SavedTopicsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forumTopics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedTopicsCell") as! TopicCell
        
        cell.topicLbl.text = forumTopics[indexPath.row].topic
        cell.authorLbl.text = forumTopics[indexPath.row].author
        
        cell.setUserProfileImage(uid: forumTopics[indexPath.row].authorUID)
        
        let lastActiveDate = Date(timeIntervalSince1970: forumTopics[indexPath.row].lastActiveTimestamp)
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
        
        var blocked: Bool = false
        cell.unblockBtn.setTitle("unblock \(forumTopics[indexPath.row].author)?", for: .normal)
        
        for uid in blockedUIDs {
            
            if forumTopics[indexPath.row].authorUID == uid {
                blocked = true
                break
            }
            
        }
        
        if let user = Auth.auth().currentUser {
            
            if user.uid != forumTopics[indexPath.row].authorUID {
                // not users post
                
                if blocked == true {
                    for view in cell.subviews {
                        view.isHidden = true
                    }
                    cell.blockedLbl.isHidden = false
                    cell.unblockBtn.isHidden = false
                } else {
                    
                    if forumTopics[indexPath.row].isSensitive == true {
                        
                        let ignore = (UserDefaults.standard.bool(forKey: forumTopics[indexPath.row].id + "ignoreSensitiveContent"))
                        if ignore == true {
                            
                            for view in cell.subviews {
                                view.isHidden = false
                            }
                            cell.sensitiveContentWarningBtn.isHidden = true
                            cell.blockedLbl.isHidden = true
                            cell.unblockBtn.isHidden = true
                            
                        } else {
                            for view in cell.subviews {
                                view.isHidden = true
                            }
                            cell.sensitiveContentWarningBtn.isHidden = false
                        }
                        
                    } else {
                        for view in cell.subviews {
                            view.isHidden = false
                        }
                        cell.sensitiveContentWarningBtn.isHidden = true
                        cell.blockedLbl.isHidden = true
                        cell.unblockBtn.isHidden = true
                    }
                    
                }
                
            }
            
        } else {
            // definately not users post
            
            if blocked == true {
                for view in cell.subviews {
                    view.isHidden = true
                }
                cell.blockedLbl.isHidden = false
                cell.unblockBtn.isHidden = false
            } else {
                
                if forumTopics[indexPath.row].isSensitive == true {
                    
                    let ignore = (UserDefaults.standard.bool(forKey: forumTopics[indexPath.row].id + "ignoreSensitiveContent"))
                    
                    if ignore == true {
                        
                        for view in cell.subviews {
                            view.isHidden = false
                        }
                        cell.sensitiveContentWarningBtn.isHidden = true
                        cell.blockedLbl.isHidden = true
                        cell.unblockBtn.isHidden = true
                        
                    } else {
                        for view in cell.subviews {
                            view.isHidden = true
                        }
                        cell.sensitiveContentWarningBtn.isHidden = false
                    }
                    
                } else {
                    for view in cell.subviews {
                        view.isHidden = false
                    }
                    cell.sensitiveContentWarningBtn.isHidden = true
                    cell.blockedLbl.isHidden = true
                    cell.unblockBtn.isHidden = true
                }
                
            }
            
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
