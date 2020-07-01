//
//  File.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 8/3/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class CreatePollVC: UIViewController {
    
    let popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 239/255, green: 141/255, blue: 137/255, alpha: 1)
        view.layer.cornerRadius = 5
        return view
    }()
    
    let answer1TF: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 15)! // Note the !
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "answer 1", attributes: attributes)
        tf.font = UIFont(name: "Avenir-Book", size: 15)
        tf.textColor = .darkGray
        tf.autocorrectionType = .no
        return tf
    }()
    
    let answer2TF: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 15)! // Note the !
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "answer 2", attributes: attributes)
        tf.font = UIFont(name: "Avenir-Book", size: 15)
        tf.textColor = .darkGray
        tf.autocorrectionType = .no
        return tf
    }()
    
    let answer3TF: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 15)! // Note the !
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "answer 3 (optional)", attributes: attributes)
        tf.font = UIFont(name: "Avenir-Book", size: 15)
        tf.textColor = .darkGray
        tf.autocorrectionType = .no
        return tf
    }()
    
    let answer4TF: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 15)! // Note the !
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "answer 4 (optional)", attributes: attributes)
        tf.font = UIFont(name: "Avenir-Book", size: 15)
        tf.autocorrectionType = .no
        tf.textColor = .darkGray
        return tf
    }()
    
    let underlineView1: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let underlineView2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let underlineView3: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let underlineView4: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let questionTV: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Avenir-Book", size: 18)
        tv.layer.cornerRadius = 5
        tv.autocorrectionType = .no
        tv.textColor = .darkGray
        return tv
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        answer1TF.delegate = self
        answer2TF.delegate = self
        answer3TF.delegate = self
        answer4TF.delegate = self
        
    }
    
    func setupLayout() {
        
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(cancelBtn)
        view.addSubview(popUpView)
        popUpView.addSubview(questionTV)
        popUpView.addSubview(answer1TF)
        popUpView.addSubview(underlineView1)
        popUpView.addSubview(answer2TF)
        popUpView.addSubview(underlineView2)
        popUpView.addSubview(answer3TF)
        popUpView.addSubview(underlineView3)
        popUpView.addSubview(answer4TF)
        popUpView.addSubview(underlineView4)
        popUpView.addSubview(confirmBtn)
        
    }
    
    func applyAnchors() {
        
        cancelBtn.anchors(top: view.topAnchor, topPad: 0, bottom: view.bottomAnchor, bottomPad: 0, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        popUpView.anchors(top: view.topAnchor, topPad: 200, bottom: nil, bottomPad: 0, left: view.leftAnchor , leftPad: 50, right: view.rightAnchor, rightPad: -50, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        questionTV.anchors(top: popUpView.topAnchor, topPad: 15, bottom: nil, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 15, right: popUpView.rightAnchor, rightPad: -15, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 70, width: 0)
        
        answer1TF.anchors(top: questionTV.bottomAnchor, topPad: 30, bottom: nil, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 15, right: popUpView.rightAnchor, rightPad: -15, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        underlineView1.anchors(top: answer1TF.bottomAnchor, topPad: 1, bottom: nil, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 15, right: popUpView.rightAnchor, rightPad: -15, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
        answer2TF.anchors(top: underlineView1.bottomAnchor, topPad: 15, bottom: nil, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 15, right: popUpView.rightAnchor, rightPad: -15, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        underlineView2.anchors(top: answer2TF.bottomAnchor, topPad: 1, bottom: nil, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 15, right: popUpView.rightAnchor, rightPad: -15, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
        answer3TF.anchors(top: underlineView2.bottomAnchor, topPad: 15, bottom: nil, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 15, right: popUpView.rightAnchor, rightPad: -15, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        underlineView3.anchors(top: answer3TF.bottomAnchor, topPad: 1, bottom: nil, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 15, right: popUpView.rightAnchor, rightPad: -15, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
        answer4TF.anchors(top: underlineView3.bottomAnchor, topPad: 15, bottom: nil, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 15, right: popUpView.rightAnchor, rightPad: -15, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        underlineView4.anchors(top: answer4TF.bottomAnchor, topPad: 1, bottom: nil, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 15, right: popUpView.rightAnchor, rightPad: -15, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
        confirmBtn.anchors(top: answer4TF.bottomAnchor, topPad: 30, bottom: popUpView.bottomAnchor, bottomPad: 0, left: popUpView.leftAnchor, leftPad: 0, right: popUpView.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    @objc func confirm() {
        
        if questionTV.text == "" {
            AlertController.showAlert(self, title: "Error", message: "must provide question")
            return
        }
        
        if answer1TF.text == "" && answer2TF.text == "" {
            AlertController.showAlert(self, title: "Error", message: "must provide at least 2 answer options")
            return
        }
        
        if answer4TF.text != "" && answer3TF.text == "" {
            AlertController.showAlert(self, title: "Error", message: "must provide 3rd answer option if also providing 4th answer option")
            return
        }
        
        var totalAnswerOptions = 4
        
        if answer4TF.text == "" {
            totalAnswerOptions -= 1
        }
        
        if answer3TF.text == "" {
            totalAnswerOptions -= 1
        }
        
        if let user = Auth.auth().currentUser {
            
            let questionData : [String : Any] = [
                "question" : questionTV.text!,
                "answer1" : answer1TF.text!,
                "answer2" : answer2TF.text!,
                "answer3" : answer3TF.text!,
                "answer4" : answer4TF.text!,
                "answer1Score" : 0,
                "answer2Score" : 0,
                "answer3Score" : 0,
                "answer4Score" : 0,
                "timestamp" : Double(NSDate().timeIntervalSince1970),
                "totalAnswerOptions" : totalAnswerOptions,
                "totalVotes" : 0,
                "author" : user.displayName!,
                "authorUID" : user.uid
            ]
            
            var ref: DocumentReference? = nil
            var docID = ""
            ref = Firestore.firestore().collection("Polls").addDocument(data: questionData) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    docID = ref!.documentID
                    Firestore.firestore().collection("Users").document(user.uid).collection("UserPolls").addDocument(data: ["docID":docID])
                }
            }
            
            let poll = Poll(question: questionTV.text!, author: user.displayName!, authorUID: user.uid, answer1: answer1TF.text!, answer2: answer2TF.text!, answer3: answer3TF.text!, answer4: answer4TF.text!, answer1Score: 0, answer2Score: 0, answer3Score: 0, answer4Score: 0, timestamp: Double(NSDate().timeIntervalSince1970), totalAnswerOptions: Double(totalAnswerOptions), docID: docID)
            
            dismiss(animated: true) {
                
                if let myParent = self.parent as? PollsVC {
                    myParent.polls.append(poll)
                    myParent.tableView.reloadData()
                }
                
            }
            
        } else {
            
            let vc = AuthVC()
            present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func dismissPopUp() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CreatePollVC: UITextFieldDelegate {
    
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
