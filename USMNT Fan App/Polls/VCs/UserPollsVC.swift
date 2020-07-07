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
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.register(PollsCell.self, forCellReuseIdentifier: "userPollsCell")
        return tv
    }()
    
    let backBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "BackArrow"), for: .normal)
        btn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return btn
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
        
        // insurance that polls load
        if tableView.numberOfRows(inSection: 0) == 0 {
            let deadline = DispatchTime.now() + .milliseconds(500)
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                self.polls.sort { $0.timestamp > $1.timestamp }
                self.tableView.reloadData()
            }
        }
        
    }
    
    func setupLayout() {
        
        
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(backBtn)
        view.addSubview(descriptionLbl)
        view.addSubview(tableView)
        
    }
    
    func applyAnchors() {
        
        backBtn.anchors(top: view.topAnchor, topPad: 50, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        descriptionLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: backBtn.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        tableView.anchors(top: backBtn.bottomAnchor, topPad: 30, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func loadPolls() {
        
        polls = []
    
        let uid = Auth.auth().currentUser?.uid
        
        Firestore.firestore().collection("Users").document(uid!).collection("UserPolls").getDocuments { (snap, err) in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                for document in snap!.documents {
                    
                    let docID = document.data()["docID"] as! String

                    Firestore.firestore().collection("Polls").document(docID).getDocument { (snap, err) in
                        
                        let data = snap!.data()!
                        let poll = Poll(question: data["question"] as! String, author: data["author"] as! String, authorUID: data["authorUID"] as! String, answer1: data["answer1"] as! String, answer2: data["answer2"] as! String, answer3: data["answer3"] as! String, answer4: data["answer4"] as! String, answer1Score: data["answer1Score"] as! Double, answer2Score: data["answer2Score"] as! Double, answer3Score: data["answer3Score"] as! Double, answer4Score: data["answer4Score"] as! Double, timestamp: data["timestamp"] as! Double, totalAnswerOptions: data["totalAnswerOptions"] as! Double, docID: document.documentID)
                        self.polls.append(poll)
                        
                    }
                    
                }
                
                let deadline = DispatchTime.now() + .milliseconds(250)
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    self.polls.sort { $0.timestamp > $1.timestamp }
                    self.tableView.reloadData()
                }
                
            }
            
        }
        
    }
    
}




extension UserPollsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return polls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userPollsCell") as! PollsCell
        
        cell.timestamp = polls[indexPath.row].timestamp
        
        cell.setUserProfileImage(uid: polls[indexPath.row].authorUID)
        
        cell.questionLbl.text = polls[indexPath.row].question
        cell.authorLbl.text = polls[indexPath.row].author
        
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
            
        }
        
        cell.answer1Btn.setTitle(String(format: "%.1f", a1perc) + "%", for: .normal)
        cell.answer2Btn.setTitle(String(format: "%.1f", a2perc) + "%", for: .normal)
        cell.answer3Btn.setTitle(String(format: "%.1f", a3perc) + "%", for: .normal)
        cell.answer4Btn.setTitle(String(format: "%.1f", a4perc) + "%", for: .normal)
        
        cell.scheduledTimerWithTimeInterval()
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell: PollsCell = cell as! PollsCell
        
        if polls[indexPath.row].totalAnswerOptions == 3 {
            
            cell.answer4Lbl.removeFromSuperview()
            cell.answer4Btn.removeFromSuperview()
            cell.answer3Lbl.anchors(top: cell.answer2Lbl.bottomAnchor, topPad: 5, bottom: cell.cellView.bottomAnchor, bottomPad: -5, left: cell.cellView.leftAnchor, leftPad: 5, right: cell.cellView.rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 50, width: 0)
            
        } else if polls[indexPath.row].totalAnswerOptions == 2 {
            
            cell.answer4Lbl.removeFromSuperview()
            cell.answer4Btn.removeFromSuperview()
            cell.answer3Lbl.removeFromSuperview()
            cell.answer3Btn.removeFromSuperview()
            cell.answer2Lbl.anchors(top: cell.answer1Lbl.bottomAnchor, topPad: 5, bottom: cell.cellView.bottomAnchor, bottomPad: -5, left: cell.cellView.leftAnchor, leftPad: 5, right: cell.cellView.rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 50, width: 0)
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
