//
//  SubCommentVC.swift
//  USMNT Fan App
//
//  Created by Leon Djusberg on 7/31/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class SubCommentVC: UIViewController {
    
    var comment: Comment = Comment()
    var parentCell: CommentCell = CommentCell()
    var topic: Topic = Topic()
    var commentRow: Int?
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.register(CommentCell.self, forCellReuseIdentifier: "commentCell")
        return tv
    }()
    
    let backBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        btn.setImage(UIImage(named: "BackArrow"), for: .normal)
        return btn
    }()
    
    let textLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Book", size: 16)
        lbl.textColor = .white
        return lbl
    }()
    
    let authorAndTimePostedLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 14)
        lbl.textColor = .gray
        lbl.textAlignment = .left
        return lbl
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
        btn.addTarget(self, action: #selector(like), for: .touchUpInside)
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
        btn.addTarget(self, action: #selector(dislike), for: .touchUpInside)
        return btn
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.7053028941, blue: 0.7190689445, alpha: 1)
        return view
    }()
    
    let commentBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(commentBtnTapped), for: .touchUpInside)
        btn.setImage(UIImage(named: "CommentBtnImage"), for: .normal)
        return btn
    }()
    
    let deletedLbl: UILabel = {
        let lbl = UILabel()
        lbl.isHidden = true
        lbl.textColor = .white
        lbl.text = "this comment has been deleted"
        lbl.font = UIFont(name: "Avenir-Book", size: 16)
        return lbl
    }()
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .darkGray
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()
    
    let activityIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .whiteLarge
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refresher
        
        comment.comments.sort { $0.likes > $1.likes }
        
        setTopicInfo()
        setupLayout()
        
        tableView.reloadData()
        activityIndicator.startAnimating()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        tableView.reloadData()
        
        activityIndicatorView.isHidden = true
        self.activityIndicator.stopAnimating()
            
    }
    
    func setupLayout() {
        
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(backBtn)
        view.addSubview(authorImageView)
        view.addSubview(authorAndTimePostedLbl)
        view.addSubview(textLbl)
        view.addSubview(likeBtn)
        view.addSubview(likesLbl)
        view.addSubview(dislikeBtn)
        view.addSubview(commentBtn)
        view.addSubview(seperatorView)
        view.addSubview(tableView)
        view.addSubview(deletedLbl)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.addSubview(activityIndicator)
        
    }
    
    func applyAnchors() {
        
        backBtn.anchors(top: view.topAnchor, topPad: 50, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        authorImageView.anchors(top: backBtn.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 20, width: 20)
        
        authorAndTimePostedLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: authorImageView.rightAnchor, leftPad: 5, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: authorImageView.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        textLbl.anchors(top: authorImageView.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 20, right: view.rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        likeBtn.anchors(top: textLbl.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 30, width: 30)
        
        likesLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: likeBtn.rightAnchor, leftPad: 3, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: likeBtn.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        dislikeBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: likesLbl.rightAnchor, leftPad: 3, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: likeBtn.centerYAnchor, centerYPad: 0, height: 30, width: 30)
        
        commentBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: dislikeBtn.rightAnchor, leftPad: 6, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: likeBtn.centerYAnchor, centerYPad: 0, height: 30, width: 30)
        
        seperatorView.anchors(top: commentBtn.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 20, right: view.rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
        tableView.anchors(top: seperatorView.bottomAnchor, topPad: 10, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)! - 10, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)

        deletedLbl.anchors(top: textLbl.topAnchor, topPad: 0, bottom: textLbl.bottomAnchor, bottomPad: 0, left: textLbl.leftAnchor, leftPad: 0, right: textLbl.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        activityIndicatorView.anchors(top: seperatorView.bottomAnchor, topPad: 0, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        activityIndicator.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: activityIndicatorView.centerXAnchor, centerXPad: 0, centerY: activityIndicatorView.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
    }
    
    @objc func like() {
        
        if let user = Auth.auth().currentUser {
            
            comment.like(user: user)
            
        } else {
            AlertController.showAlert(self, title: "Error", message: "must be logged in to like comments")
        }
        
        likesLbl.text = "\(comment.likes)"
        
    }
    
    @objc func dislike() {
        
        if let user = Auth.auth().currentUser {
            
            comment.dislike(user: user)
            
        } else {
            AlertController.showAlert(self, title: "Error", message: "must be logged in to dislike comments")
        }
        
        likesLbl.text = "\(comment.likes)"
        
    }
    
    @objc func requestData() {
        
        topic.dbref.getDocument { (snap, err) in
            
            let data = snap!.data()!
            let timestamp = data["timestamp"] as! Double
            let topic = data["topic"] as! String
            let author = data["author"] as! String
            let authorUID = data["authorUID"] as! String
            let text = data["text"] as! String
            let id = snap!.documentID
            let dbref = Firestore.firestore().collection("Topics").document(id)
            let commentCount = data["commentCount"] as! Int
            self.topic = (Topic(topic: topic, timestamp: timestamp, author: author, authorUID: authorUID, text: text, id: id, dbref: dbref, commentCount: commentCount))
            
        }
        
        let deadline = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.comment.comments.sort { $0.likes > $1.likes }
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
        
    }
    
    func setTopicInfo() {
        
        setAuthorProfileImage()
        authorAndTimePostedLbl.text = comment.author + " : " + translateTimestamp(timestamp: comment.timestamp)
        textLbl.text = comment.text
        likesLbl.text = "\(comment.likes)"
        
    }
    
    func setAuthorProfileImage() {
        
        let storageRef = Storage.storage().reference(forURL: "gs://usmnt-fan-app.appspot.com").child("profile_image").child(comment.authorUID)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            
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
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let dateString = formatter.string(from: date)
        
        return dateString
        
    }
    
    @objc func commentBtnTapped() {
        
        if Auth.auth().currentUser != nil {
            
            let vc = AddCommentVC()
            vc.parentIsComment = true
            vc.parentComment = self.comment
            vc.parentSubCommentVC = self
            present(vc, animated: true, completion: nil)
            
        } else {
            
            let vc = AuthVC()
            present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    func deleteSubCommentAlert(comment: Comment, parentCell: CommentCell, commentRow: Int, cell: CommentCell) {
        
        let alert = UIAlertController(title: "just checking", message: "are you sure you want to delete this comment?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            // if comment has any subcomments, create a single view that indicates that this post is deleted, but dont remove from firestore
            
            if comment.comments.count > 0 {
                
                for view in cell.subviews {
                    view.isHidden = true
                }
                
                cell.deletedLbl.isHidden = false
                cell.subTableView.isHidden = false
                cell.verticalSeperatorView.isHidden = false
                cell.horizontalSeperatorView.isHidden = false
                cell.topVertSeperatorCoverView.isHidden = false
                cell.bottomVertSeperatorCoverView.isHidden = false
                
                // set data in firestore
                
                comment.dbref.updateData(["isDeleted" : true])
                comment.isDeleted = true
                
            } else {
                
                // comment has no comments, delete from firebase and from parentCell tv
                
                comment.dbref.delete()
                parentCell.comment.comments.remove(at: commentRow)
                parentCell.subTableView.deleteRows(at: [IndexPath(row: commentRow, section: 0)], with: .automatic)
                self.tableView.reloadData()
                
                // update parent comments comment count
                
                parentCell.comment.dbref.getDocument { (snap, err) in
                    
                    guard err == nil else {
                        print(err?.localizedDescription ?? "")
                        return
                    }
                    
                    if let document = snap {
                        
                        let data = document.data()
                        let commentCount = data!["commentCount"] as! Int
                        document.reference.updateData(["commentCount" : commentCount - 1])
                        
                    }
                    
                    
                }
                
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func deleteCommentAlert(comment: Comment, commentRow: Int, cell: CommentCell) {
        
        let alert = UIAlertController(title: "just checking", message: "are you sure you want to delete this comment?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            // if comment has any subcomments, create a single view that indicates that this post is deleted, but dont remove from firestore
            
            if comment.comments.count > 0 {
                
                for view in cell.subviews {
                    view.isHidden = true
                }
                
                cell.deletedLbl.isHidden = false
                cell.subTableView.isHidden = false
                cell.verticalSeperatorView.isHidden = false
                cell.horizontalSeperatorView.isHidden = false
                cell.topVertSeperatorCoverView.isHidden = false
                cell.bottomVertSeperatorCoverView.isHidden = false
                
                // set data in firestore
                
                comment.dbref.updateData(["isDeleted" : true])
                comment.isDeleted = true
                
            } else {
                
                // comment has no comments, delete from firebase and from parentVC tv
                
                comment.dbref.delete()
                self.comment.comments.remove(at: commentRow)
                self.tableView.deleteRows(at: [IndexPath(row: commentRow, section: 0)], with: .automatic)
                self.tableView.reloadData()
                
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

}

extension SubCommentVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentCell
        
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
        
        cell.delegate = self
        cell.parentSubCommentVC = self
        cell.parentCell = nil
        cell.deleteBtn.tag = indexPath.row
        cell.subCommentBtn.tag = indexPath.row
        cell.comment = comment.comments[indexPath.row]
        cell.authorAndTimePostedLbl.text = comment.comments[indexPath.row].author + " : " + translateTimestamp(timestamp: comment.comments[indexPath.row].timestamp)
        cell.textLbl.text = comment.comments[indexPath.row].text
        cell.likesLbl.text = "\(comment.comments[indexPath.row].likes)"
        cell.setAuthorProfileImage(uid: comment.comments[indexPath.row].authorUID)
        cell.commentsOutOfRangeBtn.tag = indexPath.row
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 113
    }
    
}

extension SubCommentVC: CommentCellDelegate {
    
    func commentsOutOfRangeBtnTapped(comment: Comment, parentCell: CommentCell, commentRow: Int) {
        
        let vc = SubCommentVC()
        vc.comment = comment
        vc.commentRow = commentRow
        vc.parentCell = parentCell
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func subCommentBtnTapped(comment: Comment, cell: CommentCell, commentRow: Int) {
        
        if Auth.auth().currentUser != nil {
            
            let vc = AddCommentVC()
            vc.parentIsComment = true
            vc.parentComment = comment
            vc.parentCell = cell
            vc.parentSubCommentVC = self
            present(vc, animated: true, completion: nil)
            
        } else {
            
            let vc = AuthVC()
            present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    func deleteSubCommentBtnTapped(comment: Comment, parentCell: CommentCell, commentRow: Int, cell: CommentCell) {
        
        deleteSubCommentAlert(comment: comment, parentCell: parentCell, commentRow: commentRow, cell: cell)
        
    }
    
    func deleteCommentBtnTapped(comment: Comment, commentRow: Int, cell: CommentCell) {
        
        deleteCommentAlert(comment: comment, commentRow: commentRow, cell: cell)
        
    }
    
    
    func likeBtnTapped(comment: Comment) {
        
        if let user = Auth.auth().currentUser {
            
            comment.like(user: user)
            
        } else {
            AlertController.showAlert(self, title: "Error", message: "must be logged in to like comments")
        }
        
        
    }
    
    func dislikeBtnTapped(comment: Comment) {
        
        if let user = Auth.auth().currentUser {
            
            comment.dislike(user: user)
            
        } else {
            AlertController.showAlert(self, title: "Error", message: "must be logged in to dislike comments")
        }
        
    }
    
}
