//
//  ArticlesVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 1/17/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase
import SafariServices
import GoogleMobileAds


class ArticlesVC: UIViewController {
    
    var articles: [Article] = []
    
    let articlesLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "related articles"
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.register(NewsCell.self, forCellReuseIdentifier: "newsCell")
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
        
        loadEvents()
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
        view.addSubview(articlesLbl)
        
    }
    
    func applyAnchors() {
        
        if #available(iOS 11.0, *) {
            backBtn.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 16, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        } else {
            backBtn.anchors(top: view.topAnchor, topPad: 50, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 16, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        }
        
        if #available(iOS 11.0, *) {
            articlesLbl.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        } else {
            articlesLbl.anchors(top: view.topAnchor, topPad: 50, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        }
        
        tableView.anchors(top: articlesLbl.bottomAnchor, topPad: 40, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)! - 10, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func loadEvents() {
        
        Firestore.firestore().collection("Years").document(String(selectedYear)).collection("Events").document(selectedEvent).collection("Articles").getDocuments { (snap, error) in
            
            if let snap = snap {
                
                for document in snap.documents {
                    let data = document.data()
                    let url = data["url"] as! String
                    let title = data["title"] as! String
                    let imageURL = data["imageURL"] as! String
                    let article = Article(title: title, url: url, timestamp: 0, imageURL: imageURL)
                    self.articles.append(article)
                }
                
            }
            
            self.tableView.reloadData()
            
        }
        
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ArticlesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = articles[indexPath.row].url
        if let url = URL(string: urlString) {
            
            let sf = SFSafariViewController(url: url)
            present(sf, animated: true, completion: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let imageURL = URL(string: articles[indexPath.row].imageURL)
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsCell
        cell.articleTitleLbl.text = articles[indexPath.row].title
        
        if let imageURL = imageURL {
            cell.downloadImage(from: imageURL)
        }
        
        return cell
        
    }
    
}
