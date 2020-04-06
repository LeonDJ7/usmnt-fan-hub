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
        tv.register(ForumTVCell.self, forCellReuseIdentifier: "userTopicsCell")
        return tv
    }()
    
    let backBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "BackArrow"), for: .normal)
        btn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        loadTopics()
        setupLayout()
        
    }
    
    func setupLayout() {
        
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(backBtn)
        view.addSubview(tableView)
        
    }
    
    func applyAnchors() {
        
        backBtn.anchors(top: view.topAnchor, topPad: 50, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 10, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        tableView.anchors(top: backBtn.bottomAnchor, topPad: 30, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func loadTopics() {
        
        forumTopics = []
        let uid = Auth.auth().currentUser?.uid
        
        Firestore.firestore().collection("Topics").whereField("authorUID", isEqualTo: uid ?? "").getDocuments { (snap, error) in
            
            if error != nil {
                return
            }
            
            for document in snap!.documents {
                let data = document.data()
                let timestamp = data["timestamp"] as! Double
                let topic = data["topic"] as! String
                let author = data["author"] as! String
                let authorUID = data["authorUID"] as! String
                let description = data["description"] as! String
                self.forumTopics.append(Topic(topic: topic, timestamp: timestamp, author: author, authorUID: authorUID, description: description))
            }
            self.forumTopics = self.forumTopics.sorted(by: { $0.timestamp < $1.timestamp })
            self.tableView.reloadData()
        }
        
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

}

extension UserTopicsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forumTopics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "forumCell") as! ForumTVCell
        
        cell.topicLbl.text = forumTopics[indexPath.row].topic
        cell.authorLbl.text = forumTopics[indexPath.row].author
        
        let lastActiveDate = Date(timeIntervalSince1970: forumTopics[indexPath.row].timestamp)
        let diffInHours = Calendar.current.dateComponents([.hour], from: lastActiveDate, to: Date()).hour
        
        if diffInHours != 0 {
            cell.lastActiveLbl.text = "last active \(diffInHours!) hours ago"
        } else {
            cell.lastActiveLbl.text = "last active less than an hour ago"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = TopicVC()
        vc.topic = forumTopics[indexPath.row].topic
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
