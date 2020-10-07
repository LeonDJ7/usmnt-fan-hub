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
        addDoneButtonOnKeyboard()
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
        
        view.addSubview(postBtn)
        view.addSubview(parentTextLbl)
        view.addSubview(seperatorView)
        view.addSubview(replyTextView)
        
    }
    
    func applyAnchors() {
        
        if #available(iOS 11.0, *) {
            postBtn.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 20, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        } else {
            postBtn.anchors(top: view.topAnchor, topPad: 30, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        }
        
        parentTextLbl.anchors(top: postBtn.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        seperatorView.anchors(top: parentTextLbl.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
        replyTextView.anchors(top: seperatorView.bottomAnchor, topPad: 10, bottom: view.bottomAnchor, bottomPad: -30, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        replyTextView.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        replyTextView.resignFirstResponder()
    }
    
    func setPostInfo() {
        
        if parentIsComment == true {
            
            parentTextLbl.text = parentComment.text
            
        } else {
            
            parentTextLbl.text = parentTopic.text
            
        }
        
    }
    
    @objc func post() {
        
        guard let user = Auth.auth().currentUser else {
            let vc = AuthVC()
            present(vc, animated: true, completion: nil)
            return
        }
        
        if replyTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || replyTextView.text == "..." {
            // string doesn't contain non-whitespace characters
            AlertController.showAlert(self, title: "Error", message: "comment must contain non-whitespace characters")
            return
        }
        
        if parentIsComment == true {
            
            parentComment.addComment(timestamp: Date().timeIntervalSince1970, author: user.displayName!, authorUID: user.uid, text: replyTextView.text)
            
            parentCell.subTableView.isHidden = false
            
            dismiss(animated: true) {
                // refresh tableView with new comment, should automatically include new comment
                
                if let parentVC = self.parentTopicVC {
                    let deadline = DispatchTime.now() + .milliseconds(100)
                    DispatchQueue.main.asyncAfter(deadline: deadline) {
                        parentVC.tableView.reloadData()
                    }
                }
                
                if let parentVC = self.parentSubCommentVC {
                    let deadline = DispatchTime.now() + .milliseconds(100)
                    DispatchQueue.main.asyncAfter(deadline: deadline) {
                        parentVC.tableView.reloadData()
                    }
                }
                
            }
            
        } else {
            
            parentTopic.addComment(timestamp: Date().timeIntervalSince1970, author: user.displayName!, authorUID: user.uid, text: replyTextView.text)
            
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
