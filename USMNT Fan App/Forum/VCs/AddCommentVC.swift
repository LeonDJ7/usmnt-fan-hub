//
//  AddCommentVC.swift
//  USMNT Fan App
//
//  Created by Leon Djusberg on 5/31/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class AddCommentVC: UIViewController {
    
    var parentTopic = Topic()
    var parentComment = Comment()
    var parentTopicVC: TopicVC?
    var parentSubCommentVC: SubCommentVC?
    var parentCell = CommentCell()
    var parentIsComment = false
    
    let backBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        btn.setImage(UIImage(named: "Cancel"), for: .normal)
        return btn
    }()
    
    let postBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "Check"), for: .normal)
        btn.addTarget(self, action: #selector(post), for: .touchUpInside)
        return btn
    }()
    
    let parentTextLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        lbl.textColor = .white
        return lbl
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let replyTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Avenir-Book", size: 16)
        tv.textColor = .lightGray
        tv.text = "..."
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.autocorrectionType = .default
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replyTextView.delegate = self
        replyTextView.becomeFirstResponder()
        replyTextView.selectedTextRange = replyTextView.textRange(from: replyTextView.beginningOfDocument, to: replyTextView.beginningOfDocument)
        
        setupLayout()
    }
    
    func setupLayout() {
        
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        replyTextView.delegate = self
        setPostInfo()
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(backBtn)
        view.addSubview(postBtn)
        view.addSubview(parentTextLbl)
        view.addSubview(seperatorView)
        view.addSubview(replyTextView)
        
    }
    
    func applyAnchors() {
        
        backBtn.anchors(top: view.topAnchor, topPad: 30, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        postBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: backBtn.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        parentTextLbl.anchors(top: backBtn.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        seperatorView.anchors(top: parentTextLbl.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
        replyTextView.anchors(top: seperatorView.bottomAnchor, topPad: 10, bottom: view.bottomAnchor, bottomPad: -30, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func setPostInfo() {
        
        if parentIsComment == true {
            
            parentTextLbl.text = parentComment.text
            
        } else {
            
            parentTextLbl.text = parentTopic.text
            
        }
        
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func post() {
        
        if replyTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // string doesn't contain non-whitespace characters
            AlertController.showAlert(self, title: "Error", message: "comment must contain non-whitespace characters")
            return
        }
        
        if parentIsComment == true {
            
            parentComment.addComment(timestamp: Date().timeIntervalSince1970, author: (Auth.auth().currentUser?.displayName)!, authorUID: Auth.auth().currentUser!.uid, text: replyTextView.text)
            
            parentCell.subTableView.isHidden = false
            
            dismiss(animated: true) {
                // refresh tableView with new comment, should automatically include new comment
                
                if let parentVC = self.parentTopicVC {
                    parentVC.tableView.reloadData()
                }
                
                if let parentVC = self.parentSubCommentVC {
                    parentVC.tableView.reloadData()
                }
                
            }
            
        } else {
            
            parentTopic.addComment(timestamp: Date().timeIntervalSince1970, author: (Auth.auth().currentUser?.displayName)!, authorUID: Auth.auth().currentUser!.uid, text: replyTextView.text)
            
            dismiss(animated: true) {
                // refresh tableView with new comment, should automatically include new comment
                
                if let parentVC = self.parentTopicVC {
                    parentVC.tableView.reloadData()
                }
                
                if let parentVC = self.parentSubCommentVC {
                    parentVC.tableView.reloadData()
                }
                
            }
            
        }
        
    }

}

extension AddCommentVC: UITextViewDelegate {
    
    // removes placeholder if string length is not 0
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {

            textView.text = "..."
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = #colorLiteral(red: 0.8058902025, green: 0.9378458858, blue: 1, alpha: 1)
            textView.text = text
        } else {
            return true
        }
        
        return false
    }
    
    // prevents user from changing position of cursor
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        if self.view.window != nil {
            
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
            
        }
        
    }
    
}
