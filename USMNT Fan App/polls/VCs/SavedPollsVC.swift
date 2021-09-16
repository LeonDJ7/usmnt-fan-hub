//
//  SavedPollsVC.swift
//  USMNT Fan App
//
//  Created by Leon Djusberg on 6/6/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class SavedPollsVC: UIViewController {

    var polls: [Poll] = []
    
    var maxPollsLoaded = 10
    var timestampCeiling = Double(Date().timeIntervalSince1970) // set to the last poll's timestamp in polls array, so that it knows how to load subsequent polls if it has to
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.register(PollsCell.self, forCellReuseIdentifier: "savedPollsCell")
        return tv
    }()
    
    let descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Saved Polls"
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
        
        Firestore.firestore().collection("Users").document(uid!).collection("SavedPolls").order(by: "timestamp", descending: true).whereField("timestamp", isLessThan: timestampCeiling).limit(to: 10).getDocuments { (snap1, err) in
            
            let savedCount = snap1?.documents.count
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                
                for document in snap1!.documents {
                    
                    let data = document.data()
                    let docID = data["docID"] as! String
                    let vote = data["vote"] as! Int
                    
                    Firestore.firestore().collection("Polls").document(docID).getDocument { (snap2, err) in
                        
                        let data = snap2!.data()!
                        let poll = Poll(question: data["question"] as! String, author: data["author"] as! String, authorUID: data["authorUID"] as! String, answer1: data["answer1"] as! String, answer2: data["answer2"] as! String, answer3: data["answer3"] as! String, answer4: data["answer4"] as! String, answer1Score: data["answer1Score"] as! Double, answer2Score: data["answer2Score"] as! Double, answer3Score: data["answer3Score"] as! Double, answer4Score: data["answer4Score"] as! Double, timestamp: data["timestamp"] as! Double, totalAnswerOptions: data["totalAnswerOptions"] as! Double, docID: document.documentID, userVote: vote, isSensitive: data["isSensitive"] as! Bool)
                        
                        self.polls.append(poll)
                        
                        self.polls.sort { $0.timestamp > $1.timestamp }
                        
                        if (self.polls.count == self.maxPollsLoaded) || self.polls.count == savedCount {
                            
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
    
    func reportPollAlert(row: Int) {
        
        let alert = UIAlertController(title: "hmmm", message: "what would you like to do", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "block user", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            // add blocked user to user's blocked list in firestore
            
            guard let user = Auth.auth().currentUser else {
                AlertController.showAlert(self, title: "Error", message: "must be logged in to block users")
                return
            }
            
            guard user.uid != self.polls[row].authorUID else {
                return
            }
            
            Firestore.firestore().collection("Users").document(user.uid).collection("Blocked").document(self.polls[row].authorUID).setData(["blocked":true])
            
            Firestore.firestore().collection("Users").document(user.uid).collection("Blocked").document(self.polls[row].authorUID).getDocument { (snap, err) in
                
                guard err == nil else {
                    print(err?.localizedDescription ?? "")
                    return
                }
                
                blockedUIDs.append(self.polls[row].authorUID)
                
            }
            
            // do blocked stuff to cell
            
            let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! PollsCell
            for view in cell.subviews {
                view.isHidden = true
            }
            
            cell.blockedLbl.isHidden = false
            cell.unblockBtn.isHidden = false
        }))
        
        alert.addAction(UIAlertAction(title: "report sensitive content", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            UserDefaults.standard.set(false, forKey: self.polls[row].docID + "ignoreSensitiveContent")
            // check to make sure this device hasnt already reported
            
            let deviceHasReported = UserDefaults.standard.bool(forKey: self.polls[row].docID + "has reported")
            
            if deviceHasReported == true {
                AlertController.showAlert(self, title: "Error", message: "you have already reported this post")
                return
            }
            
            // report to firebase and send email to myself
            
            let data: [String : Any] = [
                "docID" : self.polls[row].docID,
                "authorUID" : self.polls[row].authorUID,
                "question" : self.polls[row].question
            ]
            
            Firestore.firestore().collection("Sensitive Content Reports").document("\(Date().timeIntervalSince1970)").setData(data)
            
            self.sendEmail(text: self.polls[row].question)
            UserDefaults.standard.set(true, forKey: self.polls[row].docID + "has reported")
            
        }))
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension SavedPollsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return polls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedPollsCell") as! PollsCell
        
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
        
        let calendar = Calendar.current
        let postedDate = Date(timeIntervalSince1970: polls[indexPath.row].timestamp)
        let endDate = calendar.date(byAdding: .day, value: 1, to: postedDate)
        let endTimestamp = (endDate?.timeIntervalSinceNow)!
        
        if Double(endTimestamp) > 0.0 {
            cell.scheduleTimeRemainingTimer()
        } else {
            cell.timeRemainingLbl.text = "0 hr 0 min"
        }
        
        if polls[indexPath.row].userVote != 0 {
            
            // vote has been cast
            
            if polls[indexPath.row].userVote == 1 {
                cell.answer1Btn.backgroundColor = .darkGray
                cell.answer1PercentLbl.textColor = .white
            } else if polls[indexPath.row].userVote == 2 {
                cell.answer2Btn.backgroundColor = .darkGray
                cell.answer2PercentLbl.textColor = .white
            } else if polls[indexPath.row].userVote == 3 {
                cell.answer3Btn.backgroundColor = .darkGray
                cell.answer3PercentLbl.textColor = .white
            } else {
                cell.answer4Btn.backgroundColor = .darkGray
                cell.answer4PercentLbl.textColor = .white
            }
            
            cell.answer1PercentLbl.isHidden = false
            cell.answer2PercentLbl.isHidden = false
            cell.answer3PercentLbl.isHidden = false
            cell.answer4PercentLbl.isHidden = false
            
        } else {
            
            // no vote has been cast
            
            cell.answer1PercentLbl.isHidden = true
            cell.answer2PercentLbl.isHidden = true
            cell.answer3PercentLbl.isHidden = true
            cell.answer4PercentLbl.isHidden = true
            
        }
        
        cell.answer1Btn.isEnabled = false
        cell.answer2Btn.isEnabled = false
        cell.answer3Btn.isEnabled = false
        cell.answer4Btn.isEnabled = false
        
        cell.reportBtn.isHidden = false
        cell.deleteBtn.isHidden = true
        
        if polls[indexPath.row].isSensitive == true {
            
            let ignore = (UserDefaults.standard.bool(forKey: polls[indexPath.row].docID + "ignoreSensitiveContent"))
            
            if ignore == true {
                
                for view in cell.subviews {
                    view.isHidden = true
                }
                
                cell.sensitiveContentWarningBtn.isHidden = true
                cell.unblockBtn.isHidden = true
                cell.blockedLbl.isHidden = true
                
            } else {
                
                for view in cell.subviews {
                    view.isHidden = true
                }
                
                cell.sensitiveContentWarningBtn.isHidden = false
                
            }
            
        }
        
        var blocked: Bool = false
        cell.unblockBtn.setTitle("unblock \(polls[indexPath.row].author)?", for: .normal)
        
        for uid in blockedUIDs {
            
            if polls[indexPath.row].authorUID == uid{
                blocked = true
                break
            }
            
        }
        
        if blocked == true {
            cell.cellView.isHidden = true
            cell.sensitiveContentWarningBtn.isHidden = true
            cell.blockedLbl.isHidden = false
            cell.unblockBtn.isHidden = false
        } else {
            cell.cellView.isHidden = false
            cell.sensitiveContentWarningBtn.isHidden = true
            cell.blockedLbl.isHidden = true
            cell.unblockBtn.isHidden = true
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

extension SavedPollsVC: PollsCellDelegate {
    
    func unblock(row: Int) {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        Firestore.firestore().collection("Users").document(user.uid).collection("Blocked").document(polls[row].authorUID).getDocument { (snap, err) in
            
            guard err == nil else {
                print(err?.localizedDescription ?? "")
                return
            }
            
            guard let snap = snap else {
                return
            }
            
            snap.reference.delete()
            blockedUIDs = blockedUIDs.filter { $0 != self.polls[row].authorUID }
            self.tableView.reloadData()
            
        }
        
    }
    
    func ignoreSensitiveContent(row: Int) {
        
        UserDefaults.standard.set(true, forKey: polls[row].docID + "ignoreSensitiveContent")
        tableView.reloadData()
        
    }
    
    
    func reportBtnPressed(row: Int) {
        
        reportPollAlert(row: row)
        
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
        
        // do nothing
        
    }
    
}

extension SavedPollsVC: MFMailComposeViewControllerDelegate {
    
    func sendEmail(text: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["leondjust@me.com"])
            mail.setMessageBody("new harrasment report \ntext: \(text)", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}

