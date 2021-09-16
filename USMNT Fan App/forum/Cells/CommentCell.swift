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
    
    var comment: Comment = Comment()
    var delegate: CommentCellDelegate?
    var parentTopicVC: TopicVC?
    var parentSubCommentVC: SubCommentVC?
    var parentCell: CommentCell?
    var blockedUIDs: [String] = []
    
    let subTableView: CustomTableView = {
        let tv = CustomTableView()
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
        btn.setImage(UIImage(named: "LikeBtnImage"), for: .normal)
        return btn
    }()
    
    let likesLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont(name: "Avenir-Book", size: 16)
        return lbl
    }()
    
    let dislikeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "DislikeBtnImage"), for: .normal)
        return btn
    }()
    
    let subCommentBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "CommentBtnImage"), for: .normal)
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
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont(name: "Avenir-Book", size: 16)
        return lbl
    }()
    
    let horizontalSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let verticalSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let topVertSeperatorCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        return view
    }()
    
    let bottomVertSeperatorCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        return view
    }()
    
    let deleteBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setImage(UIImage(named: "DeleteBtnImage"), for: .normal)
        return btn
    }()
    
    let deletedLbl: UILabel = {
        let lbl = UILabel()
        lbl.isHidden = true
        lbl.textColor = .white
        lbl.text = "this comment has been deleted"
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Book", size: 16)
        return lbl
    }()
    
    let commentsOutOfRangeBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.titleLabel?.font = UIFont(name: "Avenir-Book", size: 14)
        btn.titleLabel?.textColor = #colorLiteral(red: 1, green: 0.7053028941, blue: 0.7190689445, alpha: 1)
        btn.setTitle("continue thread...", for: .normal)
        return btn
    }()
    
    let reportBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setImage(UIImage(named: "ReportBtnImage"), for: .normal)
        return btn
    }()
    
    let sensitiveContentWarningBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setTitle("view sensitive content?", for: .normal)
        btn.titleLabel!.textColor = .white
        btn.titleLabel!.font = UIFont(name: "Avenir-Book", size: 16)
        return btn
    }()
    
    let blockedLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "this user is blocked"
        lbl.font = UIFont(name: "Avenir-Medium", size: 18)
        lbl.textColor = .white
        lbl.isHidden = true
        lbl.textAlignment = .center
        return lbl
    }()
    
    let unblockBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setTitle("unblock?", for: .normal)
        btn.titleLabel!.textColor = .white
        btn.titleLabel!.font = UIFont(name: "Avenir-Book", size: 14)
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        subTableView.delegate = self
        subTableView.dataSource = self
        
        setupLayout()
        addTargets() // connect each btn with its method
        randomizeColor()
        
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
        addSubview(subCommentBtn)
        addSubview(subTableView)
        addSubview(deleteBtn)
        addSubview(reportBtn)
        addSubview(deletedLbl)
        addSubview(commentsOutOfRangeBtn)
        addSubview(horizontalSeperatorView)
        addSubview(verticalSeperatorView)
        addSubview(topVertSeperatorCoverView)
        addSubview(bottomVertSeperatorCoverView)
        addSubview(sensitiveContentWarningBtn)
        addSubview(blockedLbl)
        addSubview(unblockBtn)
        
    }
    
    func applyAnchors() {
        
        authorImageView.anchors(top: topAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 20, width: 20)
        
        authorAndTimePostedLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: authorImageView.rightAnchor, leftPad: 10, right: rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: authorImageView.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        deleteBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: authorAndTimePostedLbl.centerYAnchor, centerYPad: 0, height: 20, width: 20)
        
        reportBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: authorAndTimePostedLbl.centerYAnchor, centerYPad: 0, height: 20, width: 20)
        
        textLbl.anchors(top: authorAndTimePostedLbl.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: leftAnchor, leftPad: 25, right: rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        likeBtn.anchors(top: textLbl.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 30, width: 30)
        
        likesLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: likeBtn.rightAnchor, leftPad: 3, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: likeBtn.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        dislikeBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: likesLbl.rightAnchor, leftPad: 3, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: likeBtn.centerYAnchor, centerYPad: 0, height: 30, width: 30)
        
        subCommentBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: dislikeBtn.rightAnchor, leftPad: 6, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: likeBtn.centerYAnchor, centerYPad: 0, height: 30, width: 30)
        
        horizontalSeperatorView.anchors(top: likeBtn.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: leftAnchor, leftPad: 20, right: rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
        verticalSeperatorView.anchors(top: subTableView.topAnchor, topPad: 0, bottom: subTableView.bottomAnchor, bottomPad: 0, left: horizontalSeperatorView.leftAnchor, leftPad: 9, right: horizontalSeperatorView.leftAnchor, rightPad: 10, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 1)
        
        topVertSeperatorCoverView.anchors(top: verticalSeperatorView.topAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: verticalSeperatorView.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 15, width: 1)
        
        bottomVertSeperatorCoverView.anchors(top: nil, topPad: 0, bottom: verticalSeperatorView.bottomAnchor, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: verticalSeperatorView.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 15, width: 1)
        
        subTableView.anchors(top: horizontalSeperatorView.bottomAnchor, topPad: 5, bottom: bottomAnchor, bottomPad: 0, left: leftAnchor, leftPad: 20, right: rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        deletedLbl.anchors(top: textLbl.topAnchor, topPad: 0, bottom: textLbl.bottomAnchor, bottomPad: 0, left: textLbl.leftAnchor, leftPad: 0, right: textLbl.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        sensitiveContentWarningBtn.anchors(top: textLbl.topAnchor, topPad: 0, bottom: textLbl.bottomAnchor, bottomPad: 0, left: textLbl.leftAnchor, leftPad: 0, right: textLbl.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        blockedLbl.anchors(top: textLbl.topAnchor, topPad: 0, bottom: textLbl.bottomAnchor, bottomPad: 0, left: textLbl.leftAnchor, leftPad: 0, right: textLbl.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        unblockBtn.anchors(top: blockedLbl.bottomAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: blockedLbl.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func setAuthorProfileImage(uid: String) {
        
        let storageRef = Storage.storage().reference(forURL: "gs://usmnt-fan-app.appspot.com").child("profile_image").child(uid)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            
            if let error = error {
                print("Error: \(error)")
                self.authorImageView.image = UIImage()
            } else {
                self.authorImageView.image = UIImage(data: data!)!
            }
        }
    }
    
    func translateTimestamp(timestamp: Double) -> String {
        
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateString = formatter.string(from: date)
        
        return dateString
        
    }
    
    func addTargets() {
        
        likeBtn.addTarget(self, action: #selector(likeBtnTapped), for: .touchUpInside)
        dislikeBtn.addTarget(self, action: #selector(dislikeBtnTapped), for: .touchUpInside)
        subCommentBtn.addTarget(self, action: #selector(subCommentBtnTapped(sender:)), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleteBtnTapped(sender:)), for: .touchUpInside)
        commentsOutOfRangeBtn.addTarget(self, action: #selector(commentsOutOfRangeBtnTapped), for: .touchUpInside)
        reportBtn.addTarget(self, action: #selector(reportCommentBtnTapped), for: .touchUpInside)
        unblockBtn.addTarget(self, action: #selector(unblockComment), for: .touchUpInside)
        sensitiveContentWarningBtn.addTarget(self, action: #selector(ignoreCommentSensitiveContent), for: .touchUpInside)
        
    }
    
    func randomizeColor() {
        
        let randomNumber = arc4random_uniform(8)
        let backgroundColor: UIColor
        
        switch randomNumber {
        case 0:
            backgroundColor = #colorLiteral(red: 0.8484226465, green: 0.9622095227, blue: 0.9975820184, alpha: 1)
        case 1:
            backgroundColor = #colorLiteral(red: 0.9808904529, green: 0.8153990507, blue: 0.8155520558, alpha: 1)
        case 2:
            backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case 3:
            backgroundColor = #colorLiteral(red: 0.8720894456, green: 0.8917983174, blue: 0.9874122739, alpha: 1)
        case 4:
            backgroundColor = #colorLiteral(red: 0.9295411706, green: 1, blue: 0.9999595284, alpha: 1)
        case 5:
            backgroundColor = #colorLiteral(red: 1, green: 0.8973084092, blue: 0.8560125232, alpha: 1)
        case 6:
            backgroundColor = #colorLiteral(red: 0.8479840159, green: 0.8594029546, blue: 0.9951685071, alpha: 1)
        case 7:
            backgroundColor = #colorLiteral(red: 0.9530633092, green: 0.879604578, blue: 0.8791741729, alpha: 1)
        default:
            backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        authorImageView.backgroundColor = backgroundColor
        
    }
    
    @objc func likeBtnTapped() {
        
        delegate?.likeBtnTapped(comment: comment)
        likesLbl.text = "\(comment.likes)"
        
    }
    
    @objc func dislikeBtnTapped() {
        
        delegate?.dislikeBtnTapped(comment: comment)
        likesLbl.text = "\(comment.likes)"
        
    }
    
    @objc func subCommentBtnTapped(sender: UIButton) {
        
        delegate?.subCommentBtnTapped(comment: comment, cell: self, commentRow: sender.tag)
        
    }
    
    @objc func deleteBtnTapped(sender: UIButton) {
        
        if let parentCell = parentCell {
            delegate?.deleteSubCommentBtnTapped(comment: comment, parentCell: parentCell, commentRow: sender.tag, cell: self)
        } else {
            delegate?.deleteCommentBtnTapped(comment: comment, commentRow: sender.tag, cell: self)
        }
        
    }
    
    @objc func commentsOutOfRangeBtnTapped(sender: UIButton) {
        
        if let parentCell = parentCell {
            delegate?.commentsOutOfRangeBtnTapped(comment: comment, parentCell: parentCell, commentRow: sender.tag)
        }
        
    }

    @objc func reportCommentBtnTapped() {
        delegate?.reportCommentBtnTapped(comment: comment, cell: self)
    }
    
    @objc func ignoreCommentSensitiveContent() {
        delegate?.ignoreCommentSensitiveContent(comment: comment, cell: self)
    }
    
    @objc func unblockComment() {
        delegate?.unblockComment(comment: comment, cell: self)
    }
    
}

extension CommentCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comment.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCommentCell") as! CommentCell
        
        cell.contentView.isUserInteractionEnabled = false
        
        if let user = Auth.auth().currentUser {
            
            if comment.comments[indexPath.row].authorUID == user.uid && comment.comments[indexPath.row].isDeleted == false {
                cell.deleteBtn.isHidden = false
            } else {
                cell.deleteBtn.isHidden = true
            }
            
        } else {
            cell.deleteBtn.isHidden = true
        }
        
        // set all data
        
        if let parentVC = self.parentTopicVC {
            cell.delegate = parentVC
            cell.parentTopicVC = parentVC
        }
        
        if let parentVC = self.parentSubCommentVC {
            cell.delegate = parentVC
            cell.parentSubCommentVC = parentVC
        }
        
        cell.parentCell = self
        cell.deleteBtn.tag = indexPath.row
        cell.subCommentBtn.tag = indexPath.row
        cell.comment = comment.comments[indexPath.row]
        cell.authorAndTimePostedLbl.text = comment.comments[indexPath.row].author + " : " + translateTimestamp(timestamp: comment.comments[indexPath.row].timestamp)
        cell.textLbl.text = comment.comments[indexPath.row].text
        cell.likesLbl.text = "\(comment.comments[indexPath.row].likes)"
        cell.setAuthorProfileImage(uid: comment.comments[indexPath.row].authorUID)
        cell.commentsOutOfRangeBtn.tag = indexPath.row
        cell.blockedUIDs = blockedUIDs
        
        var blocked: Bool = false
        cell.unblockBtn.setTitle("unblock \(cell.comment.author)?", for: .normal)
        
        for uid in blockedUIDs {
            
            if cell.comment.authorUID == uid{
                blocked = true
                break
            }
            
        }
        
        if comment.comments[indexPath.row].isDeleted == true {
            
            for view in cell.subviews {
                view.isHidden = true
            }
            
            cell.deletedLbl.isHidden = false
            cell.subTableView.isHidden = false
            cell.verticalSeperatorView.isHidden = false
            cell.horizontalSeperatorView.isHidden = false
            cell.topVertSeperatorCoverView.isHidden = false
            cell.bottomVertSeperatorCoverView.isHidden = false
            
        } else {
            
            if let user = Auth.auth().currentUser {
                
                if comment.comments[indexPath.row].authorUID == user.uid {
                    // users post
                    
                    if blocked == true {
                        for view in cell.subviews {
                            view.isHidden = true
                        }
                        cell.blockedLbl.isHidden = false
                        cell.unblockBtn.isHidden = false
                    } else {
                        for view in cell.subviews {
                            view.isHidden = false
                        }
                        cell.sensitiveContentWarningBtn.isHidden = true
                        cell.blockedLbl.isHidden = true
                        cell.unblockBtn.isHidden = true
                        cell.deletedLbl.isHidden = true
                        cell.reportBtn.isHidden = true
                        cell.commentsOutOfRangeBtn.isHidden = true
                        cell.deleteBtn.isHidden = false
                    }
                    
                } else {
                    
                    // not the users post
                    
                    if blocked == true {
                        for view in cell.subviews {
                            view.isHidden = true
                        }
                        cell.blockedLbl.isHidden = false
                        cell.unblockBtn.isHidden = false
                    } else {
                        
                        if cell.comment.isSensitive == true {
                            
                            let ignore = (UserDefaults.standard.bool(forKey: cell.comment.id + "ignoreSensitiveContent"))
                            
                            if ignore == true {
                                
                                for view in cell.subviews {
                                    view.isHidden = false
                                }
                                
                                cell.sensitiveContentWarningBtn.isHidden = true
                                cell.commentsOutOfRangeBtn.isHidden = true
                                cell.blockedLbl.isHidden = true
                                cell.unblockBtn.isHidden = true
                                cell.deletedLbl.isHidden = true
                                
                            } else {
                                
                                for view in cell.subviews {
                                    view.isHidden = true
                                }
                                
                                cell.sensitiveContentWarningBtn.isHidden = false
                                cell.horizontalSeperatorView.isHidden = false
                                cell.subTableView.isHidden = false
                                
                            }
                            
                        } else {
                            for view in cell.subviews {
                                view.isHidden = false
                            }
                            cell.sensitiveContentWarningBtn.isHidden = true
                            cell.blockedLbl.isHidden = true
                            cell.unblockBtn.isHidden = true
                            cell.deletedLbl.isHidden = true
                            cell.deleteBtn.isHidden = true
                            cell.commentsOutOfRangeBtn.isHidden = true
                        }
                        
                    }
                    
                }
                
            } else {
                
                // no user logged in
                
                if blocked == true {
                    for view in cell.subviews {
                        view.isHidden = true
                    }
                    cell.blockedLbl.isHidden = false
                    cell.unblockBtn.isHidden = false
                } else {
                    
                    if cell.comment.isSensitive == true {
                        
                        let ignore = (UserDefaults.standard.bool(forKey: cell.comment.id + "ignoreSensitiveContent"))
                        
                        if ignore == true {
                            
                            for view in cell.subviews {
                                view.isHidden = false
                            }
                            
                            cell.sensitiveContentWarningBtn.isHidden = true
                            cell.commentsOutOfRangeBtn.isHidden = true
                            cell.blockedLbl.isHidden = true
                            cell.unblockBtn.isHidden = true
                            cell.deletedLbl.isHidden = true
                            
                        } else {
                            
                            for view in cell.subviews {
                                view.isHidden = true
                            }
                            
                            cell.sensitiveContentWarningBtn.isHidden = false
                            cell.horizontalSeperatorView.isHidden = false
                            cell.subTableView.isHidden = false
                            
                        }
                        
                    } else {
                        for view in cell.subviews {
                            view.isHidden = false
                        }
                        cell.sensitiveContentWarningBtn.isHidden = true
                        cell.blockedLbl.isHidden = true
                        cell.unblockBtn.isHidden = true
                        cell.deletedLbl.isHidden = true
                        cell.deleteBtn.isHidden = true
                        cell.commentsOutOfRangeBtn.isHidden = true
                    }
                    
                }
                
            }
            
        }
        
        if comment.comments[indexPath.row].depth % 6 == 0 {
            cell.likeBtn.removeFromSuperview()
            cell.dislikeBtn.removeFromSuperview()
            cell.likesLbl.removeFromSuperview()
            cell.subCommentBtn.removeFromSuperview()
            cell.subTableView.removeFromSuperview()
            cell.horizontalSeperatorView.removeFromSuperview()
            cell.commentsOutOfRangeBtn.isHidden = false
            cell.commentsOutOfRangeBtn.anchors(top: cell.textLbl.bottomAnchor, topPad: 0, bottom: cell.bottomAnchor, bottomPad: -10, left: cell.leftAnchor, leftPad: 0, right: cell.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 20, width: 0)
        }
        
        if cell.comment.commentCount == 0 {
            
            cell.topVertSeperatorCoverView.isHidden = true
            cell.bottomVertSeperatorCoverView.isHidden = true
            
        } else {
            
        }
        
        cell.comment.comments.sort { $0.likes > $1.likes }
        cell.subTableView.reloadData()
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

protocol CommentCellDelegate : class {
    
    func likeBtnTapped(comment: Comment)
    
    func dislikeBtnTapped(comment: Comment)
    
    func subCommentBtnTapped(comment: Comment, cell: CommentCell, commentRow: Int)
    
    func deleteSubCommentBtnTapped(comment: Comment, parentCell: CommentCell, commentRow: Int, cell: CommentCell) // for sub comments
    
    func deleteCommentBtnTapped(comment: Comment, commentRow: Int, cell: CommentCell) // for direct comments of main topic or comment
    
    func commentsOutOfRangeBtnTapped(comment: Comment, parentCell: CommentCell, commentRow: Int)
    
    func reportCommentBtnTapped(comment: Comment, cell: CommentCell)
    
    func ignoreCommentSensitiveContent(comment: Comment, cell: CommentCell)
    
    func unblockComment(comment: Comment, cell: CommentCell)
    
}
