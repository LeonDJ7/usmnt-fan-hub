//
//  CreateForumVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 4/4/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class CreateForumVC: UIViewController {
    
    let popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 239/255, green: 141/255, blue: 137/255, alpha: 1)
        view.layer.cornerRadius = 5
        return view
    }()
    
    let confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("confirm", for: .normal)
        btn.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        btn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        btn.titleLabel?.font = UIFont(name: "Avenir-Book", size: 18)
        return btn
    }()
    
    let cancelBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
        btn.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        return btn
    }()
    
    let topicTF: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 18)! // Note the !
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "topic", attributes: attributes)
        tf.font = UIFont(name: "Avenir-Book", size: 18)
        tf.textColor = .darkGray
        return tf
    }()
    
    let descriptionTV: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Avenir-Book", size: 18)
        tv.layer.cornerRadius = 5
        tv.textColor = .darkGray
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        
    }
    
    func setupLayout() {
        
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(cancelBtn)
        view.addSubview(popUpView)
        popUpView.addSubview(topicTF)
        popUpView.addSubview(descriptionTV)
        popUpView.addSubview(confirmBtn)
        
    }
    
    func applyAnchors() {
        
        cancelBtn.anchors(top: view.topAnchor, topPad: 0, bottom: view.bottomAnchor, bottomPad: 0, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        popUpView.anchors(top: view.topAnchor, topPad: 200, bottom: nil, bottomPad: 0, left: view.leftAnchor , leftPad: 50, right: view.rightAnchor, rightPad: -50, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        topicTF.anchors(top: popUpView.topAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 10, right: popUpView.rightAnchor, rightPad: -10, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        descriptionTV.anchors(top: topicTF.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 10, right: popUpView.rightAnchor, rightPad: -10, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 70, width: 0)
        
        confirmBtn.anchors(top: descriptionTV.bottomAnchor, topPad: 10, bottom: popUpView.bottomAnchor, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 0, right: popUpView.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    @objc func confirm() {
        
        if topicTF.text == "" || descriptionTV.text == "" {
            AlertController.showAlert(self, title: "Error", message: "topic and description are both required fields")
            return
        }
        
        if let user = Auth.auth().currentUser {
            
            let questionData : [String : Any] = [
                "timestamp" : Double(NSDate().timeIntervalSince1970),
                "author" : user.displayName!,
                "authorUID" : user.uid,
                "description" : descriptionTV.text,
                "topic" : topicTF.text!
            ]
            
            Firestore.firestore().collection("Topics").document().setData(questionData)
            dismissPopUp()
            
        } else {
            
            let signInVC = SignInVC()
            present(signInVC, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func dismissPopUp() {
        dismiss(animated: true, completion: nil)
    }
    

}

extension CreateForumVC: UITextFieldDelegate {
    
    // limits answer character count
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 30
    }
    
}
