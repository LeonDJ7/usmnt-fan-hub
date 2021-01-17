//
//  PollsTVCell.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 7/30/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class PollsCell: UITableViewCell {
    
    var delegate: PollsCellDelegate?
    var timestamp = 0.0
    var timer = Timer()
    
    let cellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        return view
    }()
    
    let questionLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.font = UIFont(name: "Avenir-Medium", size: 20)
        lbl.textColor = .white
        return lbl
    }()
    
    let timeRemainingLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.font = UIFont(name: "Avenir-Medium", size: 16)
        lbl.textColor = .gray
        lbl.text = "0 hr 0 min"
        return lbl
    }()
    
    let authorLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Medium", size: 12)
        lbl.numberOfLines = 0
        lbl.textColor = .gray
        return lbl
    }()
    
    let authorProfileImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 10
        return imgView
    }()
    
    let totalVotesLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Medium", size: 12)
        lbl.textColor = .gray
        lbl.textAlignment = .center
        return lbl
    }()
    
    let answer1Btn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont(name: "Avenir-Book", size: 14)
        btn.setTitleColor(.darkGray, for: .normal)
        return btn
    }()
    
    let answer1Lbl: PaddingLabel = {
        let lbl = PaddingLabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Book", size: 14)
        lbl.textColor = .white
        lbl.backgroundColor = .darkGray
        lbl.layer.cornerRadius = 5
        lbl.clipsToBounds = true
        return lbl
    }()
    
    let answer1PercentLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 14)
        lbl.textColor = .darkGray
        lbl.isHidden = true
        lbl.textAlignment = .center
        return lbl
    }()
    
    let answer2Btn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont(name: "Avenir-Book", size: 14)
        btn.setTitleColor(.darkGray, for: .normal)
        return btn
    }()
    
    let answer2Lbl: PaddingLabel = {
        let lbl = PaddingLabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Book", size: 14)
        lbl.textColor = .white
        lbl.backgroundColor = .darkGray
        lbl.layer.cornerRadius = 5
        lbl.clipsToBounds = true
        return lbl
    }()
    
    let answer2PercentLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 14)
        lbl.textColor = .darkGray
        lbl.isHidden = true
        lbl.textAlignment = .center
        return lbl
    }()
    
    let answer3Btn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont(name: "Avenir-Book", size: 14)
        btn.setTitleColor(.darkGray, for: .normal)
        return btn
    }()
    
    let answer3Lbl: PaddingLabel = {
        let lbl = PaddingLabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Book", size: 14)
        lbl.textColor = .white
        lbl.backgroundColor = .darkGray
        lbl.layer.cornerRadius = 5
        lbl.clipsToBounds = true
        return lbl
    }()
    
    let answer3PercentLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 14)
        lbl.textColor = .darkGray
        lbl.isHidden = true
        lbl.textAlignment = .center
        return lbl
    }()
    
    let answer4Btn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont(name: "Avenir-Book", size: 14)
        btn.setTitleColor(.darkGray, for: .normal)
        return btn
    }()
    
    let answer4Lbl: PaddingLabel = {
        let lbl = PaddingLabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Book", size: 14)
        lbl.textColor = .white
        lbl.backgroundColor = .darkGray
        lbl.layer.cornerRadius = 5
        lbl.clipsToBounds = true
        return lbl
    }()
    
    let answer4PercentLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 14)
        lbl.textColor = .darkGray
        lbl.isHidden = true
        lbl.textAlignment = .center
        return lbl
    }()
    
    let deleteBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setImage(UIImage(named: "DeleteBtnImage"), for: .normal)
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
        btn.setTitle("view sensitive content", for: .normal)
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
    
    
    var answer1Score = 0.0
    var answer2Score = 0.0
    var answer3Score = 0.0
    var answer4Score = 0.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        addTargets() // connect each btn with its method
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        
        self.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        addSubviews() // add all subviews to layout
        applyAnchors() // layout constraints for each subview
        randomizeColor() // randomize color of buttons for each poll and author profile image voew background
        
    }
    
    func addSubviews() {
        
        addSubview(cellView)
        cellView.addSubview(questionLbl)
        cellView.addSubview(timeRemainingLbl)
        cellView.addSubview(authorProfileImageView)
        cellView.addSubview(authorLbl)
        cellView.addSubview(totalVotesLbl)
        cellView.addSubview(timeRemainingLbl)
        cellView.addSubview(answer1Lbl)
        cellView.addSubview(answer2Lbl)
        cellView.addSubview(answer3Lbl)
        cellView.addSubview(answer4Lbl)
        cellView.addSubview(answer1Btn)
        cellView.addSubview(answer2Btn)
        cellView.addSubview(answer3Btn)
        cellView.addSubview(answer4Btn)
        cellView.addSubview(deleteBtn)
        cellView.addSubview(reportBtn)
        answer1Btn.addSubview(answer1PercentLbl)
        answer2Btn.addSubview(answer2PercentLbl)
        answer3Btn.addSubview(answer3PercentLbl)
        answer4Btn.addSubview(answer4PercentLbl)
        addSubview(sensitiveContentWarningBtn)
        addSubview(blockedLbl)
        addSubview(unblockBtn)
                
    }
    
    func applyAnchors() {
        
        cellView.anchors(top: topAnchor, topPad: 5, bottom: bottomAnchor, bottomPad: -5, left: leftAnchor, leftPad: 5, right: rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        deleteBtn.anchors(top: cellView.topAnchor, topPad: 13, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: cellView.rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 20, width: 20)
        
        reportBtn.anchors(top: cellView.topAnchor, topPad: 13, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: cellView.rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 20, width: 20)
        
        questionLbl.anchors(top: cellView.topAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: cellView.leftAnchor, leftPad: 5, right: reportBtn.leftAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        timeRemainingLbl.anchors(top: questionLbl.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: cellView.leftAnchor, leftPad: 5, right: cellView.rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 22, width: 0)
        
        authorProfileImageView.anchors(top: timeRemainingLbl.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: cellView.leftAnchor, leftPad: 5, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 20, width: 20)
        
        authorLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: authorProfileImageView.rightAnchor, leftPad: 10, right: cellView.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: authorProfileImageView.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        totalVotesLbl.anchors(top: timeRemainingLbl.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: cellView.rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 80)
        
        answer1Lbl.anchors(top: authorProfileImageView.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: cellView.leftAnchor, leftPad: 5, right: cellView.rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 50, width: 0)
        
        answer1Btn.anchors(top: answer1Lbl.topAnchor, topPad: 0, bottom: answer1Lbl.bottomAnchor, bottomPad: 0, left: answer1Lbl.rightAnchor, leftPad: -80, right: answer1Lbl.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        answer2Lbl.anchors(top: answer1Lbl.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: cellView.leftAnchor, leftPad: 5, right: cellView.rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 50, width: 0)
        
        answer2Btn.anchors(top: answer2Lbl.topAnchor, topPad: 0, bottom: answer2Lbl.bottomAnchor, bottomPad: 0, left: answer2Lbl.rightAnchor, leftPad: -80, right: answer2Lbl.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        answer3Lbl.anchors(top: answer2Lbl.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: cellView.leftAnchor, leftPad: 5, right: cellView.rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 50, width: 0)
        
        answer3Btn.anchors(top: answer3Lbl.topAnchor, topPad: 0, bottom: answer3Lbl.bottomAnchor, bottomPad: 0, left: answer3Lbl.rightAnchor, leftPad: -80, right: answer3Lbl.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        answer4Lbl.anchors(top: answer3Lbl.bottomAnchor, topPad: 5, bottom: cellView.bottomAnchor, bottomPad: 0, left: cellView.leftAnchor, leftPad: 5, right: cellView.rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 50, width: 0)
        
        answer4Btn.anchors(top: answer4Lbl.topAnchor, topPad: 0, bottom: answer4Lbl.bottomAnchor, bottomPad: 0, left: answer4Lbl.rightAnchor, leftPad: -80, right: answer4Lbl.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        answer1PercentLbl.anchors(top: answer1Btn.topAnchor, topPad: 0, bottom: answer1Btn.bottomAnchor, bottomPad: 0, left: answer1Btn.leftAnchor, leftPad: 0, right: answer1Btn.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        answer2PercentLbl.anchors(top: answer2Btn.topAnchor, topPad: 0, bottom: answer2Btn.bottomAnchor, bottomPad: 0, left: answer2Btn.leftAnchor, leftPad: 0, right: answer2Btn.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        answer3PercentLbl.anchors(top: answer3Btn.topAnchor, topPad: 0, bottom: answer3Btn.bottomAnchor, bottomPad: 0, left: answer3Btn.leftAnchor, leftPad: 0, right: answer3Btn.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        answer4PercentLbl.anchors(top: answer4Btn.topAnchor, topPad: 0, bottom: answer4Btn.bottomAnchor, bottomPad: 0, left: answer4Btn.leftAnchor, leftPad: 0, right: answer4Btn.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        sensitiveContentWarningBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: centerXAnchor, centerXPad: 0, centerY: centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        blockedLbl.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: centerXAnchor, centerXPad: 0, centerY: centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        unblockBtn.anchors(top: blockedLbl.bottomAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: leftAnchor, leftPad: 0, right: rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func addTargets() {
        
        answer1Btn.addTarget(self, action: #selector(selectAnswer1(sender:)), for: .touchUpInside)
        answer2Btn.addTarget(self, action: #selector(selectAnswer2(sender:)), for: .touchUpInside)
        answer3Btn.addTarget(self, action: #selector(selectAnswer3(sender:)), for: .touchUpInside)
        answer4Btn.addTarget(self, action: #selector(selectAnswer4(sender:)), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleteBtnPressed(sender:)), for: .touchUpInside)
        reportBtn.addTarget(self, action: #selector(reportBtnPressed(sender:)), for: .touchUpInside)
        sensitiveContentWarningBtn.addTarget(self, action: #selector(ignoreSensitiveContent(sender:)), for: .touchUpInside)
        unblockBtn.addTarget(self, action: #selector(unblock(sender:)), for: .touchUpInside)
        
    }
    
    func scheduleTimeRemainingTimer() {
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        
        refreshTimeRemaining()
        
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(refreshTimeRemaining), userInfo: nil, repeats: true)
    }
    
    @objc func refreshTimeRemaining() {
        
        let calendar = Calendar.current
        let datePostedAt = Date(timeIntervalSince1970: timestamp)
        let datePostWillEnd = calendar.date(byAdding: .day, value: 1, to: datePostedAt)!
        let currentDate = Date()
        
        let currentDay = calendar.component(.day, from: currentDate)
        let endDay = calendar.component(.day, from: datePostWillEnd)
        
        let currentHour = calendar.component(.hour, from: currentDate)
        let endHour = calendar.component(.hour, from: datePostWillEnd)
        
        let currentMinute = calendar.component(.minute, from: currentDate)
        let endMinute = calendar.component(.minute, from: datePostWillEnd)
        
        if currentDay == endDay {
            // endDay hour must be greater than or equal to currentDay hour
            
            var hoursLeft = endHour - currentHour
            
            if currentMinute > endMinute {
                
                hoursLeft -= 1
                let minutesLeft = 60 - (currentMinute - endMinute)
                timeRemainingLbl.text = "\(hoursLeft) hr \(minutesLeft) min"
                
                if hoursLeft <= 0 && minutesLeft <= 0 {
                    timeRemainingLbl.text = "0 hr 0 min"
                } else {
                    timeRemainingLbl.text = "\(hoursLeft) hr \(minutesLeft) min"
                }
                
            } else {
                
                let minutesLeft = endMinute - currentMinute
                
                if hoursLeft <= 0 && minutesLeft <= 0 {
                    timeRemainingLbl.text = "0 hr 0 min"
                } else {
                    timeRemainingLbl.text = "\(hoursLeft) hr \(minutesLeft) min"
                }
                
            }
            
        } else {
            // currentDay hour must be greater than or equal to endDay hour
            
            var hoursLeft = 24 - (currentHour - endHour)
            
            if currentMinute > endMinute {
                
                hoursLeft -= 1
                let minutesLeft = 60 - (currentMinute - endMinute)
                
                if hoursLeft <= 0 && minutesLeft <= 0 {
                    timeRemainingLbl.text = "0 hr 0 min"
                } else {
                    timeRemainingLbl.text = "\(hoursLeft) hr \(minutesLeft) min"
                }
                
            } else {
                
                let minutesLeft = endMinute - currentMinute
                
                if hoursLeft <= 0 && minutesLeft <= 0 {
                    timeRemainingLbl.text = "0 hr 0 min"
                } else {
                    timeRemainingLbl.text = "\(hoursLeft) hr \(minutesLeft) min"
                }
                
            }
            
        }
        
    }
    
    func setUserProfileImage(uid: String) {
        
        let storageRef = Storage.storage().reference(forURL: "gs://usmnt-fan-app.appspot.com").child("profile_image").child(uid)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            
            if let error = error {
                print("Error: \(error)")
            } else {
                self.authorProfileImageView.image = UIImage(data: data!)!
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
        
        answer1Btn.backgroundColor = backgroundColor
        answer2Btn.backgroundColor = backgroundColor
        answer3Btn.backgroundColor = backgroundColor
        answer4Btn.backgroundColor = backgroundColor
        authorProfileImageView.backgroundColor = backgroundColor
        
    }
    
    @objc func selectAnswer1(sender: UIButton) {
        delegate?.didSelectAnswer1(row: sender.tag)
    }
    
    @objc func selectAnswer2(sender: UIButton) {
        delegate?.didSelectAnswer2(row: sender.tag)
    }
    
    @objc func selectAnswer3(sender: UIButton) {
        delegate?.didSelectAnswer3(row: sender.tag)
    }
    
    @objc func selectAnswer4(sender: UIButton) {
        delegate?.didSelectAnswer4(row: sender.tag)
    }
    
    @objc func deleteBtnPressed(sender: UIButton) {
        delegate?.deleteBtnPressed(row: sender.tag)
    }
    
    @objc func reportBtnPressed(sender: UIButton) {
        delegate?.reportBtnPressed(row: sender.tag)
    }
    
    @objc func ignoreSensitiveContent(sender: UIButton) {
        delegate?.ignoreSensitiveContent(row: sender.tag)
    }
    
    @objc func unblock(sender: UIButton) {
        delegate?.unblock(row: sender.tag)
    }
    
}

protocol PollsCellDelegate : class {
    
    func didSelectAnswer1(row: Int)
    
    func didSelectAnswer2(row: Int)
    
    func didSelectAnswer3(row: Int)
    
    func didSelectAnswer4(row: Int)
    
    func deleteBtnPressed(row: Int)
    
    func reportBtnPressed(row: Int)
    
    func ignoreSensitiveContent(row: Int)
    
    func unblock(row: Int)
    
}
