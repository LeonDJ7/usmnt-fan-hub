//
//  NewsVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 7/15/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    var articles: [Article] = []
    
    let welcomeView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let welcomeLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Medium", size: 20)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.text = "Welcome USMNT Fan!"
        return lbl
    }()
    
    let settingsBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "settings"), for: .normal)
        btn.addTarget(self, action: #selector(settingsBtnTapped), for: .touchUpInside)
        btn.backgroundColor = #colorLiteral(red: 1, green: 0.7920521498, blue: 0.7826431394, alpha: 1)
        return btn
    }()
    
    let newsLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 16)
        lbl.textColor = .white
        lbl.text = "news feed"
        return lbl
    }()
    
    let tweetsLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 16)
        lbl.textColor = .white
        lbl.text = "latest tweets"
        return lbl
    }()
    
    let newsTableView: UITableView = {
        let tv = UITableView()
        tv.tag = 0
        tv.separatorStyle = .none
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.register(NewsCell.self, forCellReuseIdentifier: "newsCell")
        return tv
    }()
    
    let tweetsTableView: UITableView = {
        let tv = UITableView()
        tv.tag = 1
        tv.separatorStyle = .none
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.register(TweetCell.self, forCellReuseIdentifier: "tweetCell")
        return tv
    }()
    
    let moreNewsBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(moreNewsBtnTapped), for: .touchUpInside)
        btn.titleLabel?.font = UIFont(name: "Avenir-Book", size: 12)
        btn.titleLabel?.textColor = .white
        btn.setTitle("see more news...", for: .normal)
        return btn
    }()
    
    func setupLayout() {
        
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
    
        view.addSubview(welcomeView)
        welcomeView.addSubview(welcomeLbl)
        welcomeView.addSubview(settingsBtn)
        view.addSubview(newsLbl)
        view.addSubview(newsTableView)
        view.addSubview(moreNewsBtn)
        view.addSubview(tweetsLbl)
        view.addSubview(tweetsTableView)
        
    }
    
    func applyAnchors() {
        
        welcomeView.anchors(top: view.topAnchor, topPad: 60, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        welcomeLbl.anchors(top: welcomeView.topAnchor, topPad: 10, bottom: welcomeView.bottomAnchor, bottomPad: -5, left: welcomeView.leftAnchor, leftPad: 10, right: welcomeView.rightAnchor, rightPad: -50, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        settingsBtn.anchors(top: welcomeView.topAnchor, topPad: 0, bottom: welcomeView.bottomAnchor, bottomPad: 0, left: welcomeLbl.rightAnchor, leftPad: 0, right: welcomeView.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        newsLbl.anchors(top: welcomeView.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        newsTableView.anchors(top: newsLbl.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        moreNewsBtn.anchors(top: newsTableView.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        tweetsLbl.anchors(top: moreNewsBtn.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        tweetsTableView.anchors(top: tweetsTableView.bottomAnchor, topPad: 5, bottom: view.bottomAnchor, bottomPad: -50, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func loadArticles() {
        
        Firestore.firestore().collection("News").order(by: "timestamp").limit(to: 3).getDocuments { (snap, err) in
            
            guard err == nil else {
                print(err?.localizedDescription as Any)
                return
            }
            
            for document in snap!.documents {
                let data = document.data()
                let title = data["title"] as! String
                let url = data["url"] as! String
                let timestamp = data["timestamp"] as! Double
                let article = Article(title: title, url: url, timestamp: timestamp)
                self.articles.append(article)
            }
            
            self.newsTableView.reloadData()
            
        }
        
    }
    
    @objc func settingsBtnTapped() {
        
        let settingsVC = SettingsVC()
        let authVC = AuthVC()
        
        if Auth.auth().currentUser != nil {
            // take to settingsVC
            present(settingsVC, animated: true, completion: nil)
        } else {
            // take to sign in page or give option
            
            //let signInNavController = UINavigationController(rootViewController: signInVC)
            //signInNavController.navigationBar.isHidden = true
            
            present(authVC, animated: true, completion: nil)
        }
        
    }
    
    @objc func moreNewsBtnTapped() {
        
        let vc = NewsVC()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return 3
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if tableView.tag == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TweetCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
