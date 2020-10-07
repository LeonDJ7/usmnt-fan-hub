//
//  NewsVC.swift
//  USMNT Fan App
//
//  Created by Leon Djusberg on 6/30/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

class NewsVC: UIViewController {
    
    var articles: [Article] = []
    
    let backBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "BackArrow"), for: .normal)
        btn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return btn
    }()
    
    let headerLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Displays last 15 articles"
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.tag = 0
        tv.separatorStyle = .none
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.register(NewsCell.self, forCellReuseIdentifier: "newsCell")
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        loadArticles()
        setupLayout()
        
    }
    
    func setupLayout() {
        
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
    
        view.addSubview(backBtn)
        view.addSubview(headerLbl)
        view.addSubview(tableView)
        
    }
    
    func applyAnchors() {
        
        if #available(iOS 11.0, *) {
            backBtn.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        } else {
            backBtn.anchors(top: view.topAnchor, topPad: 50, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        }
        
        headerLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: backBtn.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        tableView.anchors(top: backBtn.bottomAnchor, topPad: 30, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)! - 10, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func loadArticles() {
        
        Firestore.firestore().collection("News").order(by: "timestamp", descending: true).limit(to: 15).getDocuments { (snap, err) in
            
            guard err == nil else {
                print(err?.localizedDescription as Any)
                return
            }
            
            if let snap = snap {
                
                for document in snap.documents {
                    let data = document.data()
                    let title = data["title"] as! String
                    let url = data["url"] as! String
                    let timestamp = data["timestamp"] as? Double
                    let imageURL = data["imageURL"] as! String
                    let article = Article(title: title, url: url, timestamp: timestamp ?? 0.0, imageURL: imageURL)
                    self.articles.append(article)
                }
                
            }
            
            self.tableView.reloadData()
            
        }
        
    }

}

extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let imageURL = URL(string: articles[indexPath.row].imageURL)
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsCell
        cell.articleTitleLbl.text = articles[indexPath.row].title
        
        if let imageURL = imageURL {
            cell.downloadImage(from: imageURL)
        } else {
            
        }
        
        return cell
          
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let urlString = articles[indexPath.row].url
        if let url = URL(string: urlString) {
            
            let sf = SFSafariViewController(url: url)
            present(sf, animated: true, completion: nil)
            
        }
        
    }
    
}
