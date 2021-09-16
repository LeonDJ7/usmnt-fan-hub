//
//  SubCommentVC.swift
//  USMNT Fan App
//
//  Created by Leon Djusberg on 7/31/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class SubCommentVC: UIViewController {
    
    var comment: Comment = Comment()
    var parentCell: CommentCell = CommentCell()
    var topic: Topic = Topic()
    var commentRow: Int?
    
    let scrollView = UIScrollView()
    let scrollViewContainer = UIView()
    
    let tableView: CustomTableView = {
        let tv = CustomTableView()
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
    
    let sensitiveContentWarningBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setTitle("view sensitive content", for: .normal)
        btn.titleLabel!.textColor = .white
        btn.titleLabel!.font = UIFont(name: "Avenir-Book", size: 16)
        return btn
    }()
    
    let sensitiveContentUnderline: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .lightGray
        return view
    }()
    
    let blockedLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "this user is blocked"
        lbl.font = UIFont(name: "Avenir-Book", size: 16)
        lbl.textColor = .white
        lbl.isHidden = true
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
    
    let unblockUnderline: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .lightGray
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.contentSize.height = self.view.frame.size.height * 3
        scrollView.contentSize.width = self.view.frame.size.width
        
        tableView.delegate = self
        tableView.dataSource = self
        
        comment.comments.sort { $0.likes > $1.likes }
        
        setMainCommentInfo()
        setupLayout()
        
        tableView.reloadData()
        activityIndicator.startAnimating()
        
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size

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
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addSubview(authorImageView)
        scrollViewContainer.addSubview(authorAndTimePostedLbl)
        scrollViewContainer.addSubview(textLbl)
        scrollViewContainer.addSubview(likeBtn)
        scrollViewContainer.addSubview(likesLbl)
        scrollViewContainer.addSubview(dislikeBtn)
        scrollViewContainer.addSubview(commentBtn)
        scrollViewContainer.addSubview(seperatorView)
        scrollViewContainer.addSubview(tableView)
        scrollViewContainer.addSubview(deletedLbl)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.addSubview(activityIndicator)
        scrollViewContainer.addSubview(sensitiveContentWarningBtn)
        scrollViewContainer.addSubview(sensitiveContentUnderline)
        scrollViewContainer.addSubview(blockedLbl)
        scrollViewContainer.addSubview(unblockBtn)
        scrollViewContainer.addSubview(unblockUnderline)
        
    }
    
    func applyAnchors() {
        
        if #available(iOS 11.0, *) {
            backBtn.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        } else {
            backBtn.anchors(top: view.topAnchor, topPad: 50, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
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
        
        authorImageView.anchors(top: scrollViewContainer.topAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: scrollView.leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 20, width: 20)
        
        authorAndTimePostedLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: authorImageView.rightAnchor, leftPad: 5, right: scrollView.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: authorImageView.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        textLbl.anchors(top: authorImageView.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: scrollView.leftAnchor, leftPad: 20, right: scrollView.rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        likeBtn.anchors(top: textLbl.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: scrollView.leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 30, width: 30)
        
        likesLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: likeBtn.rightAnchor, leftPad: 3, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: likeBtn.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        dislikeBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: likesLbl.rightAnchor, leftPad: 3, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: likeBtn.centerYAnchor, centerYPad: 0, height: 30, width: 30)
        
        commentBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: dislikeBtn.rightAnchor, leftPad: 6, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: likeBtn.centerYAnchor, centerYPad: 0, height: 30, width: 30)
        
        seperatorView.anchors(top: commentBtn.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: scrollView.leftAnchor, leftPad: 20, right: view.rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
        tableView.anchors(top: seperatorView.bottomAnchor, topPad: 10, bottom: scrollView.bottomAnchor, bottomPad: 0, left: scrollView.leftAnchor, leftPad: 0, right: scrollView.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)

        deletedLbl.anchors(top: textLbl.topAnchor, topPad: 0, bottom: textLbl.bottomAnchor, bottomPad: 0, left: textLbl.leftAnchor, leftPad: 0, right: textLbl.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        activityIndicatorView.anchors(top: seperatorView.bottomAnchor, topPad: 0, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        activityIndicator.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: activityIndicatorView.centerXAnchor, centerXPad: 0, centerY: activityIndicatorView.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        sensitiveContentWarningBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: textLbl.centerXAnchor, centerXPad: 0, centerY: textLbl.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        sensitiveContentUnderline.anchors(top: sensitiveContentWarningBtn.bottomAnchor, topPad: -3, bottom: nil, bottomPad: 0, left: sensitiveContentWarningBtn.leftAnchor, leftPad: 0, right: sensitiveContentWarningBtn.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
        blockedLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: textLbl.centerXAnchor, centerXPad: 0, centerY: textLbl.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        unblockBtn.anchors(top: blockedLbl.bottomAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: scrollView.leftAnchor, leftPad: 0, right: scrollView.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        unblockUnderline.anchors(top: unblockBtn.bottomAnchor, topPad: -3, bottom: nil, bottomPad: 0, left: unblockBtn.leftAnchor, leftPad: 0, right: unblockBtn.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
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
    
    func setMainCommentInfo() {
        
        var blocked: Bool = false
        
        for uid in blockedUIDs {
            
            if comment.authorUID == uid{
                blocked = true
                break
            }
            
        }
        
        if comment.isSensitive == true && UserDefaults.standard.bool(forKey: comment.id + "ignoreSensitiveContent") != true {
            
            for view in view.subviews {
                view.isHidden = true
            }
            
            tableView.isHidden = false
            activityIndicator.isHidden = false
            activityIndicatorView.isHidden = false
            backBtn.isHidden = false
            sensitiveContentWarningBtn.isHidden = false
            sensitiveContentUnderline.isHidden = false
            
        } else if blocked == true {
            
            for view in view.subviews {
                view.isHidden = true
            }
            
            tableView.isHidden = false
            activityIndicator.isHidden = false
            activityIndicatorView.isHidden = false
            backBtn.isHidden = false
            blockedLbl.isHidden = false
            unblockBtn.isHidden = false
            unblockUnderline.isHidden = false
            unblockBtn.setTitle("unblock \(comment.author)?", for: .normal)
            
        } else {
            
            setAuthorProfileImage()
            authorAndTimePostedLbl.text = comment.author + " : " + translateTimestamp(timestamp: comment.timestamp)
            textLbl.text = comment.text
            likesLbl.text = "\(comment.likes)"
            
        }
        
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
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateString = formatter.string(from: date)
        
        return dateString
        
    }
    
    @objc func commentBtnTapped() {
        
        if Auth.auth().currentUser != nil {
            
            let vc = AddCommentVC()
            vc.parentIsComment = true
            vc.parentComment = self.comment
            vc.parentSubCommentVC = self
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let vc = AuthVC()
            present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func deleteSubCommentAlert(comment: Comment, parentCell: CommentCell, commentRow: Int, cell: CommentCell) {
        
        guard let user = Auth.auth().currentUser else {
            tableView.reloadData()
            return
        }
        
        guard user.uid == comment.authorUID else {
            tableView.reloadData()
            return
        }
        
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
        
        guard let user = Auth.auth().currentUser else {
            tableView.reloadData()
            return
        }
        
        guard user.uid == comment.authorUID else {
            tableView.reloadData()
            return
        }
        
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
    
    func reportCommentAlert(comment: Comment, cell: CommentCell) {
        
        let alert = UIAlertController(title: "hmmm", message: "what would you like to do", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "block user", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            // add blocked user to user's blocked list in firestore
            
            guard let user = Auth.auth().currentUser else {
                return
            }
            
            guard user.uid != comment.authorUID else {
                return
            }
            
            Firestore.firestore().collection("Users").document(user.uid).collection("Blocked").document(comment.authorUID).setData(["blocked":true])
            
            Firestore.firestore().collection("Users").document(user.uid).collection("Blocked").document(comment.authorUID).getDocument { (snap, err) in
                
                guard err == nil else {
                    print(err?.localizedDescription ?? "")
                    return
                }
                
                blockedUIDs.append(comment.authorUID)
                
                if comment.authorUID == self.topic.authorUID {
                    // author of comment is same as topic author, so pop back to forumHome
                    self.navigationController?.popViewController(animated: true)
                } else {
                    // just normally reload tableview
                    self.tableView.reloadData()
                }
                
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "report sensitive content", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            UserDefaults.standard.set(false, forKey: comment.id + "ignoreSensitiveContent")
            // check to make sure this device hasnt already reported
            
            let deviceHasReported = UserDefaults.standard.bool(forKey: comment.id + "has reported")
            
            if deviceHasReported == true {
                AlertController.showAlert(self, title: "Error", message: "you have already reported this post")
                return
            }
            
            // report to firebase and send email to myself
            
            let data: [String : Any] = [
                "topic" : comment.topic,
                "depth" : comment.depth,
                "docID" : comment.id,
                "authorUID" : comment.authorUID,
                "text" : comment.text
            ]
            
            Firestore.firestore().collection("Sensitive Content Reports").document("\(Date().timeIntervalSince1970)").setData(data)
            
            self.sendEmail(text: comment.text)
            UserDefaults.standard.set(true, forKey: comment.id + "has reported")
            
        }))
        
        alert.addAction(UIAlertAction(title: "report harassment", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            // report to firebase and send an email to myself
            
            let data: [String : Any] = [
                "topic" : comment.topic,
                "depth" : comment.depth,
                "docID" : comment.id,
                "authorUID" : comment.authorUID,
                "text" : comment.text
            ]
            
            Firestore.firestore().collection("Harrasment Reports").addDocument(data: data)
            
            self.sendEmail(text: comment.text)
            
        }))
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        
        self.present(alert, animated: true, completion: nil)
        
        
    }

}

extension SubCommentVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentCell
        
        // set all data
        cell.contentView.isUserInteractionEnabled = false
        
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
        
        if cell.comment.commentCount == 0 {
            
            cell.topVertSeperatorCoverView.isHidden = true
            cell.bottomVertSeperatorCoverView.isHidden = true
            
        } else {
            
        }
        
        
        
        if blocked == true {
            for view in cell.subviews {
                view.isHidden = true
            }
            cell.blockedLbl.isHidden = false
            cell.unblockBtn.isHidden = false
        } else {
            
            if cell.reportBtn.isHidden {
                
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
    
    func reportCommentBtnTapped(comment: Comment, cell: CommentCell) {
        
        reportCommentAlert(comment: comment, cell: cell)
        
    }
    
    func ignoreCommentSensitiveContent(comment: Comment, cell: CommentCell) {
        UserDefaults.standard.set(true, forKey: comment.id + "ignoreSensitiveContent")
        tableView.reloadData()
    }
    
    func unblockComment(comment: Comment, cell: CommentCell) {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        Firestore.firestore().collection("Users").document(user.uid).collection("Blocked").document(comment.authorUID).getDocument { (snap, err) in
            
            guard err == nil else {
                print(err?.localizedDescription ?? "")
                return
            }
            
            guard let snap = snap else {
                return
            }
            
            snap.reference.delete()
            blockedUIDs = blockedUIDs.filter { $0 != comment.authorUID }
            self.tableView.reloadData()
            
        }
        
    }
    
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
            navigationController?.pushViewController(vc, animated: true)
            
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

extension SubCommentVC: MFMailComposeViewControllerDelegate {
    
    func sendEmail(text: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["leondjust@me.com"])
            mail.setMessageBody("new harrasment report \ntext: \(text)", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
