//
//  ForumTVCell.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 4/4/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class TopicCell: UITableViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 5
        return view
    }()
    
    let topicLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        lbl.textColor = .white
        return lbl
    }()
    
    let authorImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 10
        return imgView
    }()
    
    let authorLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Book", size: 14)
        lbl.textColor = .gray
        return lbl
    }()
    
    let lastActiveView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let lastActiveLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 12)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = .darkGray
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
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
        
        addSubview(cellView)
        cellView.addSubview(topicLbl)
        cellView.addSubview(authorImageView)
        cellView.addSubview(authorLbl)
        cellView.addSubview(lastActiveView)
        lastActiveView.addSubview(lastActiveLbl)
        
    }
    
    func applyAnchors() {
        
        cellView.anchors(top: topAnchor, topPad: 0, bottom: bottomAnchor, bottomPad: -5, left: leftAnchor, leftPad: 10, right: rightAnchor, rightPad: -10, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        topicLbl.anchors(top: cellView.topAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: cellView.leftAnchor, leftPad: 10, right: cellView.rightAnchor, rightPad: -85, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        authorImageView.anchors(top: topicLbl.bottomAnchor, topPad: 3, bottom: cellView.bottomAnchor, bottomPad: -5, left: cellView.leftAnchor, leftPad: 10, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 20, width: 20)
        
        authorLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: authorImageView.rightAnchor, leftPad: 10, right: cellView.rightAnchor, rightPad: -85, centerX: nil, centerXPad: 0, centerY: authorImageView.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        lastActiveView.anchors(top: cellView.topAnchor, topPad: 0, bottom: cellView.bottomAnchor, bottomPad: 0, left: cellView.rightAnchor, leftPad: -80, right: cellView.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        lastActiveLbl.anchors(top: lastActiveView.topAnchor, topPad: 5, bottom: lastActiveView.bottomAnchor, bottomPad: -5, left: lastActiveView.leftAnchor, leftPad: 5, right: lastActiveView.rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func setUserProfileImage(uid: String) {
        
        let storageRef = Storage.storage().reference(forURL: "gs://usmnt-fan-app.appspot.com").child("profile_image").child(uid)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            
            if let error = error {
                print("Error: \(error)")
            } else {
                self.authorImageView.image = UIImage(data: data!)!
            }
            
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

}
