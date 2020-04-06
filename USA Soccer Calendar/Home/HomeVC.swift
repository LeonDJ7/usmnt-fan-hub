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
    
    let articleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 15)
        lbl.textColor = .white
        return lbl
    }()
    
    let tweetLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 15)
        lbl.textColor = .white
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
    }
    
    func setupLayout() { // initialise UI
        
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
    
        view.addSubview(welcomeView)
        welcomeView.addSubview(welcomeLbl)
        welcomeView.addSubview(settingsBtn)
        view.addSubview(articleLbl)
        view.addSubview(tweetLbl)
        
    }
    
    func applyAnchors() {
        
        welcomeView.anchors(top: view.topAnchor, topPad: 60, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        welcomeLbl.anchors(top: welcomeView.topAnchor, topPad: 10, bottom: welcomeView.bottomAnchor, bottomPad: -5, left: welcomeView.leftAnchor, leftPad: 10, right: welcomeView.rightAnchor, rightPad: -50, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        settingsBtn.anchors(top: welcomeView.topAnchor, topPad: 0, bottom: welcomeView.bottomAnchor, bottomPad: 0, left: welcomeLbl.rightAnchor, leftPad: 0, right: welcomeView.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    @objc func settingsBtnTapped() {
        
        let settingsVC = SettingsVC()
        let signInVC = SignInVC()
        
        if Auth.auth().currentUser != nil {
            // take to settingsVC
            self.navigationController?.pushViewController(settingsVC, animated: true)
        } else {
            // take to sign in page or give option
            
            let signInNavController = UINavigationController(rootViewController: signInVC)
            signInNavController.navigationBar.isHidden = true
            
            present(signInVC, animated: true, completion: nil)
        }
        
    }
    
}
