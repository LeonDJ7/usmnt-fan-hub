//
//  ForumHomeVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 4/4/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class ForumHomeVC: UIViewController {

    var forumTopics: [Topic] = []
    var searchedForumTopics: [Topic] = []
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.separatorStyle = .none
        tv.register(ForumTVCell.self, forCellReuseIdentifier: "userTopicsCell")
        return tv
    }()
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .darkGray
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()
    
    let userPollsBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "User"), for: .normal)
        btn.addTarget(self, action: #selector(presentUserPolls), for: .touchUpInside)
        return btn
    }()
    
    let createTopicBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(presentPopUp), for: .touchUpInside)
        btn.setImage(UIImage(named: "AddChatBtn1"), for: .normal)
        return btn
    }()
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.searchBarStyle = .minimal
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        let fontDescriptor = UIFontDescriptor(name: "Menlo-Regular", size: 17)
        textFieldInsideUISearchBar?.font = UIFont(descriptor: fontDescriptor, size: 17)
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refresher
        loadTopics()
        setupLayout()
        
    }
    
    func setupLayout() {
        
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(searchBar)
        view.addSubview(userPollsBtn)
        view.addSubview(tableView)
        view.addSubview(createTopicBtn)
        
    }
    
    func applyAnchors() {
        
        searchBar.anchors(top: view.topAnchor, topPad: 50, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 10, right: userPollsBtn.leftAnchor, rightPad: -10, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        userPollsBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: view.rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: searchBar.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        tableView.anchors(top: userPollsBtn.bottomAnchor, topPad: 30, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        createTopicBtn.anchors(top: nil, topPad: 0, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!-25, left: nil, leftPad: 0, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func loadTopics() {
        
        forumTopics = []
        
        Firestore.firestore().collection("Topics").getDocuments { (snap, error) in
            
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
            self.searchedForumTopics = self.forumTopics
            self.tableView.reloadData()
            
        }
        
    }
    
    @objc func requestData() {
        
        loadTopics()
        let deadline = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
        
    }
    
    @objc func presentUserPolls() {
        
        // vc.modalPresentationStyle = .overCurrentContext
        if Auth.auth().currentUser != nil {
            
            let vc = UserTopicsVC()
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let vc = SignUpVC()
            present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func presentPopUp() {
        
        if Auth.auth().currentUser != nil {
            
            let vc = CreateForumVC()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
            
        } else {
            
            let vc = SignUpVC()
            present(vc, animated: true, completion: nil)
            
        }
        
    }
    
}

extension ForumHomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedForumTopics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "forumCell") as! ForumTVCell
        
        cell.topicLbl.text = searchedForumTopics[indexPath.row].topic
        cell.authorLbl.text = searchedForumTopics[indexPath.row].author
        
        let lastActiveDate = Date(timeIntervalSince1970: searchedForumTopics[indexPath.row].timestamp)
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
        vc.topic = searchedForumTopics[indexPath.row].topic
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension ForumHomeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            searchedForumTopics = forumTopics
            return
        }
        
        searchedForumTopics = forumTopics.filter({ (topic) -> Bool in
            return topic.description.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
}
