//
//  CreateForumVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 4/4/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class AddTopicVC: UIViewController {
    
    var parentVC = ForumHomeVC()
    var topics: [Topic]?
    
    let popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.5529411765, blue: 0.537254902, alpha: 1)
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
    
    let topicTV: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Avenir-Book", size: 17)
        tv.layer.cornerRadius = 5
        tv.autocorrectionType = .default
        tv.textColor = .white
        tv.tag = 0
        tv.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.5529411765, blue: 0.537254902, alpha: 1)
        tv.text = "topic"
        return tv
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let descriptionTV: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Avenir-Book", size: 15)
        tv.layer.cornerRadius = 5
        tv.autocorrectionType = .default
        tv.textColor = .white
        tv.tag = 1
        tv.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.5529411765, blue: 0.537254902, alpha: 1)
        tv.text = "description"
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        topicTV.delegate = self
        descriptionTV.delegate = self
        addDoneButtonOnKeyboard()
        setupLayout()
        
    }
    
    func setupLayout() {
        
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(cancelBtn)
        view.addSubview(popUpView)
        popUpView.addSubview(topicTV)
        popUpView.addSubview(seperatorView)
        popUpView.addSubview(descriptionTV)
        popUpView.addSubview(confirmBtn)
        
    }
    
    func applyAnchors() {
        
        cancelBtn.anchors(top: view.topAnchor, topPad: 0, bottom: view.bottomAnchor, bottomPad: 0, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        if #available(iOS 11.0, *) {
            popUpView.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 30, bottom: nil, bottomPad: 0, left: view.leftAnchor , leftPad: 50, right: view.rightAnchor, rightPad: -50, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        } else {
            popUpView.anchors(top: view.topAnchor, topPad: 70, bottom: nil, bottomPad: 0, left: view.leftAnchor , leftPad: 50, right: view.rightAnchor, rightPad: -50, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        }
        
        topicTV.anchors(top: popUpView.topAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 10, right: popUpView.rightAnchor, rightPad: -10, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 60, width: 0)
        
        seperatorView.anchors(top: topicTV.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 10, right: popUpView.rightAnchor, rightPad: -10, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
        descriptionTV.anchors(top: topicTV.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 10, right: popUpView.rightAnchor, rightPad: -10, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 120, width: 0)
        
        confirmBtn.anchors(top: descriptionTV.bottomAnchor, topPad: 10, bottom: popUpView.bottomAnchor, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 0, right: popUpView.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        topicTV.inputAccessoryView = doneToolbar
        descriptionTV.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        topicTV.resignFirstResponder()
        descriptionTV.resignFirstResponder()
    }
    
    @objc func confirm() {
        
        guard let user = Auth.auth().currentUser else {
            let vc = AuthVC()
            present(vc, animated: true, completion: nil)
            return
        }
        
        if topicTV.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || topicTV.text! == "topic" {
            AlertController.showAlert(self, title: "Error", message: "must provide topic")
            return
        }
        
        if descriptionTV.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || descriptionTV.text == "description" {
            AlertController.showAlert(self, title: "Error", message: "must provide description")
            return
        }
        
        let timestamp = Double(NSDate().timeIntervalSince1970)
        
        let questionData : [String : Any] = [
            "timestamp" : timestamp,
            "author" : user.displayName!,
            "authorUID" : user.uid,
            "text" : descriptionTV.text!,
            "topic" : topicTV.text!,
            "commentCount" : 0,
            "isSensitive":false
        ]

        var ref: DocumentReference? = nil
        ref = Firestore.firestore().collection("Topics").addDocument(data: questionData) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                Firestore.firestore().collection("Users").document(user.uid).collection("UserTopics").addDocument(data: ["docID":ref!.documentID])
            }
        }
        
        
        dismiss(animated: true) {
            
            // refresh parentVC tableview
            let newTopic = Topic(topic: self.topicTV.text!, timestamp: timestamp, author: user.displayName!, authorUID: user.uid, text: self.descriptionTV.text!, id: ref!.documentID, dbref: Firestore.firestore().collection("Topics").document(ref!.documentID), commentCount: 0, isSensitive: false)
            self.parentVC.allTopics.append(newTopic)
            self.parentVC.naturalTopics.append(newTopic)
            self.parentVC.topicsDisplayed.append(newTopic)
            self.parentVC.maxTopicsLoaded += 1
            self.parentVC.topicsDisplayed.sort { $0.timestamp > $1.timestamp }
            self.parentVC.tableView.reloadData()
            
        }
            
        
        
    }
    
    @objc func dismissPopUp() {
        dismiss(animated: true, completion: nil)
    }
    

}

extension AddTopicVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if self.view.window != nil {
            
            if textView.textColor == UIColor.white {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
            
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {

            if textView.tag == 0 {
                textView.text = "topic"
            } else {
                textView.text = "description"
            }
            
            textView.textColor = UIColor.white

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == UIColor.white && !text.isEmpty {
            textView.textColor = .darkGray
            textView.text = text
        } else {
            return true
        }
        
        return false
    }
    
    // prevents user from changing position of cursor
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        if self.view.window != nil {
            
            if textView.textColor == UIColor.white {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
            
        }
        
    }
    
}
