//
//  CommentCell.swift
//  USMNT Fan App
//
//  Created by Leon Djusberg on 5/11/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class CommentCell: UITableViewCell {
    
    var showSubComments = false
    var comment: Comment = Comment()
    var subComments: [Comment] = []
    
    let subTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.isScrollEnabled = false
        tv.register(CommentCell.self, forCellReuseIdentifier: "subCommentCell")
        return tv
    }()
    
    let authorImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 10
        return imgView
    }()
    
    let likeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("L", for: .normal)
        btn.addTarget(self, action: #selector(likeBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    let likesLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        return lbl
    }()
    
    let dislikeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("D", for: .normal)
        btn.addTarget(self, action: #selector(dislikeBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    let addCommentBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("C", for: .normal)
        return btn
    }()
    
    let authorAndTimePostedLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 14)
        lbl.textColor = .gray
        lbl.textAlignment = .left
        return lbl
    }()
    
    let textLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.font = UIFont(name: "Avenir-Book", size: 16)
        return lbl
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        
        backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        addSubview(authorImageView)
        addSubview(authorAndTimePostedLbl)
        addSubview(textLbl)
        addSubview(likeBtn)
        addSubview(likesLbl)
        addSubview(dislikeBtn)
        addSubview(addCommentBtn)
        addSubview(seperatorView)
        addSubview(subTableView)
        
    }
    
    func applyAnchors() {
        
        authorImageView.anchors(top: topAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: leftAnchor, leftPad: 30, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 20, width: 20)
        
        authorAndTimePostedLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: authorImageView.rightAnchor, leftPad: 5, right: rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: authorImageView.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        textLbl.anchors(top: authorAndTimePostedLbl.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: leftAnchor, leftPad: 30, right: rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        likeBtn.anchors(top: textLbl.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: leftAnchor, leftPad: 30, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 20)
        
        likesLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: likeBtn.rightAnchor, leftPad: 3, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: likeBtn.centerYAnchor, centerYPad: 0, height: 0, width: 20)
        
        dislikeBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: likesLbl.rightAnchor, leftPad: 3, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: likeBtn.centerYAnchor, centerYPad: 0, height: 0, width: 20)
        
        addCommentBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: dislikeBtn.rightAnchor, leftPad: 6, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: likeBtn.centerYAnchor, centerYPad: 0, height: 0, width: 20)
        
        seperatorView.anchors(top: likeBtn.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: leftAnchor, leftPad: 60, right: rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
        subTableView.anchors(top: seperatorView.bottomAnchor, topPad: 5, bottom: bottomAnchor, bottomPad: 0, left: leftAnchor, leftPad: 60, right: rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func setAuthorProfileImage(uid: String) {
        
        let storageRef = Storage.storage().reference(forURL: "gs://usmnt-fan-app.appspot.com").child("profile_image").child(uid)
        
        let imageURL = storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            
            if let error = error {
                print("Error: \(error)")
            } else {
                self.authorImageView.image = UIImage(data: data!)!
            }
        }
    }
    
    func translateTimestamp(timestamp: Double) -> String {
        
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: date)
        
        return dateString
        
    }
    
    @objc func likeBtnTapped() {
        
        comment.likes += 1
        likesLbl.text = "\(comment.likes)"
        
        let likes = comment.dbref.value(forKey: "likes") as! Int + 1
        comment.dbref.updateData(["likes" : likes])
        
    }
    
    @objc func dislikeBtnTapped() {
        
        comment.likes -= 1
        likesLbl.text = "\(comment.likes)"
        
        let likes = comment.dbref.value(forKey: "likes") as! Int - 1
        comment.dbref.updateData(["likes" : likes])
        
    }

}

extension CommentCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCommentCell") as! CommentCell
        
        // set all data
        
        cell.comment = subComments[indexPath.row]
        cell.authorAndTimePostedLbl.text = subComments[indexPath.row].author + " : " + translateTimestamp(timestamp: subComments[indexPath.row].timestamp)
        cell.textLbl.text = subComments[indexPath.row].text
        cell.likesLbl.text = "\(subComments[indexPath.row].likes)"
        cell.setAuthorProfileImage(uid: subComments[indexPath.row].authorUID)
        
        // load comments of current comment. if greater than 0, activate subTableView and reloadData? or just do it anyways
        
        subComments[indexPath.row].loadComments()
        
        let deadline = DispatchTime.now() + .milliseconds(100)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.subComments = self.subComments[indexPath.row].comments
            self.subTableView.reloadData()
        }
        
        return cell
        
    }
    
}
