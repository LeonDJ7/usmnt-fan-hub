//
//  PollsVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 7/8/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class PollsVC: UIViewController {
    
    var polls: [Poll] = []
    
    var maxPollsLoaded = 10
    var timestampFloor = 0.0 // set to the last poll's timestamp in polls array, so that it knows how to load subsequent polls if it has to
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.allowsSelection = false
        tv.register(PollsCell.self, forCellReuseIdentifier: "pollsCell")
        return tv
    }()
    
    let createPollBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(presentPopUp), for: .touchUpInside)
        btn.setImage(UIImage(named: "AddPoll"), for: .normal)
        return btn
    }()
    
    let warningLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Polls expire in 24 hours"
        lbl.textColor = UIColor(displayP3Red: 90/255, green: 145/255, blue: 185/255, alpha: 1)
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()
    
    let userPollsBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "User"), for: .normal)
        btn.addTarget(self, action: #selector(presentPollsPagePolls), for: .touchUpInside)
        return btn
    }()
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .darkGray
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refresher
        
        loadPolls(resetPolls: true)
        setupLayout()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if userHasChanged == true {
            loadPolls(resetPolls: true)
            userHasChanged = false
        }
        
    }
    
    func setupLayout() {
        
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(userPollsBtn)
        view.addSubview(createPollBtn)
        view.addSubview(warningLbl)
        view.addSubview(tableView)
        
    }
    
    func applyAnchors() {
        
        if #available(iOS 11.0, *) {
            userPollsBtn.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: view.rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 25, width: 25)
        } else {
            userPollsBtn.anchors(top: view.topAnchor, topPad: 50, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: view.rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 25, width: 25)
        }
        
        createPollBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: userPollsBtn.leftAnchor, rightPad: -10, centerX: nil, centerXPad: 0, centerY: userPollsBtn.centerYAnchor, centerYPad: 0, height: 25, width: 25)
        
        warningLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 10, right: createPollBtn.leftAnchor, rightPad: -10, centerX: nil, centerXPad: 0, centerY: userPollsBtn.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        tableView.anchors(top: warningLbl.bottomAnchor, topPad: 20, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    @objc func backBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func requestData() {
        loadPolls(resetPolls: true)
        let deadline = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
    }
    
    @objc func presentPopUp() {
        
        if Auth.auth().currentUser != nil {
            
            let vc = AddPollVC()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.parentVC = self
            present(vc, animated: true, completion: nil)
            
        } else {
            
            let vc = AuthVC()
            present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func presentPollsPagePolls() {
        
        if Auth.auth().currentUser != nil {
            
            let vc = PollsPageVC(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
            
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let vc = AuthVC()
            present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    func loadPolls(resetPolls: Bool) {
        
        if (resetPolls == true) {
            polls = []
            maxPollsLoaded = 10
            timestampFloor = 0.0
        }
        
        // create timestamp exactly 24 hours behind current that represents the cutoff for loaded polls
        
        var cutoffDateComponent = DateComponents()
        cutoffDateComponent.day = -1
        let calendar = Calendar.current
        let cutoffDate = calendar.date(byAdding: cutoffDateComponent, to: Date())
        let activePollCutOffTimestamp = cutoffDate!.timeIntervalSince1970
        
        Firestore.firestore().collection("Polls").whereField("timestamp", isGreaterThan: activePollCutOffTimestamp).whereField("timestamp", isGreaterThan: timestampFloor).order(by: "timestamp").limit(to: 10).getDocuments { (snap1, err) in
            
            guard err == nil else {
                print(err?.localizedDescription ?? "")
                return
            }
            
            if let user = Auth.auth().currentUser {
                
                Firestore.firestore().collection("Users").document(user.uid).collection("SavedPolls").getDocuments { (snap2, err) in
                    
                    guard err == nil else {
                        print(err?.localizedDescription ?? "")
                        return
                    }
                    
                    var userVotes: [String:Int] = [:]
                    
                    if let snap = snap2 {
                        
                        for document in snap.documents {
                            
                            let data = document.data()
                            let docID = data["docID"] as? String ?? ""
                            let vote = data["vote"] as? Int ?? 0
                            userVotes[docID] = vote
                            
                        }
                        
                        if let snap = snap1 {
                            
                            for document in snap.documents {
                                
                                let data = document.data()
                                
                                let poll = Poll(question: data["question"] as! String, author: data["author"] as! String, authorUID: data["authorUID"] as! String, answer1: data["answer1"] as! String, answer2: data["answer2"] as! String, answer3: data["answer3"] as! String, answer4: data["answer4"] as! String, answer1Score: data["answer1Score"] as! Double, answer2Score: data["answer2Score"] as! Double, answer3Score: data["answer3Score"] as! Double, answer4Score: data["answer4Score"] as! Double, timestamp: data["timestamp"] as! Double, totalAnswerOptions: data["totalAnswerOptions"] as! Double, docID: document.documentID, userVote: userVotes[document.documentID] ?? 0, isSensitive: data["isSensitive"] as! Bool)
                                
                                self.polls.append(poll)
                                
                            }
                            
                            self.polls.sort { $0.timestamp < $1.timestamp }
                            self.tableView.reloadData()
                            
                            if (self.polls.count > 0) {
                                self.timestampFloor = self.polls[self.polls.count-1].timestamp
                            }
                            
                            if resetPolls == false {
                                self.maxPollsLoaded += 10
                            }
                            
                        }
                        
                    }
                    
                }
                
            } else {
                
                if let snap = snap1 {
                    
                    for document in snap.documents {
                        
                        let data = document.data()
                        let userVote = UserDefaults.standard.object(forKey: document.documentID + "vote") ?? 0
                        
                        let poll = Poll(question: data["question"] as! String, author: data["author"] as! String, authorUID: data["authorUID"] as! String, answer1: data["answer1"] as! String, answer2: data["answer2"] as! String, answer3: data["answer3"] as! String, answer4: data["answer4"] as! String, answer1Score: data["answer1Score"] as! Double, answer2Score: data["answer2Score"] as! Double, answer3Score: data["answer3Score"] as! Double, answer4Score: data["answer4Score"] as! Double, timestamp: data["timestamp"] as! Double, totalAnswerOptions: data["totalAnswerOptions"] as! Double, docID: document.documentID, userVote: userVote as! Int, isSensitive: data["isSensitive"] as! Bool)
                        
                        self.polls.append(poll)
                        
                    }
                    
                    self.polls.sort { $0.timestamp < $1.timestamp }
                    self.tableView.reloadData()
                    
                    if (self.polls.count > 0) {
                        self.timestampFloor = self.polls[self.polls.count-1].timestamp
                    }
                    
                    if resetPolls == false {
                        self.maxPollsLoaded += 10
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func deletePollAlert(row: Int) {
        
        guard let user = Auth.auth().currentUser else {
            tableView.reloadData()
            return
        }
        
        guard user.uid == polls[row].authorUID else {
            tableView.reloadData()
            return
        }
        
        let alert = UIAlertController(title: "just checking", message: "are you sure you want to delete this poll?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "no", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "yes", style: .default, handler: { (action) in
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
            
            blockedUIDs.append(self.polls[row].authorUID)
            self.tableView.reloadData()
            
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

extension PollsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return polls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pollsCell") as! PollsCell
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
        
        cell.questionLbl.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: NSLayoutConstraint.Axis.horizontal)

        cell.timestamp = polls[indexPath.row].timestamp
        cell.setUserProfileImage(uid: polls[indexPath.row].authorUID)
        cell.answer1Score = polls[indexPath.row].answer1Score
        cell.answer2Score = polls[indexPath.row].answer2Score
        cell.answer3Score = polls[indexPath.row].answer3Score
        cell.answer4Score = polls[indexPath.row].answer4Score
        
        // set tags so button knows what cell its operating on
        
        cell.answer1Btn.tag = indexPath.row
        cell.answer2Btn.tag = indexPath.row
        cell.answer3Btn.tag = indexPath.row
        cell.answer4Btn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        cell.reportBtn.tag = indexPath.row
        cell.sensitiveContentWarningBtn.tag = indexPath.row
        cell.unblockBtn.tag = indexPath.row
        
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
            
        }  else {
          
          a1perc = 0.0
          a2perc = 0.0
          a3perc = 0.0
          a4perc = 0.0
          
        }
        
        cell.answer1PercentLbl.text = String(format: "%.0f", a1perc) + "%"
        cell.answer2PercentLbl.text = String(format: "%.0f", a2perc) + "%"
        cell.answer3PercentLbl.text = String(format: "%.0f", a3perc) + "%"
        cell.answer4PercentLbl.text = String(format: "%.0f", a4perc) + "%"
        
        cell.scheduleTimeRemainingTimer()
        
        if let user = Auth.auth().currentUser {
            
            if user.uid == polls[indexPath.row].authorUID {
                
                // user's poll
                
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.944347918, blue: 0.9286107421, alpha: 1)
                cell.questionLbl.textColor = .darkGray
                cell.deleteBtn.isHidden = false
                cell.reportBtn.isHidden = true
                
                cell.answer1PercentLbl.isHidden = false
                cell.answer2PercentLbl.isHidden = false
                cell.answer3PercentLbl.isHidden = false
                cell.answer4PercentLbl.isHidden = false
                
                cell.answer1Btn.isEnabled = false
                cell.answer2Btn.isEnabled = false
                cell.answer3Btn.isEnabled = false
                cell.answer4Btn.isEnabled = false
                
            } else {
                
                // not users poll
                
                cell.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
                cell.questionLbl.textColor = .white
                cell.deleteBtn.isHidden = true
                cell.reportBtn.isHidden = false
                
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
                    
                    cell.answer1Btn.isEnabled = false
                    cell.answer2Btn.isEnabled = false
                    cell.answer3Btn.isEnabled = false
                    cell.answer4Btn.isEnabled = false
                    
                } else {
                    
                    // no vote has been cast
                    
                    cell.answer1PercentLbl.isHidden = true
                    cell.answer2PercentLbl.isHidden = true
                    cell.answer3PercentLbl.isHidden = true
                    cell.answer4PercentLbl.isHidden = true
                    
                }
                
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
                
            }
            
        } else {
            
            // no user signed in
            
            cell.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
            cell.questionLbl.textColor = .white
            cell.deleteBtn.isHidden = true
            cell.reportBtn.isHidden = false
            
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
                
                cell.answer1Btn.isEnabled = false
                cell.answer2Btn.isEnabled = false
                cell.answer3Btn.isEnabled = false
                cell.answer4Btn.isEnabled = false
                
            } else {
                
                // no vote has been cast
                
                cell.answer1PercentLbl.isHidden = true
                cell.answer2PercentLbl.isHidden = true
                cell.answer3PercentLbl.isHidden = true
                cell.answer4PercentLbl.isHidden = true
                
                cell.answer1Btn.isEnabled = true
                cell.answer2Btn.isEnabled = true
                cell.answer3Btn.isEnabled = true
                cell.answer4Btn.isEnabled = true
                
            }
            
            if polls[indexPath.row].isSensitive == true {
                
                let ignore = (UserDefaults.standard.bool(forKey: polls[indexPath.row].docID + "ignoreSensitiveContent"))
                
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
                
            }
            
        }
        
        var blocked: Bool = false
        cell.unblockBtn.setTitle("unblock \(polls[indexPath.row].author)?", for: .normal)
        
        for uid in blockedUIDs {
            
            if polls[indexPath.row].authorUID == uid {
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
        
        cell.questionLbl.sizeToFit()
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // load more cells if user reaches end of tableview and there are more polls yet to be displayed
        
        if indexPath.row == maxPollsLoaded-1 { self.loadPolls(resetPolls: false) }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension PollsVC: PollsCellDelegate {
    
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
        tableView.reloadData()
        UserDefaults.standard.set(true, forKey: polls[row].docID + "ignoreSensitiveContent")
    }
    
    
    func reportBtnPressed(row: Int) {
        
        reportPollAlert(row: row)
        
    }
    
    func deleteBtnPressed(row: Int) {
        
        deletePollAlert(row: row)
        
    }
    
    func didSelectAnswer1(row: Int) {
        
        if let user = Auth.auth().currentUser {
            
            if polls[row].userVote == 0 {
                
                // user has not voted yet
                
                let indexPath = IndexPath(row: row, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! PollsCell
                
                cell.answer1Score += 1
                let totalVotes = cell.answer1Score + cell.answer2Score + cell.answer3Score + cell.answer4Score
                let a1perc = cell.answer1Score / totalVotes * 100
                let a2perc = cell.answer2Score / totalVotes * 100
                let a3perc = cell.answer3Score / totalVotes * 100
                let a4perc = cell.answer4Score / totalVotes * 100
                cell.answer1PercentLbl.text = String(format: "%.0f", a1perc) + "%"
                cell.answer2PercentLbl.text = String(format: "%.0f", a2perc) + "%"
                cell.answer3PercentLbl.text = String(format: "%.0f", a3perc) + "%"
                cell.answer4PercentLbl.text = String(format: "%.0f", a4perc) + "%"
                cell.totalVotesLbl.text = "\(Int(totalVotes))"
                cell.answer1Btn.backgroundColor = .darkGray
                cell.answer1PercentLbl.textColor = .white
                cell.answer1PercentLbl.isHidden = false
                cell.answer2PercentLbl.isHidden = false
                cell.answer3PercentLbl.isHidden = false
                cell.answer4PercentLbl.isHidden = false
                
                Firestore.firestore().collection("Polls").document(self.polls[row].docID).getDocument { (snap, err) in
                    
                    guard err == nil else {
                        print(err?.localizedDescription ?? "")
                        return
                    }
                    
                    if let snap = snap {
                        
                        let data = snap.data()
                        let answer1Score = data?["answer1Score"] as? Int
                        let totalVotes = data?["totalVotes"] as? Int
                        snap.reference.updateData(["answer1Score":answer1Score! + 1,
                                                    "totalVotes":totalVotes! + 1])
                        
                        // add user to polls collection of voters
                        
                        let voteData = (["uid" : user.uid,
                                         "vote" : 1] as [String : Any])
                        
                        snap.reference.collection("Voters").addDocument(data: voteData)
                        
                        // add to users saved polls collection
                        
                        Firestore.firestore().collection("Users").document(user.uid).collection("SavedPolls").addDocument(data: ["docID":snap.documentID,
                             "timestamp": Double(Date().timeIntervalSince1970),
                             "vote": 1])
                        
                    }
                    
                }
                
            } else {
                // user has voted already
            }
            
        } else {
                
            // device has not voted
            
            let indexPath = IndexPath(row: row, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! PollsCell
            
            cell.answer1Score += 1
            let totalVotes = cell.answer1Score + cell.answer2Score + cell.answer3Score + cell.answer4Score
            let a1perc = cell.answer1Score / totalVotes * 100
            let a2perc = cell.answer2Score / totalVotes * 100
            let a3perc = cell.answer3Score / totalVotes * 100
            let a4perc = cell.answer4Score / totalVotes * 100
            cell.answer1PercentLbl.text = String(format: "%.0f", a1perc) + "%"
            cell.answer2PercentLbl.text = String(format: "%.0f", a2perc) + "%"
            cell.answer3PercentLbl.text = String(format: "%.0f", a3perc) + "%"
            cell.answer4PercentLbl.text = String(format: "%.0f", a4perc) + "%"
            cell.totalVotesLbl.text = "\(Int(totalVotes))"
            cell.answer1Btn.backgroundColor = .darkGray
            cell.answer1PercentLbl.textColor = .white
            cell.answer1PercentLbl.isHidden = false
            cell.answer2PercentLbl.isHidden = false
            cell.answer3PercentLbl.isHidden = false
            cell.answer4PercentLbl.isHidden = false
            
            Firestore.firestore().collection("Polls").document(polls[row].docID).getDocument { (snap, err) in
                
                guard err == nil else {
                    print(err?.localizedDescription ?? "")
                    return
                }
                
                if let snap = snap {
                    
                    let data = snap.data()
                    let answer1Score = data?["answer1Score"] as? Int
                    let totalVotes = data?["totalVotes"] as? Int
                    snap.reference.updateData(["answer1Score":answer1Score! + 1,
                                                "totalVotes":totalVotes! + 1])
                    UserDefaults.standard.set(1, forKey: self.polls[row].docID + "vote")
                }
                
            }
            
        }
        
    }
    
    func didSelectAnswer2(row: Int) {
        
        if let user = Auth.auth().currentUser {
            
            // user has not voted yet
            
            let indexPath = IndexPath(row: row, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! PollsCell
            
            cell.answer2Score += 1
            let totalVotes = cell.answer1Score + cell.answer2Score + cell.answer3Score + cell.answer4Score
            let a1perc = cell.answer1Score / totalVotes * 100
            let a2perc = cell.answer2Score / totalVotes * 100
            let a3perc = cell.answer3Score / totalVotes * 100
            let a4perc = cell.answer4Score / totalVotes * 100
            cell.answer1PercentLbl.text = String(format: "%.0f", a1perc) + "%"
            cell.answer2PercentLbl.text = String(format: "%.0f", a2perc) + "%"
            cell.answer3PercentLbl.text = String(format: "%.0f", a3perc) + "%"
            cell.answer4PercentLbl.text = String(format: "%.0f", a4perc) + "%"
            cell.totalVotesLbl.text = "\(Int(totalVotes))"
            cell.answer2Btn.backgroundColor = .darkGray
            cell.answer2PercentLbl.textColor = .white
            cell.answer1PercentLbl.isHidden = false
            cell.answer2PercentLbl.isHidden = false
            cell.answer3PercentLbl.isHidden = false
            cell.answer4PercentLbl.isHidden = false
            
            Firestore.firestore().collection("Polls").document(self.polls[row].docID).getDocument { (snap, err) in
                
                guard err == nil else {
                    print(err?.localizedDescription ?? "")
                    return
                }
                
                if let snap = snap {
                    
                    let data = snap.data()
                    let answer2Score = data?["answer2Score"] as? Int
                    let totalVotes = data?["totalVotes"] as? Int
                    snap.reference.updateData(["answer2Score":answer2Score! + 1,
                                                "totalVotes":totalVotes! + 1])
                    
                    // add user to polls collection of voters
                    
                    let voteData = (["uid" : user.uid,
                                     "vote" : 2] as [String : Any])
                    
                    snap.reference.collection("Voters").addDocument(data: voteData)
                    
                    // add to users saved polls collection
                    
                    Firestore.firestore().collection("Users").document(user.uid).collection("SavedPolls").addDocument(data: ["docID":snap.documentID,
                         "timestamp": Double(Date().timeIntervalSince1970),
                         "vote": 2])
                    
                }
                    
            }
            
        } else {
                
            // device has not voted
            
            let indexPath = IndexPath(row: row, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! PollsCell
            
            cell.answer2Score += 1
            let totalVotes = cell.answer1Score + cell.answer2Score + cell.answer3Score + cell.answer4Score
            let a1perc = cell.answer1Score / totalVotes * 100
            let a2perc = cell.answer2Score / totalVotes * 100
            let a3perc = cell.answer3Score / totalVotes * 100
            let a4perc = cell.answer4Score / totalVotes * 100
            cell.answer1PercentLbl.text = String(format: "%.0f", a1perc) + "%"
            cell.answer2PercentLbl.text = String(format: "%.0f", a2perc) + "%"
            cell.answer3PercentLbl.text = String(format: "%.0f", a3perc) + "%"
            cell.answer4PercentLbl.text = String(format: "%.0f", a4perc) + "%"
            cell.totalVotesLbl.text = "\(Int(totalVotes))"
            cell.answer2Btn.backgroundColor = .darkGray
            cell.answer2PercentLbl.textColor = .white
            cell.answer1PercentLbl.isHidden = false
            cell.answer2PercentLbl.isHidden = false
            cell.answer3PercentLbl.isHidden = false
            cell.answer4PercentLbl.isHidden = false
            
            Firestore.firestore().collection("Polls").document(polls[row].docID).getDocument { (snap, err) in
                
                guard err == nil else {
                    print(err?.localizedDescription ?? "")
                    return
                }
                
                if let snap = snap {
                    
                    let data = snap.data()
                    let answer2Score = data?["answer2Score"] as? Int
                    let totalVotes = data?["totalVotes"] as? Int
                    snap.reference.updateData(["answer2Score":answer2Score! + 1,
                                                "totalVotes":totalVotes! + 1])
                    UserDefaults.standard.set(2, forKey: self.polls[row].docID + "vote")
                }
                
            }
            
        }
        
    }
    
    func didSelectAnswer3(row: Int) {
        
        if let user = Auth.auth().currentUser {
                
            // user has not voted yet
            
            let indexPath = IndexPath(row: row, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! PollsCell
            
            cell.answer3Score += 1
            let totalVotes = cell.answer1Score + cell.answer2Score + cell.answer3Score + cell.answer4Score
            let a1perc = cell.answer1Score / totalVotes * 100
            let a2perc = cell.answer2Score / totalVotes * 100
            let a3perc = cell.answer3Score / totalVotes * 100
            let a4perc = cell.answer4Score / totalVotes * 100
            cell.answer1PercentLbl.text = String(format: "%.0f", a1perc) + "%"
            cell.answer2PercentLbl.text = String(format: "%.0f", a2perc) + "%"
            cell.answer3PercentLbl.text = String(format: "%.0f", a3perc) + "%"
            cell.answer4PercentLbl.text = String(format: "%.0f", a4perc) + "%"
            cell.totalVotesLbl.text = "\(Int(totalVotes))"
            cell.answer3Btn.backgroundColor = .darkGray
            cell.answer3PercentLbl.textColor = .white
            cell.answer1PercentLbl.isHidden = false
            cell.answer2PercentLbl.isHidden = false
            cell.answer3PercentLbl.isHidden = false
            cell.answer4PercentLbl.isHidden = false
            
            Firestore.firestore().collection("Polls").document(self.polls[row].docID).getDocument { (snap, err) in
                
                guard err == nil else {
                    print(err?.localizedDescription ?? "")
                    return
                }
                
                if let snap = snap {
                    let data = snap.data()
                    let answer3Score = data?["answer3Score"] as? Int
                    let totalVotes = data?["totalVotes"] as? Int
                    snap.reference.updateData(["answer3Score":answer3Score! + 1,
                                                "totalVotes":totalVotes! + 1])
                    
                    // add user to polls collection of voters
                    
                    let voteData = (["uid" : user.uid,
                                     "vote" : 3] as [String : Any])
                    
                    snap.reference.collection("Voters").addDocument(data: voteData)
                    
                    // add to users saved polls collection
                    
                    Firestore.firestore().collection("Users").document(user.uid).collection("SavedPolls").addDocument(data: ["docID":snap.documentID,
                         "timestamp": Double(Date().timeIntervalSince1970),
                         "vote": 3])
                    
                }
                
            }
                
        } else {
                
            // device has not voted
            
            let indexPath = IndexPath(row: row, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! PollsCell
            
            cell.answer3Score += 1
            let totalVotes = cell.answer1Score + cell.answer2Score + cell.answer3Score + cell.answer4Score
            let a1perc = cell.answer1Score / totalVotes * 100
            let a2perc = cell.answer2Score / totalVotes * 100
            let a3perc = cell.answer3Score / totalVotes * 100
            let a4perc = cell.answer4Score / totalVotes * 100
            cell.answer1PercentLbl.text = String(format: "%.0f", a1perc) + "%"
            cell.answer2PercentLbl.text = String(format: "%.0f", a2perc) + "%"
            cell.answer3PercentLbl.text = String(format: "%.0f", a3perc) + "%"
            cell.answer4PercentLbl.text = String(format: "%.0f", a4perc) + "%"
            cell.totalVotesLbl.text = "\(Int(totalVotes))"
            cell.answer3Btn.backgroundColor = .darkGray
            cell.answer3PercentLbl.textColor = .white
            cell.answer1PercentLbl.isHidden = false
            cell.answer2PercentLbl.isHidden = false
            cell.answer3PercentLbl.isHidden = false
            cell.answer4PercentLbl.isHidden = false
            
            Firestore.firestore().collection("Polls").document(polls[row].docID).getDocument { (snap, err) in
                
                guard err == nil else {
                    print(err?.localizedDescription ?? "")
                    return
                }
                
                if let snap = snap {
                    
                    let data = snap.data()
                    let answer3Score = data?["answer3Score"] as? Int
                    let totalVotes = data?["totalVotes"] as? Int
                    snap.reference.updateData(["answer3Score":answer3Score! + 1,
                                                "totalVotes":totalVotes! + 1])
                    UserDefaults.standard.set(3, forKey: self.polls[row].docID + "vote")
                }
                
            }
            
        }
        
    }
    
    func didSelectAnswer4(row: Int) {
        
        if let user = Auth.auth().currentUser {
                
            // user has not voted yet
            
            let indexPath = IndexPath(row: row, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! PollsCell
            
            cell.answer4Score += 1
            let totalVotes = cell.answer1Score + cell.answer2Score + cell.answer3Score + cell.answer4Score
            let a1perc = cell.answer1Score / totalVotes * 100
            let a2perc = cell.answer2Score / totalVotes * 100
            let a3perc = cell.answer3Score / totalVotes * 100
            let a4perc = cell.answer4Score / totalVotes * 100
            cell.answer1PercentLbl.text = String(format: "%.0f", a1perc) + "%"
            cell.answer2PercentLbl.text = String(format: "%.0f", a2perc) + "%"
            cell.answer3PercentLbl.text = String(format: "%.0f", a3perc) + "%"
            cell.answer4PercentLbl.text = String(format: "%.0f", a4perc) + "%"
            cell.totalVotesLbl.text = "\(Int(totalVotes))"
            cell.answer4Btn.backgroundColor = .darkGray
            cell.answer4PercentLbl.textColor = .white
            cell.answer1PercentLbl.isHidden = false
            cell.answer2PercentLbl.isHidden = false
            cell.answer3PercentLbl.isHidden = false
            cell.answer4PercentLbl.isHidden = false
            
            Firestore.firestore().collection("Polls").document(self.polls[row].docID).getDocument { (snap, err) in
                
                guard err == nil else {
                    print(err?.localizedDescription ?? "")
                    return
                }
                
                if let snap = snap {
                    
                    let data = snap.data()
                    let answer4Score = data?["answer4Score"] as? Int
                    let totalVotes = data?["totalVotes"] as? Int
                    snap.reference.updateData(["answer4Score":answer4Score! + 1,
                                                "totalVotes":totalVotes! + 1])
                    
                    // add user to polls collection of voters
                    
                    let voteData = (["uid" : user.uid,
                                     "vote" : 4] as [String : Any])
                    
                    snap.reference.collection("Voters").addDocument(data: voteData)
                    
                    // add to users saved polls collection
                    
                    Firestore.firestore().collection("Users").document(user.uid).collection("SavedPolls").addDocument(data: ["docID":snap.documentID,
                         "timestamp": Double(Date().timeIntervalSince1970),
                         "vote": 4])
                    
                }
                
            }
            
        } else {
                
            // device has not voted
            
            let indexPath = IndexPath(row: row, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! PollsCell
            
            cell.answer4Score += 1
            let totalVotes = cell.answer1Score + cell.answer2Score + cell.answer3Score + cell.answer4Score
            let a1perc = cell.answer1Score / totalVotes * 100
            let a2perc = cell.answer2Score / totalVotes * 100
            let a3perc = cell.answer3Score / totalVotes * 100
            let a4perc = cell.answer4Score / totalVotes * 100
            cell.answer1PercentLbl.text = String(format: "%.0f", a1perc) + "%"
            cell.answer2PercentLbl.text = String(format: "%.0f", a2perc) + "%"
            cell.answer3PercentLbl.text = String(format: "%.0f", a3perc) + "%"
            cell.answer4PercentLbl.text = String(format: "%.0f", a4perc) + "%"
            cell.totalVotesLbl.text = "\(Int(totalVotes))"
            cell.answer4Btn.backgroundColor = .darkGray
            cell.answer4PercentLbl.textColor = .white
            cell.answer1PercentLbl.isHidden = false
            cell.answer2PercentLbl.isHidden = false
            cell.answer3PercentLbl.isHidden = false
            cell.answer4PercentLbl.isHidden = false
            
            Firestore.firestore().collection("Polls").document(polls[row].docID).getDocument { (snap, err) in
                
                guard err == nil else {
                    print(err?.localizedDescription ?? "")
                    return
                }
                
                if let snap = snap {
                    
                    let data = snap.data()
                    let answer4Score = data?["answer4Score"] as? Int
                    let totalVotes = data?["totalVotes"] as? Int
                    snap.reference.updateData(["answer4Score":answer4Score! + 1,
                                                "totalVotes":totalVotes! + 1])
                    UserDefaults.standard.set(4, forKey: self.polls[row].docID + "vote")
                }
                
            }
                
        }
        
    }
    
}

extension PollsVC: MFMailComposeViewControllerDelegate {
    
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
