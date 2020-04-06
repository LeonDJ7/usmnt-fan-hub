//
//  SignUpVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 8/21/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInVC: UIViewController, GIDSignInUIDelegate {
    
    let googleSignInBtn: GIDSignInButton = {
        let btn = GIDSignInButton()
        return btn
    }()
    
    let emailSignInBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        btn.layer.cornerRadius = 2
        btn.setTitle("Sign In", for: .normal)
        btn.titleLabel?.textColor = .white
        btn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 15)
        btn.addTarget(self, action: #selector(signInBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    let signUpBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("don't have an account? sign up here", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir Medium", size: 15)
        btn.setTitleColor(#colorLiteral(red: 1, green: 0.6067909002, blue: 0.5591675639, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(signUpBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    let emailTF: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont(name: "Avenir-Medium", size: 15)! // Note the !
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "email", attributes: attributes)
        tf.font = UIFont(name: "Avenir Medium", size: 15)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    let passwordTF: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont(name: "Avenir-Medium", size: 15)! // Note the !
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "password", attributes: attributes)
        tf.font = UIFont(name: "Avenir Medium", size: 15)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    let emailUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let passwordUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        setupLayout()
        
    }
    
    func setupLayout() {
        
        view.backgroundColor = .white
        
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(googleSignInBtn)
        view.addSubview(emailTF)
        view.addSubview(passwordTF)
        view.addSubview(emailSignInBtn)
        view.addSubview(emailUnderline)
        view.addSubview(passwordUnderline)
        view.addSubview(signUpBtn)
        
    }
    
    func applyAnchors() {
        
        googleSignInBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: view.centerYAnchor, centerYPad: -170, height: 48, width: 230)
        
        emailTF.anchors(top: googleSignInBtn.bottomAnchor, topPad: 80, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        passwordTF.anchors(top: emailTF.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        emailSignInBtn.anchors(top: passwordTF.bottomAnchor, topPad: 25, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        emailUnderline.anchors(top: emailTF.bottomAnchor, topPad: -7, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 222)
        
        passwordUnderline.anchors(top: passwordTF.bottomAnchor, topPad: -7, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 222)
        
        signUpBtn.anchors(top: emailSignInBtn.bottomAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 222)
        
    }
    
    @objc func signInBtnTapped() {
        
        guard let password = passwordTF.text,
            password != "",
            let email = emailTF.text,
            email != "" else {
                AlertController.showAlert(self, title: "Missing Info", message: "Please fill out all required fields")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                return
            }
            guard user?.user.uid != nil else {
                AlertController.showAlert(self, title: "Error", message: "User does not exist")
                return
            }
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func signOut(_sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    @objc func signUpBtnTapped() {
        let signUpVC = SignUpVC()
        navigationController?.pushViewController(signUpVC, animated: true)
    }

}
