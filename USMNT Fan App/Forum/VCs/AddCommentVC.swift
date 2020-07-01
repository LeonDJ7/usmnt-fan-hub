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
    
    var parentPost = Topic()
    var threadVC = TopicVC()
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
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        return tv
    }()
    
    let placeHolderLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 16)
        lbl.textColor = .lightGray
        lbl.text = "..."
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        view.addSubview(placeHolderLbl)
        
    }
    
    func applyAnchors() {
        
        backBtn.anchors(top: view.topAnchor, topPad: 30, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        postBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: backBtn.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        parentTextLbl.anchors(top: backBtn.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        seperatorView.anchors(top: parentTextLbl.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
        replyTextView.anchors(top: seperatorView.bottomAnchor, topPad: 10, bottom: view.bottomAnchor, bottomPad: -30, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        placeHolderLbl.anchors(top: replyTextView.topAnchor, topPad: 4, bottom: nil, bottomPad: 0, left: replyTextView.leftAnchor, leftPad: 3, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func setPostInfo() {
        
        parentTextLbl.text = parentPost.text
        
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func post() {
        
        parentPost.addComment(topic: parentPost.topic, timestamp: Date().timeIntervalSince1970, author: (Auth.auth().currentUser?.displayName)!, authorUID: Auth.auth().currentUser!.uid, text: replyTextView.text)
        
        dismiss(animated: true) {
            // refresh tableView with new comment, should automatically include new comment if parentPost is passed by reference, not value
            self.threadVC.tableView.reloadData()
        }
        
    }

}

extension AddCommentVC: UITextViewDelegate {
    
    // removes placeholder if string length is not 0
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let strLength = textField.text?.count ?? 0
        let lngthToAdd = string.count
        let newLength = strLength + lngthToAdd
        if (newLength > 0) {
            placeHolderLbl.isHidden = true
        }
        return true
    }
    
}
