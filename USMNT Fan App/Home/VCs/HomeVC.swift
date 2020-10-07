//
//  NewsVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 7/15/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase
import SafariServices
import WebKit
import GoogleMobileAds

class HomeVC: UIViewController {
    
    var articles: [Article] = []
    
    var interstitial: GADInterstitial!
    
    var webContent = """
        <a class="twitter-timeline" href="https://twitter.com/usmnt_fan_hub/lists/app?ref_src=twsrc%5Etfw">A Twitter List by usmnt_fan_hub</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
        """
    
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
        btn.backgroundColor = #colorLiteral(red: 1, green: 0.859785378, blue: 0.8399332166, alpha: 1)
        return btn
    }()
    
    let newsLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        lbl.textColor = #colorLiteral(red: 1, green: 0.859785378, blue: 0.8399332166, alpha: 1)
        lbl.text = "news feed"
        return lbl
    }()
    
    let tweetsLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        lbl.textColor = #colorLiteral(red: 0.8201153874, green: 0.9376305938, blue: 1, alpha: 1)
        lbl.text = "latest tweets"
        return lbl
    }()
    
    let newsTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.isScrollEnabled = false
        tv.register(NewsCell.self, forCellReuseIdentifier: "newsCell")
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
    
    let tweetWebView: WKWebView = {
        let wv = WKWebView()
        return wv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newsTableView.delegate = self
        newsTableView.dataSource = self
        tweetWebView.navigationDelegate = self
        
        loadArticles()
        tweetWebView.loadHTMLString(webContent, baseURL: nil)
        setupLayout()
        
        interstitial = createAndLoadInterstitial()
        
    }
    
    func setupLayout() {
        
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        
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
        view.addSubview(tweetWebView)
        
    }
    
    func applyAnchors() {
        
        if #available(iOS 11.0, *) {
            welcomeView.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        } else {
            welcomeView.anchors(top: view.topAnchor, topPad: 50, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        }
        
        welcomeLbl.anchors(top: welcomeView.topAnchor, topPad: 10, bottom: welcomeView.bottomAnchor, bottomPad: -5, left: welcomeView.leftAnchor, leftPad: 10, right: welcomeView.rightAnchor, rightPad: -50, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        settingsBtn.anchors(top: welcomeView.topAnchor, topPad: 0, bottom: welcomeView.bottomAnchor, bottomPad: 0, left: welcomeLbl.rightAnchor, leftPad: 0, right: welcomeView.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        newsLbl.anchors(top: welcomeView.bottomAnchor, topPad: 30, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        newsTableView.anchors(top: newsLbl.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 100, width: 0)
        
        moreNewsBtn.anchors(top: newsTableView.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        tweetsLbl.anchors(top: moreNewsBtn.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        tweetWebView.anchors(top: tweetsLbl.bottomAnchor, topPad: 10, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)! - 10, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func loadArticles() {
        
        Firestore.firestore().collection("News").order(by: "timestamp", descending: true).limit(to: 2).getDocuments { (snap, err) in
            
            guard err == nil else {
                print(err?.localizedDescription as Any)
                return
            }
            
            if let snap = snap {
                
                for document in snap.documents {
                    let data = document.data()
                    let title = data["title"] as! String
                    let url = data["url"] as! String
                    let timestamp = data["timestamp"] as! Double
                    let imageURL = data["imageURL"] as! String
                    let article = Article(title: title, url: url, timestamp: timestamp, imageURL: imageURL)
                    self.articles.append(article)
                }
                
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
            present(authVC, animated: true, completion: nil)
        }
        
    }
    
    @objc func moreNewsBtnTapped() {
        
        let vc = NewsVC()
        
        let random = arc4random_uniform(3)
        
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
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
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

extension HomeVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
          decisionHandler(.allow)
        }
    }
    
}

extension HomeVC: GADInterstitialDelegate {
    
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
