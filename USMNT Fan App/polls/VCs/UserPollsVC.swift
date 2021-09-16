//
//  UserPollsVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 3/15/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class UserPollsVC: UIViewController {
    
    var polls: [Poll] = []
    var maxPollsLoaded = 10
    var timestampCeiling = Double(Date().timeIntervalSince1970) // set to the last poll's timestamp in polls array, so that it knows how to load subsequent polls if it has to
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.register(PollsCell.self, forCellReuseIdentifier: "userPollsCell")
        return tv
    }()
    
    let descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "User Polls"
        lbl.font = UIFont(name: "Avenir-Book", size: 20)
        lbl.textColor = .white
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadPolls()
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
        
        tableView.anchors(top: descriptionLbl.bottomAnchor, topPad: 30, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)! - 50, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func loadPolls() {
    
        let uid = Auth.auth().currentUser?.uid
        
        Firestore.firestore().collection("Users").document(uid!).collection("UserPolls").order(by: "timestamp", descending: true).whereField("timestamp", isLessThan: timestampCeiling).limit(to: 10).getDocuments { (snap1, err) in
            
            let userCount = snap1!.documents.count
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                
                if let snap = snap1 {
                    
                    for document in snap.documents {
                        
                        let docID = document.data()["docID"] as! String

                        Firestore.firestore().collection("Polls").document(docID).getDocument { (snap2, err) in
                            
                            if let snap = snap2 {
                                
                                let data = snap.data()!
                                let poll = Poll(question: data["question"] as! String, author: data["author"] as! String, authorUID: data["authorUID"] as! String, answer1: data["answer1"] as! String, answer2: data["answer2"] as! String, answer3: data["answer3"] as! String, answer4: data["answer4"] as! String, answer1Score: data["answer1Score"] as! Double, answer2Score: data["answer2Score"] as! Double, answer3Score: data["answer3Score"] as! Double, answer4Score: data["answer4Score"] as! Double, timestamp: data["timestamp"] as! Double, totalAnswerOptions: data["totalAnswerOptions"] as! Double, docID: docID, userVote: 0, isSensitive: data["isSensitive"] as! Bool)
                                self.polls.append(poll)
                                
                                self.polls.sort { $0.timestamp > $1.timestamp }
                                
                                if (self.polls.count == self.maxPollsLoaded) || self.polls.count == userCount {
                                    
                                    self.tableView.reloadData()
                                    
                                    if (self.polls.count > 0) {
                                        self.timestampCeiling = self.polls[self.polls.count-1].timestamp
                                    }
                                    
                                    self.maxPollsLoaded += 10
                                    
                                }
                                
                            }
                                
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func deletePollAlert(row: Int) {
        
        print("hiiiiiiii")
        
        guard let user = Auth.auth().currentUser else {
            tableView.reloadData()
            return
        }
        
        guard user.uid == polls[row].authorUID else {
            tableView.reloadData()
            return
        }
        
        let alert = UIAlertController(title: "just checking", message: "are you sure you want to delete this poll?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            let docID = self.polls[row].docID
            
            Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("UserPolls").whereField("docID", isEqualTo: docID).getDocuments { (snap, err) in
                
                guard err == nil else {
                    print(err?.localizedDescription ?? "")
                    return
                }
                
                if let snap = snap {
                    for document in snap.documents {
                        document.reference.delete()
                    }
                }
                
            }
            
            Firestore.firestore().collection("Polls").document(docID).collection("Voters").getDocuments { (snap1, err) in
                
                guard err == nil else {
                    print(err?.localizedDescription ?? "")
                    return
                }
                
                if let snap = snap1 {
                    
                    for document in snap.documents {
                        
                        let data = document.data()
                        let voterUID = data["uid"] as! String
                        
                        Firestore.firestore().collection("Users").document(voterUID).collection("SavedPolls").whereField("docID", isEqualTo: docID).getDocuments { (snap2, err) in
                            
                            guard err == nil else {
                                print(err?.localizedDescription ?? "")
                                return
                            }
                            
                            if let snap = snap2 {
                                for document in snap.documents {
                                    document.reference.delete()
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
            
            
            self.polls.remove(at: row)
            self.tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
            Firestore.firestore().collection("Polls").document(docID).delete()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UserPollsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return polls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userPollsCell") as! PollsCell
        cell.delegate = self
        
        if polls[indexPath.row].totalAnswerOptions == 3 {
            
            cell.answer4Lbl.isHidden = true
            cell.answer4Btn.isHidden = true
            let constraint: NSLayoutConstraint = cell.answer3Lbl.bottomAnchor.constraint(equalTo: cell.cellView.bottomAnchor, constant: -5)
            constraint.isActive = true
            
        } else if polls[indexPath.row].totalAnswerOptions == 2 {
            
            cell.answer4Lbl.isHidden = true
            cell.answer4Btn.isHidden = true
            cell.answer3Lbl.isHidden = true
            cell.answer3Btn.isHidden = true
            let constraint: NSLayoutConstraint = cell.answer2Lbl.bottomAnchor.constraint(equalTo: cell.cellView.bottomAnchor, constant: -5)
            constraint.isActive = true
            
        } else { // just include for good practice
            
        }
        
        cell.deleteBtn.tag = indexPath.row
        cell.timestamp = polls[indexPath.row].timestamp
        cell.setUserProfileImage(uid: polls[indexPath.row].authorUID)
        cell.questionLbl.text = polls[indexPath.row].question
        cell.authorLbl.text = polls[indexPath.row].author
        cell.totalVotesLbl.text = String(Int(polls[indexPath.row].totalVotes))
        cell.answer1Lbl.text = polls[indexPath.row].answer1
        cell.answer2Lbl.text = polls[indexPath.row].answer2
        cell.answer3Lbl.text = polls[indexPath.row].answer3
        cell.answer4Lbl.text = polls[indexPath.row].answer4
        
        var a1perc = 0.0
        var a2perc = 0.0
        var a3perc = 0.0
        var a4perc = 0.0
        
        if polls[indexPath.row].totalVotes != 0 {
            
            a1perc = polls[indexPath.row].answer1Score / polls[indexPath.row].totalVotes * 100
            a2perc = polls[indexPath.row].answer2Score / polls[indexPath.row].totalVotes * 100
            a3perc = polls[indexPath.row].answer3Score / polls[indexPath.row].totalVotes * 100
            a4perc = polls[indexPath.row].answer4Score / polls[indexPath.row].totalVotes * 100
            
        } else {
           
           a1perc = 0.0
           a2perc = 0.0
           a3perc = 0.0
           a4perc = 0.0
           
       }
        
        cell.answer1PercentLbl.text = String(format: "%.0f", a1perc) + "%"
        cell.answer2PercentLbl.text = String(format: "%.0f", a2perc) + "%"
        cell.answer3PercentLbl.text = String(format: "%.0f", a3perc) + "%"
        cell.answer4PercentLbl.text = String(format: "%.0f", a4perc) + "%"
        
        cell.answer1PercentLbl.isHidden = false
        cell.answer2PercentLbl.isHidden = false
        cell.answer3PercentLbl.isHidden = false
        cell.answer4PercentLbl.isHidden = false
        
        cell.answer1Btn.isEnabled = false
        cell.answer2Btn.isEnabled = false
        cell.answer3Btn.isEnabled = false
        cell.answer4Btn.isEnabled = false
        
        cell.deleteBtn.isHidden = false
        cell.reportBtn.isHidden = true
        
        let calendar = Calendar.current
        let postedDate = Date(timeIntervalSince1970: polls[indexPath.row].timestamp)
        let endDate = calendar.date(byAdding: .day, value: 1, to: postedDate)
        let endTimestamp = endDate!.timeIntervalSinceNow
        
        if Double(endTimestamp) > 0.0 {
            cell.scheduleTimeRemainingTimer()
        } else {
            cell.timeRemainingLbl.text = "0 hr 0 min"
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // load more cells if user reaches end of tableview and there are more polls yet to be displayed
        
        if indexPath.row == maxPollsLoaded-1 {
            self.loadPolls()
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension UserPollsVC: PollsCellDelegate {
    
    func ignoreSensitiveContent(row: Int) {
        // do nothing
    }
    
    func unblock(row: Int) {
        // do nothing
    }
    
    func reportBtnPressed(row: Int) {
        // do nothing
    }
    
    func didSelectAnswer1(row: Int) {
        // do nothing
    }
    
    func didSelectAnswer2(row: Int) {
        // do nothing
    }
    
    func didSelectAnswer3(row: Int) {
        // do nothing
    }
    
    func didSelectAnswer4(row: Int) {
        // do nothing
    }
    
    func deleteBtnPressed(row: Int) {
        
        deletePollAlert(row: row)
        
    }
    
}
