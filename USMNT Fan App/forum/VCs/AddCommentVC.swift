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
    
    let backBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        btn.setImage(UIImage(named: "BackArrow"), for: .normal)
        return btn
    }()
    
    let scrollView = UIScrollView()
    let scrollViewContainer = UIView()
    
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
        tv.autocapitalizationType = .none
        tv.autocorrectionType = .no
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.contentSize.height = self.view.frame.size.height * 3
        scrollView.contentSize.width = self.view.frame.size.width
        replyTextView.delegate = self
        replyTextView.becomeFirstResponder()
        replyTextView.selectedTextRange = replyTextView.textRange(from: replyTextView.beginningOfDocument, to: replyTextView.beginningOfDocument)
        addDoneButtonOnKeyboard()
        setupLayout()
        
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = CGSize(width: contentRect.size.width, height: contentRect.size.height + 3000)
        
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
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addSubview(parentTextLbl)
        scrollViewContainer.addSubview(seperatorView)
        scrollViewContainer.addSubview(replyTextView)
        
    }
    
    func applyAnchors() {
        
        if #available(iOS 11.0, *) {
            backBtn.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        } else {
            backBtn.anchors(top: view.topAnchor, topPad: 50, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        }
        
        if #available(iOS 11.0, *) {
            postBtn.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 20, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        } else {
            postBtn.anchors(top: view.topAnchor, topPad: 30, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: backBtn.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(self.tabBarController?.tabBar.frame.size.height)!).isActive = true
        
        scrollViewContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        parentTextLbl.anchors(top: scrollViewContainer.topAnchor, topPad: 20, bottom: nil, bottomPad: 0, left: scrollViewContainer.leftAnchor, leftPad: 30, right: scrollViewContainer.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        seperatorView.anchors(top: parentTextLbl.bottomAnchor, topPad: 20, bottom: nil, bottomPad: 0, left: scrollViewContainer.leftAnchor, leftPad: 30, right: scrollViewContainer.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
        replyTextView.anchors(top: seperatorView.bottomAnchor, topPad: 10, bottom: scrollViewContainer.bottomAnchor, bottomPad: 0, left: scrollViewContainer.leftAnchor, leftPad: 30, right: scrollViewContainer.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1500, width: 0)
        
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

    @objc func doneButtonAction() {
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
            
            navigationController?.popViewController(animated: true)
            
        } else {
            
            parentTopic.addComment(timestamp: Date().timeIntervalSince1970, author: user.displayName!, authorUID: user.uid, text: replyTextView.text)
            
            // refresh tableView with new comment, should automatically include new comment
            
            if let parentVC = self.parentTopicVC {
                parentVC.tableView.reloadData()
            }
            
            if let parentVC = self.parentSubCommentVC {
                parentVC.tableView.reloadData()
            }
            
            navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
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
