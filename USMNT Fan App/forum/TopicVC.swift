//
//  TopicVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 3/20/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class TopicVC: UIViewController {
    
    var topic: Topic = Topic()
    var parentVC: ForumHomeVC = ForumHomeVC()
    var topicRow: Int?
    var topicIsSaved = false
    
    let scrollView = UIScrollView()
    let scrollViewContainer = UIView()
    
    let tableView: CustomTableView = {
        let tv = CustomTableView()
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.isScrollEnabled = false
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
    
    let reportBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setImage(UIImage(named: "ReportBtnImage"), for: .normal)
        btn.addTarget(self, action: #selector(reportAlert), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        activityIndicator.startAnimating()
        
        topic.comments.sort { $0.likes > $1.likes }
        
        setTopicInfo()
        setupLayout()
        randomizeColor()
        
        // if this is the users post show some btns
        
        if let user = Auth.auth().currentUser {
            
            if user.uid == topic.authorUID {
                deleteBtn.isHidden = false
                saveBtn.isHidden = true
            } else {
                reportBtn.isHidden = false
            }
            
        } else {
            reportBtn.isHidden = false
        }
        
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if userHasChanged == true {
            userHasChanged = false
            if Auth.auth().currentUser?.uid == topic.authorUID {
                deleteBtn.isHidden = false
                reportBtn.isHidden = true
            } else {
                deleteBtn.isHidden = true
                reportBtn.isHidden = false
            }
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
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addSubview(authorImageView)
        scrollViewContainer.addSubview(authorAndTimePostedLbl)
        scrollViewContainer.addSubview(topicLbl)
        scrollViewContainer.addSubview(descriptionLbl)
        scrollViewContainer.addSubview(commentBtn)
        scrollViewContainer.addSubview(saveBtn)
        scrollViewContainer.addSubview(seperatorView)
        scrollViewContainer.addSubview(tableView)
        scrollViewContainer.addSubview(deleteBtn)
        scrollViewContainer.addSubview(reportBtn)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.addSubview(activityIndicator)
        
    }
    
    func applyAnchors() {
        
        if #available(iOS 11.0, *) {
            backBtn.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
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
        
        authorImageView.anchors(top: scrollViewContainer.topAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: scrollViewContainer.leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 20, width: 20)
        
        authorAndTimePostedLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: authorImageView.rightAnchor, leftPad: 5, right: scrollViewContainer.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: authorImageView.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        topicLbl.anchors(top: authorImageView.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: scrollViewContainer.leftAnchor, leftPad: 20, right: scrollViewContainer.rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        descriptionLbl.anchors(top: topicLbl.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: scrollViewContainer.leftAnchor, leftPad: 20, right: scrollViewContainer.rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        commentBtn.anchors(top: descriptionLbl.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: scrollViewContainer.leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 20)
        
        saveBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: commentBtn.rightAnchor, leftPad: 5, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: commentBtn.centerYAnchor, centerYPad: 0, height: 0, width: 20)
        
        seperatorView.anchors(top: commentBtn.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: scrollViewContainer.leftAnchor, leftPad: 20, right: scrollViewContainer.rightAnchor, rightPad: -20, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 0)
        
        tableView.anchors(top: seperatorView.bottomAnchor, topPad: 10, bottom: scrollViewContainer.bottomAnchor, bottomPad: 0, left: scrollViewContainer.leftAnchor, leftPad: 0, right: scrollViewContainer.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        deleteBtn.anchors(top: nil, topPad: 5, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: scrollViewContainer.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: authorImageView.centerYAnchor, centerYPad: 0, height: 20, width: 20)
        
        reportBtn.anchors(top: nil, topPad: 5, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: scrollViewContainer.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: authorImageView.centerYAnchor, centerYPad: 0, height: 20, width: 20)

        activityIndicatorView.anchors(top: seperatorView.bottomAnchor, topPad: 0, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        activityIndicator.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: activityIndicatorView.centerXAnchor, centerXPad: 0, centerY: activityIndicatorView.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
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
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateString = formatter.string(from: date)
        
        return dateString
        
    }
    
    @objc func commentBtnTapped() {
        
        if Auth.auth().currentUser != nil {
            
            let vc = AddCommentVC()
            vc.parentIsComment = false
            vc.parentTopic = self.topic
            vc.parentTopicVC = self
            navigationController?.pushViewController(vc, animated: true)
            
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
    
    @objc func reportAlert() {
        
        let alert = UIAlertController(title: "hmmm", message: "what would you like to do", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "block user", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            // add blocked user to user's blocked list in firestore
            
            guard let user = Auth.auth().currentUser else {
                AlertController.showAlert(self, title: "Error", message: "must be logged in to block users")
                return
            }
            
            guard user.uid != self.topic.authorUID else {
                return
            }
            
            Firestore.firestore().collection("Users").document(user.uid).collection("Blocked").document(self.topic.authorUID).setData(["blocked":true])
            
            Firestore.firestore().collection("Users").document(user.uid).collection("Blocked").document(self.topic.authorUID).getDocument { (snap, err) in
                
                guard err == nil else {
                    print(err?.localizedDescription ?? "")
                    return
                }
                
                blockedUIDs.append(self.topic.authorUID)
                
            }
            
            // send user back to forum home
            
            self.parentVC.tableView.reloadData()
            self.navigationController?.popViewController(animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "report sensitive content", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            UserDefaults.standard.set(false, forKey: self.topic.id + "ignoreSensitiveContent")
            
            // check to make sure this device hasnt already reported
            
            let deviceHasReported = UserDefaults.standard.bool(forKey: self.topic.id + "has reported")
            
            if deviceHasReported == true {
                AlertController.showAlert(self, title: "Error", message: "you have already reported this post")
                return
            }
            
            // report to firebase and send email to myself
            
            let data: [String : Any] = [
                "docID" : self.topic.id,
                "authorUID" : self.topic.authorUID,
                "topic" : self.topic.text
            ]
            
            Firestore.firestore().collection("Sensitive Content Reports").document("\(Date().timeIntervalSince1970)").setData(data)
            
            self.sendEmail(text: self.topic.text)
            UserDefaults.standard.set(true, forKey: self.topic.id + "has reported")
            
        }))
        
        alert.addAction(UIAlertAction(title: "report harassment", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            // report to firebase and send an email to myself
            
            let data: [String : Any] = [
                "topic" : self.topic.topic,
                "docID" : self.topic.id,
                "authorUID" : self.topic.authorUID,
                "text" : self.topic.text
            ]
            
            Firestore.firestore().collection("Harrasment Reports").addDocument(data: data)
            
            self.sendEmail(text: self.topic.text)
            
        }))
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func deleteAlert() {
        
        guard let user = Auth.auth().currentUser else {
            tableView.reloadData()
            return
        }
        
        guard user.uid == topic.authorUID else {
            tableView.reloadData()
            return
        }
        
        guard user.uid == topic.authorUID else {
            return
        }
        
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
        
        guard let user = Auth.auth().currentUser else {
            tableView.reloadData()
            return
        }
        
        guard user.uid == comment.authorUID else {
            tableView.reloadData()
            return
        }
        
        let alert = UIAlertController(title: "just checking", message: "are you sure you want to delete this comment?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "no", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "yes", style: .default, handler: { (action) in
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
        
        alert.addAction(UIAlertAction(title: "no", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "yes", style: .default, handler: { (action) in
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
    
    func reportCommentAlert(comment: Comment, cell: CommentCell) {
        
        let alert = UIAlertController(title: "hmmm", message: "what would you like to do", preferredStyle: .alert)
            
        alert.addAction(UIAlertAction(title: "block user", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            // add blocked user to user's blocked list in firestore
            
            guard let user = Auth.auth().currentUser else {
                AlertController.showAlert(self, title: "Error", message: "must be logged in to block users")
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
            
            Firestore.firestore().collection("Harrasment Reports").document("\(Date().timeIntervalSince1970)").setData(data)
            
            self.sendEmail(text: comment.text)
            
        }))
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
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
        
        cell.contentView.isUserInteractionEnabled = false
        
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
        cell.blockedUIDs = blockedUIDs
        
        var blocked: Bool = false
        cell.unblockBtn.setTitle("unblock \(cell.comment.author)?", for: .normal)
        
        for uid in blockedUIDs {
            
            if cell.comment.authorUID == uid{
                blocked = true
                break
            }
            
        }
        
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
            
            if let user = Auth.auth().currentUser {
                
                if topic.comments[indexPath.row].authorUID == user.uid {
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
                    
                    cell.reportBtn.isHidden = false
                    
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
                
                // no user signed in
                
                
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
    
    
    func reportCommentBtnTapped(comment: Comment, cell: CommentCell) {
        
        reportCommentAlert(comment: comment, cell: cell)
        
    }
    
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

extension TopicVC: MFMailComposeViewControllerDelegate {
    
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
