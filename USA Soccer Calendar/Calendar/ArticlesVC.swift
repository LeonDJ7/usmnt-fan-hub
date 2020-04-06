//
//  ArticlesVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 1/17/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds


class ArticlesVC: UIViewController, GADBannerViewDelegate {
    
    var articleLinks: [String] = []
    var articleTitles: [String] = []
    let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    let articlesLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Related Articles"
        lbl.font = UIFont(name: "Avenir-Book", size: 26)
        lbl.textAlignment = .center
        lbl.textColor = UIColor(displayP3Red: 239/255, green: 141/255, blue: 137/255, alpha: 1)
        return lbl
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .singleLine
        tv.separatorColor = #colorLiteral(red: 0.7255366445, green: 0.9203955531, blue: 1, alpha: 1)
        tv.register(ArticlesTVCell.self, forCellReuseIdentifier: "articleCell")
        return tv
    }()
    
    let backBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "Cancel"), for: .normal)
        btn.addTarget(self, action: #selector(returnToEventsVC), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadEvents()
        setupLayout()
        setupBannerView()
        
    }
    
    func setupLayout() {
        
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(backBtn)
        view.addSubview(tableView)
        view.addSubview(articlesLbl)
        
    }
    
    func applyAnchors() {
        
        backBtn.anchors(top: view.topAnchor, topPad: 60, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 16, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        
        tableView.anchors(top: backBtn.bottomAnchor, topPad: 40, bottom: view.bottomAnchor, bottomPad: 0, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        articlesLbl.anchors(top: nil, topPad: 0, bottom: tableView.topAnchor, bottomPad: -10, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    private func setupBannerView() {
        view.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-2790005755690511/5598345228"
        bannerView.rootViewController = self
        let bannerRequest = GADRequest()
        bannerView.load(bannerRequest)
        bannerView.delegate = self
        bannerView.anchors(top: nil, topPad: 0, bottom: view.bottomAnchor, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
    }
    
    func loadEvents() {
        Firestore.firestore().collection("Years").document(String(selectedYear)).collection("Events").document(selectedEvent).collection("Articles").getDocuments { (snap, error) in
            
            for document in snap!.documents {
                let data = document.data()
                let link = data["link"] as! String
                let title = data["title"] as! String
                self.articleLinks.append(link)
                self.articleTitles.append(title)
            }
            self.tableView.reloadData()
        }
        
    }
    
    @objc func returnToEventsVC() {
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
        return articleLinks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = articleLinks[indexPath.row]
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell") as! ArticlesTVCell
        cell.articleNameLbl.numberOfLines = 0
        cell.articleNameLbl.text = articleTitles[indexPath.row]
        
        return cell
    }
    
}
