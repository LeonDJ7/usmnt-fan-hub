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

    var allTopics: [Topic] = []
    var naturalTopics: [Topic] = []
    var topicsDisplayed : [Topic] = []
    var maxTopicsLoaded = 10
    var timestampCeiling = Double(Date().timeIntervalSince1970)
    
    var interstitial: GADInterstitial!
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.separatorStyle = .none
        tv.register(TopicCell.self, forCellReuseIdentifier: "topicCell")
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .darkGray
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()
    
    let userTopicsBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "User"), for: .normal)
        btn.addTarget(self, action: #selector(presentUserTopics), for: .touchUpInside)
        return btn
    }()
    
    let createTopicBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(presentPopUp), for: .touchUpInside)
        btn.setImage(UIImage(named: "AddForum"), for: .normal)
        return btn
    }()
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.searchBarStyle = .minimal
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refresher
        
        // set search bar font
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        let fontDescriptor = UIFontDescriptor(name: "Avenir-Medium", size: 17)
        textFieldInsideUISearchBar?.font = UIFont(descriptor: fontDescriptor, size: 17)
        textFieldInsideUISearchBar?.textColor = .white
        
        loadTopics(resetTopics: true) // loads topics being displayed (10 at a time)
        loadAllTopics() // loads all topics for when user wants to search
        setupLayout()
        
        interstitial = createAndLoadInterstitial()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    func setupLayout() {
        
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(searchBar)
        view.addSubview(userTopicsBtn)
        view.addSubview(tableView)
        view.addSubview(createTopicBtn)
        
    }
    
    func applyAnchors() {
        
        if #available(iOS 11.0, *) {
            userTopicsBtn.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: view.rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 25, width: 25)
        } else {
            userTopicsBtn.anchors(top: view.topAnchor, topPad: 50, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: view.rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 25, width: 25)
        }
        
        createTopicBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: userTopicsBtn.leftAnchor, rightPad: -10, centerX: nil, centerXPad: 0, centerY: userTopicsBtn.centerYAnchor, centerYPad: 0, height: 25, width: 25)
        
        searchBar.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 10, right: createTopicBtn.leftAnchor, rightPad: -10, centerX: nil, centerXPad: 0, centerY: userTopicsBtn.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        tableView.anchors(top: userTopicsBtn.bottomAnchor, topPad: 20, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func loadTopics(resetTopics: Bool) {
        
        if (resetTopics == true) {
            naturalTopics = []
            maxTopicsLoaded = 10
            timestampCeiling = Double(Date().timeIntervalSince1970)
        }
        
        Firestore.firestore().collection("Topics").whereField("timestamp", isLessThan: timestampCeiling).order(by: "timestamp", descending: true).limit(to: 10).getDocuments { (snap, err) in
            
            guard err == nil else {
                print(err?.localizedDescription ?? "")
                return
            }
            
            if let snap = snap {
                
                for document in snap.documents {
                    let data = document.data()
                    let lastActiveTimestamp = data["lastActiveTimestamp"] as! Double
                    let timestamp = data["timestamp"] as! Double
                    let topic = data["topic"] as! String
                    let author = data["author"] as! String
                    let authorUID = data["authorUID"] as! String
                    let text = data["text"] as! String
                    let id = document.documentID
                    let dbref = Firestore.firestore().collection("Topics").document(id)
                    let commentCount = data["commentCount"] as! Int
                    let isSensitive = data["isSensitive"] as! Bool
                    self.naturalTopics.append(Topic(topic: topic, lastActiveTimestamp: lastActiveTimestamp, timestamp: timestamp, author: author, authorUID: authorUID, text: text, id: id, dbref: dbref, commentCount: commentCount, isSensitive: isSensitive))
                }
                
            }
            
            self.naturalTopics.sort { $0.timestamp > $1.timestamp }
            self.topicsDisplayed = self.naturalTopics
            self.tableView.reloadData()
            
            if (self.naturalTopics.count > 0) {
                self.timestampCeiling = self.naturalTopics[self.naturalTopics.count-1].timestamp
            }
            
            if resetTopics == false {
                self.maxTopicsLoaded += 10
            }
            
        }
        
    }
    
    func loadAllTopics() {
        
        Firestore.firestore().collection("Topics").getDocuments { (snap, err) in
            
            guard err == nil else {
                print(err?.localizedDescription ?? "")
                return
            }
            
            if let snap = snap {
                
                for document in snap.documents {
                    let data = document.data()
                    let lastActiveTimestamp = data["lastActiveTimestamp"] as! Double
                    let timestamp = data["timestamp"] as! Double
                    let topic = data["topic"] as! String
                    let author = data["author"] as! String
                    let authorUID = data["authorUID"] as! String
                    let text = data["text"] as! String
                    let id = document.documentID
                    let dbref = Firestore.firestore().collection("Topics").document(id)
                    let commentCount = data["commentCount"] as! Int
                    let isSensitive = data["isSensitive"] as! Bool
                    self.allTopics.append(Topic(topic: topic, lastActiveTimestamp: lastActiveTimestamp, timestamp: timestamp, author: author, authorUID: authorUID, text: text, id: id, dbref: dbref, commentCount: commentCount, isSensitive: isSensitive))
                }
                
            }
            
            self.allTopics.sort { $0.timestamp > $1.timestamp }
            
        }
        
    }
    
    @objc func requestData() {
        
        loadTopics(resetTopics: true)
        let deadline = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
        
    }
    
    @objc func presentUserTopics() {
        
        if Auth.auth().currentUser != nil {
            
            let vc = TopicsPageVC(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let vc = AuthVC()
            present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func presentPopUp() {
        
        if Auth.auth().currentUser != nil {
            
            let vc = AddTopicVC()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.parentVC = self
            vc.topics = self.naturalTopics
            present(vc, animated: true, completion: nil)
            
        } else {
            
            let vc = AuthVC()
            present(vc, animated: true, completion: nil)
            
        }
        
    }
    
}

extension ForumHomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicsDisplayed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell") as! TopicCell
        cell.topicLbl.text = topicsDisplayed[indexPath.row].topic
        cell.authorLbl.text = topicsDisplayed[indexPath.row].author
        cell.delegate = self
        cell.topic = topicsDisplayed[indexPath.row]
        cell.setUserProfileImage(uid: topicsDisplayed[indexPath.row].authorUID)
        
        let lastActiveDate = Date(timeIntervalSince1970: topicsDisplayed[indexPath.row].lastActiveTimestamp)
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
        cell.unblockBtn.setTitle("unblock \(topicsDisplayed[indexPath.row].author)?", for: .normal)
        
        for uid in blockedUIDs {
            
            if topicsDisplayed[indexPath.row].authorUID == uid {
                blocked = true
                break
            }
            
        }
        
        if let user = Auth.auth().currentUser {
            
            if user.uid != topicsDisplayed[indexPath.row].authorUID {
                // not users post
                
                if blocked == true {
                    for view in cell.subviews {
                        view.isHidden = true
                    }
                    cell.blockedLbl.isHidden = false
                    cell.unblockBtn.isHidden = false
                } else {
                    
                    if topicsDisplayed[indexPath.row].isSensitive == true {
                        
                        let ignore = (UserDefaults.standard.bool(forKey: topicsDisplayed[indexPath.row].id + "ignoreSensitiveContent"))
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
                
                if topicsDisplayed[indexPath.row].isSensitive == true {
                    
                    let ignore = (UserDefaults.standard.bool(forKey: topicsDisplayed[indexPath.row].id + "ignoreSensitiveContent"))
                    
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
        vc.topic = topicsDisplayed[indexPath.row]
        vc.topicRow = indexPath.row
        vc.parentVC = self
        
        let random = arc4random_uniform(4)
        
        if random == 0 {
            
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
                navigationController?.pushViewController(vc, animated: true)
            } else {
                print("interstitial not ready")
                navigationController?.pushViewController(vc, animated: true)
            }
            
        } else {
            print("random number not correct")
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // load more cells if user reaches end of tableview and there are more polls yet to be displayed
        
        if indexPath.row == maxTopicsLoaded-1 { self.loadTopics(resetTopics: false) }
        
    }

}

extension ForumHomeVC: TopicCellDelegate {
    
    func ignoreSensitiveContent(topic: Topic) {
        UserDefaults.standard.set(true, forKey: topic.id + "ignoreSensitiveContent")
        tableView.reloadData()
    }
    
    func unblockTopic(topic: Topic) {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        Firestore.firestore().collection("Users").document(user.uid).collection("Blocked").document(topic.authorUID).getDocument { (snap, err) in
            
            guard err == nil else {
                print(err?.localizedDescription ?? "")
                return
            }
            
            guard let snap = snap else {
                return
            }
            
            snap.reference.delete()
            blockedUIDs = blockedUIDs.filter { $0 != topic.authorUID }
            self.tableView.reloadData()
            
        }
        
    }
    
}

extension ForumHomeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            topicsDisplayed = naturalTopics
            tableView.reloadData()
            return
        }
        
        topicsDisplayed = allTopics.filter({ (topic) -> Bool in
            return topic.topic.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
}

extension ForumHomeVC: GADInterstitialDelegate {
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-2790005755690511/2057144590")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
}
