//
//  PollsVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 7/8/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class PollsVC: UIViewController {
    
    // dont let users vote on polls if they are his, indicate this somehow
    // query for polls in last 24 hours
    // fix poll height adjustment problem
    // set time remaining
    
    var polls: [Poll] = []
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.allowsSelection = false
        tv.register(PollsTVCell.self, forCellReuseIdentifier: "pollsCell")
        return tv
    }()
    
    let createPollBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(presentPopUp), for: .touchUpInside)
        btn.setImage(UIImage(named: "AddChatBtn2"), for: .normal)
        return btn
    }()
    
    let warningLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Polls expire in 24 hours"
        lbl.textColor = UIColor(displayP3Red: 90/255, green: 145/255, blue: 185/255, alpha: 1)
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        lbl.textColor = .white
        return lbl
    }()
    
    let userPollsBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "User"), for: .normal)
        btn.addTarget(self, action: #selector(presentUserPolls), for: .touchUpInside)
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
        loadPolls()
        setupLayout()
    }
    
    func setupLayout() {
        
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refresher
        
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(warningLbl)
        view.addSubview(userPollsBtn)
        view.addSubview(tableView)
        view.addSubview(createPollBtn)
        
    }
    
    func applyAnchors() {
        
        warningLbl.anchors(top: view.topAnchor, topPad: 50, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        userPollsBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: view.rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: warningLbl.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        createPollBtn.anchors(top: nil, topPad: 0, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!-25, left: nil, leftPad: 0, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        tableView.anchors(top: warningLbl.bottomAnchor, topPad: 20, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    @objc func requestData() {
        loadPolls()
        let deadline = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
    }
    
    @objc func presentPopUp() {
        
        if Auth.auth().currentUser != nil {
            
            let vc = CreatePollVC()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
            
        } else {
            
            let vc = SignUpVC()
            present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func presentUserPolls() {
        
        // vc.modalPresentationStyle = .overCurrentContext
        if Auth.auth().currentUser != nil {
            
            let vc = UserPollsVC()
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let vc = SignUpVC()
            present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    func loadPolls() {
        
        polls = []
        
        Firestore.firestore().collection("Polls").getDocuments { (snap, error) in
            
            for document in snap!.documents {
                
                let data = document.data()
                let poll = Poll(question: data["question"] as! String, author: data["author"] as! String, answer1: data["answer1"] as! String, answer2: data["answer2"] as! String, answer3: data["answer3"] as! String, answer4: data["answer4"] as! String, answer1Score: data["answer1Score"] as! Double, answer2Score: data["answer2Score"] as! Double, answer3Score: data["answer3Score"] as! Double, answer4Score: data["answer4Score"] as! Double, timestamp: data["timestamp"] as! Double, totalAnswerOptions: data["totalAnswerOptions"] as! Double)
                poll.docID = document.documentID
                self.polls.append(poll)
                
            }
            
            self.polls.sort { $0.timestamp > $1.timestamp }
            
            self.tableView.reloadData()
            
        }
        
    }
    
}

extension PollsVC: PollsCellDelegate {
    
    func didSelectAnswer1(row: Int) {
        
        Firestore.firestore().collection("Polls").document(polls[row].docID).getDocument { (snap, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                let data = snap?.data()
                let answer1Score = data?["answer1Score"] as? Int
                let totalVotes = data?["totalVotes"] as? Int
                snap?.reference.updateData(["answer1Score":answer1Score! + 1,
                                            "totalVotes":totalVotes! + 1])
            }
            
        }
        
    }
    
    func didSelectAnswer2(row: Int) {
        
        Firestore.firestore().collection("Polls").document(polls[row].docID).getDocument { (snap, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                let data = snap?.data()
                let answer2Score = data?["answer2Score"] as? Int
                let totalVotes = data?["totalVotes"] as? Int
                snap?.reference.updateData(["answer2Score":answer2Score! + 1,
                                            "totalVotes":totalVotes! + 1])
            }
            
        }
        
    }
    
    func didSelectAnswer3(row: Int) {
        
        Firestore.firestore().collection("Polls").document(polls[row].docID).getDocument { (snap, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                let data = snap?.data()
                let answer3Score = data?["answer3Score"] as? Int
                let totalVotes = data?["totalVotes"] as? Int
                snap?.reference.updateData(["answer3Score":answer3Score! + 1,
                                            "totalVotes":totalVotes! + 1])
            }
            
        }
        
    }
    
    func didSelectAnswer4(row: Int) {
        
        Firestore.firestore().collection("Polls").document(polls[row].docID).getDocument { (snap, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                let data = snap?.data()
                let answer4Score = data?["answer4Score"] as? Int
                let totalVotes = data?["totalVotes"] as? Int
                snap?.reference.updateData(["answer4Score":answer4Score! + 1,
                                            "totalVotes":totalVotes! + 1])
            }
            
        }
        
    }
    
}


extension PollsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return polls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pollsCell") as! PollsTVCell
        cell.delegate = self
        
        // set tags so button knows what cell its operating on
        
        cell.answer1Btn.tag = indexPath.row
        cell.answer2Btn.tag = indexPath.row
        cell.answer3Btn.tag = indexPath.row
        cell.answer4Btn.tag = indexPath.row
        
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
            
        }
        
        cell.answer1Btn.setTitle(String(format: "%.1f", a1perc) + "%", for: .normal)
        cell.answer2Btn.setTitle(String(format: "%.1f", a2perc) + "%", for: .normal)
        cell.answer3Btn.setTitle(String(format: "%.1f", a3perc) + "%", for: .normal)
        cell.answer4Btn.setTitle(String(format: "%.1f", a4perc) + "%", for: .normal)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell: PollsTVCell = cell as! PollsTVCell
        
        if polls[indexPath.row].totalAnswerOptions == 3 {
            
            cell.answer4Lbl.removeFromSuperview()
            cell.answer3Lbl.anchors(top: cell.answer2Lbl.bottomAnchor, topPad: 5, bottom: cell.cellView.bottomAnchor, bottomPad: -5, left: cell.cellView.leftAnchor, leftPad: 5, right: cell.cellView.rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 50, width: 0)
            
        } else if polls[indexPath.row].totalAnswerOptions == 2 {
            
            cell.answer4Lbl.removeFromSuperview()
            cell.answer3Lbl.removeFromSuperview()
            cell.answer2Lbl.anchors(top: cell.answer1Lbl.bottomAnchor, topPad: 5, bottom: cell.cellView.bottomAnchor, bottomPad: -5, left: cell.cellView.leftAnchor, leftPad: 5, right: cell.cellView.rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 50, width: 0)
            
        }
        
        // find way to change cell height
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
