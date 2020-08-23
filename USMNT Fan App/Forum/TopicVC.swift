//
//  TopicVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 3/20/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class TopicVC: UIViewController {
    
    var topic: Topic = Topic()
    var parentVC: ForumHomeVC = ForumHomeVC()
    var topicRow: Int?
    var topicIsSaved = false
    
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
    
    let topicLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        lbl.textColor = #colorLiteral(red: 0.8058902025, green: 0.9378458858, blue: 1, alpha: 1)
        return lbl
    }()
    
    let descriptionLbl: UILabel = {
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
    
    let saveBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(saveBtnTapped), for: .touchUpInside)
        btn.setImage(UIImage(named: "SaveBtnImage"), for: .normal)
        return btn
    }()
    
    let deleteBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.addTarget(self, action: #selector(deleteAlert), for: .touchUpInside)
        btn.setImage(UIImage(named: "DeleteBtnImage"), for: .normal)
        return btn
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
        
        activityIndicator.startAnimating()
        
        topic.comments.sort { $0.likes > $1.likes }
        
        setTopicInfo()
        setupLayout()
        randomizeColor()
        
        // if this is the users post show deleteBtn
        
        if let user = Auth.auth().currentUser {
            
            if user.uid == topic.authorUID {
                deleteBtn.isHidden = false
                saveBtn.isHidden = true
            }
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if userHasChanged == true {
            
            if let user = Auth.auth().currentUser {
                
                if user.uid != topic.authorUID {
                    deleteBtn.isHidden = true
                    saveBtn.isHidden = false
                } else {
                    deleteBtn.isHidden = false
                    saveBtn.isHidden = true
                }
                
            } else {
                
                deleteBtn.isHidden = true
                saveBtn.isHidden = false
                
            }
            
            userHasChanged = false
            
        }
        
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
        view.addSubview(topicLbl)
        view.addSubview(descriptionLbl)
        view.addSubview(commentBtn)
        view.addSubview(saveBtn)
        view.addSubview(seperatorView)
        view.addSubview(tableView)
        view.addSubview(deleteBtn)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.addSubview(activityIndicator)
        
    }
    
    func applyAnchors() {
        
        backBtn.anchors(top: view.topAnchor, topPad: 60, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        authorImageView.anchors(top: backBtn.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 20, width: 20)
        
        authorAndTimePostedLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: authorImageView.rightAnchor, leftPad: 5, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: authorImageView.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        topicLbl.anchors(top: authorImageView.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 20, right: view.rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        descriptionLbl.anchors(top: topicLbl.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 20, right: view.rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        commentBtn.anchors(top: descriptionLbl.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 20)
        
        saveBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: commentBtn.rightAnchor, leftPad: 5, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: commentBtn.centerYAnchor, centerYPad: 0, height: 0, width: 20)
        
        seperatorView.anchors(top: commentBtn.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 20, right: view.rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
        tableView.anchors(top: seperatorView.bottomAnchor, topPad: 10, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)! - 10, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        deleteBtn.anchors(top: nil, topPad: 5, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: authorImageView.centerYAnchor, centerYPad: 0, height: 20, width: 20)

        activityIndicatorView.anchors(top: seperatorView.bottomAnchor, topPad: 0, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        activityIndicator.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: activityIndicatorView.centerXAnchor, centerXPad: 0, centerY: activityIndicatorView.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
    }
    
    @objc func requestData() {
        
        topic.dbref.getDocument { (snap, err) in
            
            if let snap = snap {
                
                let data = snap.data()!
                let timestamp = data["timestamp"] as! Double
                let topic = data["topic"] as! String
                let author = data["author"] as! String
                let authorUID = data["authorUID"] as! String
                let text = data["text"] as! String
                let id = snap.documentID
                let dbref = Firestore.firestore().collection("Topics").document(id)
                let commentCount = data["commentCount"] as! Int
                self.topic = (Topic(topic: topic, timestamp: timestamp, author: author, authorUID: authorUID, text: text, id: id, dbref: dbref, commentCount: commentCount))
                
            }
            
        }
        
        let deadline = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.topic.comments.sort { $0.likes > $1.likes }
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
        
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
    
    func setTopicInfo() {
        
        setAuthorProfileImage()
        authorAndTimePostedLbl.text = topic.author + " : " + translateTimestamp(timestamp: topic.timestamp)
        topicLbl.text = topic.topic
        descriptionLbl.text = topic.text
        
        // check if user has saved this topic
        
        if let user = Auth.auth().currentUser {
            
            Firestore.firestore().collection("Users").document(user.uid).collection("SavedTopics").whereField("docID", isEqualTo: topic.id).getDocuments { (snap, err) in
                
                guard err == nil else {
                    print(err?.localizedDescription ?? "")
                    return
                }
                
                if let snap = snap {
                    
                    if snap.documents.count > 0 {
                        self.topicIsSaved = true
                        self.saveBtn.setImage(UIImage(named: "Check"), for: .normal)
                    }
                    
                }
                
            }
            
        } else {
            
            // topic cannot and is not saved
            
        }
        
    }
    
    func setAuthorProfileImage() {
        
        let storageRef = Storage.storage().reference(forURL: "gs://usmnt-fan-app.appspot.com").child("profile_image").child(topic.authorUID)
        
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
            vc.parentIsComment = false
            vc.parentTopic = self.topic
            vc.parentTopicVC = self
            present(vc, animated: true, completion: nil)
            
        } else {
            
            let vc = AuthVC()
            present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func saveBtnTapped() {
        
        if let user = Auth.auth().currentUser {
            
            if topicIsSaved == false {
                
                // set as saved in firestore for user
                
                Firestore.firestore().collection("Users").document(user.uid).collection("SavedTopics").addDocument(data: ["docID":topic.id])
                
                // add to savers collection of topic
                
                topic.dbref.collection("Savers").addDocument(data: ["uid":user.uid])
                
                saveBtn.setImage(UIImage(named: "Check"), for: .normal)
                topicIsSaved = !topicIsSaved
                
            } else {
                
                Firestore.firestore().collection("Users").document(user.uid).collection("SavedTopics").whereField("docID", isEqualTo: topic.id).getDocuments { (snap, err) in
                    
                    guard err == nil else {
                        print(err?.localizedDescription ?? "")
                        return
                    }
                    
                    if let snap = snap {
                        
                        for document in snap.documents {
                            document.reference.delete()
                        }
                        
                    }
                    
                }
                
                saveBtn.setImage(UIImage(named: "SaveBtnImage"), for: .normal)
                topicIsSaved = !topicIsSaved
                
            }
            
            
            
        } else {
            
            let vc = AuthVC()
            present(vc, animated: true, completion: nil)
            
        }
        
        // change btn color or something to show saved completion
        
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteAlert() {
        
        let alert = UIAlertController(title: "just checking", message: "are you sure you want to delete this topic?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            let docID = self.topic.id
            
            // delete from User's UserTopics collection
            
            Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).collection("UserTopics").whereField("docID", isEqualTo: docID).getDocuments { (snap, err) in
                
                guard err == nil else {
                    print(err?.localizedDescription ?? "")
                    return
                }
                
                if let snap = snap {
                    
                    for document in snap.documents { document.reference.delete() }
                    
                }
                
            }
            
            // delete from saver's SavedTopics collection
            
            self.topic.dbref.collection("Savers").getDocuments { (snap1, err) in
                
                guard err == nil else {
                    print(err?.localizedDescription ?? "")
                    return
                }
                
                if let snap = snap1 {
                    
                    for document in snap.documents {
                        
                        let data = document.data()
                        let voterUID = data["uid"] as! String
                        
                        Firestore.firestore().collection("Users").document(voterUID).collection("SavedTopics").whereField("docID", isEqualTo: docID).getDocuments { (snap2, err) in
                            
                            guard err == nil else {
                                print(err?.localizedDescription ?? "")
                                return
                            }
                            
                            if let snap = snap2 {
                                for document in snap.documents { document.reference.delete() }
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
            self.parentVC.naturalTopics = self.parentVC.naturalTopics.filter({ (topic) -> Bool in
                return topic.id != self.topic.id
            })
            
            self.parentVC.allTopics = self.parentVC.allTopics.filter({ (topic) -> Bool in
                return topic.id != self.topic.id
            })
            
            if let row = self.topicRow {
                self.parentVC.topicsDisplayed.remove(at: row)
                self.parentVC.tableView.reloadData()
            }
            
            self.topic.dbref.delete()
            self.navigationController?.popViewController(animated: true)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
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
                self.topic.comments.remove(at: commentRow)
                self.tableView.deleteRows(at: [IndexPath(row: commentRow, section: 0)], with: .automatic)
                self.tableView.reloadData()
                
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}

extension TopicVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topic.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentCell
        
        if let user = Auth.auth().currentUser {
            
            if topic.comments[indexPath.row].authorUID == user.uid && topic.comments[indexPath.row].isDeleted == false {
                cell.deleteBtn.isHidden = false
            } else {
                cell.deleteBtn.isHidden = true
            }
            
        } else {
            cell.deleteBtn.isHidden = true
        }
        
        // set all data
        
        cell.delegate = self
        cell.parentTopicVC = self
        cell.parentCell = nil
        cell.deleteBtn.tag = indexPath.row
        cell.subCommentBtn.tag = indexPath.row
        cell.comment = topic.comments[indexPath.row]
        cell.authorAndTimePostedLbl.text = topic.comments[indexPath.row].author + " : " + translateTimestamp(timestamp: topic.comments[indexPath.row].timestamp)
        cell.textLbl.text = topic.comments[indexPath.row].text
        cell.likesLbl.text = "\(topic.comments[indexPath.row].likes)"
        cell.setAuthorProfileImage(uid: topic.comments[indexPath.row].authorUID)
        cell.commentsOutOfRangeBtn.tag = indexPath.row
        
        if topic.comments[indexPath.row].isDeleted == true {
            
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

extension TopicVC: CommentCellDelegate {
    
    func commentsOutOfRangeBtnTapped(comment: Comment, parentCell: CommentCell, commentRow: Int) {
        
        let vc = SubCommentVC()
        vc.comment = comment
        vc.commentRow = commentRow
        vc.topic = self.topic
        vc.parentCell = parentCell
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func subCommentBtnTapped(comment: Comment, cell: CommentCell, commentRow: Int) {
        
        if Auth.auth().currentUser != nil {
            
            let vc = AddCommentVC()
            vc.parentIsComment = true
            vc.parentComment = comment
            vc.parentCell = cell
            vc.parentTopicVC = self
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
            
            let vc = AuthVC()
            present(vc, animated: true, completion: nil)
            
        }
        
        
    }
    
    func dislikeBtnTapped(comment: Comment) {
        
        if let user = Auth.auth().currentUser {
            
            comment.dislike(user: user)
            
        } else {
            
            let vc = AuthVC()
            present(vc, animated: true, completion: nil)
            
        }
        
    }
    
}
