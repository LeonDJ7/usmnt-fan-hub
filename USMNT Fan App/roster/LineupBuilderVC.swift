//
//  LineupBuilderVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 6/26/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class RosterVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var goalkeepers: [String] = []
    var defenders: [String] = []
    var midfielders: [String] = []
    var forwards: [String] = []
    
    var showAgeGroupDropDown = false
    
    var ageGroupSelected = "USMNT"
    var ageGroups: [String] = ["USMNT", "U-23", "U-20", "U-17"]
    
    let formationLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "4-3-3"
        lbl.font = UIFont(name: "Avenir-Book", size: 12)
        return lbl
    }()
    
    var ageGroupSelectorTV: UITableView = {
        let tv = UITableView()
        tv.tag = 1
        tv.separatorStyle = .none
        tv.isScrollEnabled = false
        tv.rowHeight = 50
        tv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return tv
    }()
    
    let ageGroupSelectorBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("USMNT", for: .normal)
        btn.addTarget(self, action: #selector(handleAgeGroupDropDown), for: .touchUpInside)
        return btn
    }()
    
    let cancelFullRosterViewBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(cancelFullRosterBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    let viewFullRosterBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Roster", for: .normal)
        btn.addTarget(self, action: #selector(viewFullRosterBtnTapped), for: .touchUpInside)
        return btn
    }()

    let fullRosterTV: UITableView = {
        let tv = UITableView()
        tv.tag = 0
        return tv
    }()
    
    let fullRosterLeftView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8220109344, green: 0.9567018151, blue: 1, alpha: 1)
        return view
    }()
    
    let fullRosterRightView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.649651885, green: 0.8118989468, blue: 1, alpha: 1)
        return view
    }()
    
    let fullRosterTopView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.8713274002, blue: 0.8919277787, alpha: 1)
        return view
    }()
    
    let fullRosterBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.6477842331, blue: 0.6557761431, alpha: 1)
        return view
    }()
    
    let fullRosterSelectedTeamLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        lbl.textColor = .white
        lbl.backgroundColor = .darkGray
        return lbl
    }()
    
    let shareBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    let bottomBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let fieldView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8802457452, green: 0.971534431, blue: 0.8791024089, alpha: 1)
        return view
    }()
    
    let optionsBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let playerView: UIView = {
        let btn = UIButton()
        let dot = UIImageView(image: UIImage(named: "AddChatBtn"))
        let view = UIView()
        view.addSubview(dot)
        view.addSubview(btn)
        dot.anchors(top: view.topAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        btn.anchors(top: dot.bottomAnchor, topPad: 0, bottom: view.bottomAnchor, bottomPad: 0, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        goalkeepers = getGoalkeepers()
        defenders = getDefenders()
        midfielders = getMidfielders()
        forwards = getForwards()
        
    }
    
    func setupLayout() {
        view.addSubview(fieldView)
        view.addSubview(bottomBarView)
        
        fieldView.anchors(top: view.topAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        bottomBarView.anchors(top: fieldView.bottomAnchor, topPad: 0, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 30, width: 0)
        
        view.addSubview(optionsBarView)
        optionsBarView.anchors(top: view.topAnchor, topPad: 30, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        optionsBarView.addSubview(viewFullRosterBtn)
        viewFullRosterBtn.anchors(top: optionsBarView.topAnchor, topPad: 0, bottom: optionsBarView.bottomAnchor, bottomPad: 0, left: nil, leftPad: 0, right: optionsBarView.rightAnchor, rightPad: -10, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        optionsBarView.addSubview(ageGroupSelectorBtn)
        ageGroupSelectorBtn.anchors(top: optionsBarView.topAnchor, topPad: 0, bottom: optionsBarView.bottomAnchor, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: optionsBarView.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        optionsBarView.addSubview(formationLbl)
        formationLbl.anchors(top: optionsBarView.topAnchor, topPad: 0, bottom: optionsBarView.bottomAnchor, bottomPad: 0, left: optionsBarView.leftAnchor, leftPad: 10, right: nil, rightPad: -0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        ageGroupSelectorTV.delegate = self
        ageGroupSelectorTV.dataSource = self
        ageGroupSelectorTV.register(AgeGroupTVCell.self, forCellReuseIdentifier: "ageGroupCell")
        optionsBarView.addSubview(ageGroupSelectorTV)
        ageGroupSelectorTV.anchors(top: optionsBarView.bottomAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 200, width: 150)
        
        
        // fullRosterTV and objects relating to its presentation must be the last thing added as a subview
        
        optionsBarView.addSubview(cancelFullRosterViewBtn)
        cancelFullRosterViewBtn.anchors(top: optionsBarView.topAnchor, topPad: 0, bottom: optionsBarView.bottomAnchor, bottomPad: 0, left: optionsBarView.leftAnchor, leftPad: 10, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        fullRosterTV.delegate = self
        fullRosterTV.dataSource = self
        fullRosterTV.register(FullRosterTVCell.self, forCellReuseIdentifier: "fullRosterCell")
        view.addSubview(fullRosterTV)
        fullRosterTV.anchors(top: view.topAnchor, topPad: 60, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!-30, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        fullRosterTV.isHidden = true
        
        view.addSubview(fullRosterLeftView)
        fullRosterLeftView.anchors(top: view.topAnchor, topPad: 0, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)! - 30, left: view.leftAnchor, leftPad: 0, right: fullRosterTV.leftAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        view.addSubview(fullRosterRightView)
        fullRosterRightView.anchors(top: view.topAnchor, topPad: 30, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!, left: fullRosterTV.rightAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        view.addSubview(fullRosterTopView)
        fullRosterTopView.anchors(top: view.topAnchor, topPad: 0, bottom: fullRosterTV.topAnchor, bottomPad: -30, left: view.leftAnchor, leftPad: 30, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        view.addSubview(fullRosterBottomView)
        fullRosterBottomView.anchors(top: fullRosterTV.bottomAnchor, topPad: 0, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        view.addSubview(fullRosterSelectedTeamLbl)
        fullRosterSelectedTeamLbl.text = ageGroupSelected
        fullRosterSelectedTeamLbl.anchors(top: fullRosterTopView.bottomAnchor, topPad: 0, bottom: fullRosterTV.topAnchor, bottomPad: 0, left: fullRosterLeftView.rightAnchor, leftPad: 0, right: fullRosterRightView.leftAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        fullRosterLeftView.isHidden = true
        fullRosterBottomView.isHidden = true
        fullRosterTopView.isHidden = true
        fullRosterRightView.isHidden = true
        fullRosterSelectedTeamLbl.isHidden = true
        
    }
    
    func getForwards() -> [String] {
        
        
        Firestore.firestore().collection("Rosters").document(ageGroupSelected).collection("Forwards").getDocuments { (snap, error) in
            
            var forwards: [String] = []
            
            for document in (snap?.documents)! {
                forwards.append(document.documentID)
            }
            
        }
        
        return forwards
        
    }
    
    func getMidfielders() -> [String] {
        
        
        Firestore.firestore().collection("Rosters").document(ageGroupSelected).collection("Forwards").getDocuments { (snap, error) in
            
            var midfielders: [String] = []
            
            for document in (snap?.documents)! {
                midfielders.append(document.documentID)
            }
            
        }
        
        return midfielders
        
    }
    
    func getDefenders() -> [String] {
        
        
        Firestore.firestore().collection("Rosters").document(ageGroupSelected).collection("Forwards").getDocuments { (snap, error) in
            
            var defenders: [String] = []
            
            for document in (snap?.documents)! {
                defenders.append(document.documentID)
            }
            
        }
        
        return defenders
        
    }
    
    func getGoalkeepers() -> [String] {
        
        
        Firestore.firestore().collection("Rosters").document(ageGroupSelected).collection("Forwards").getDocuments { (snap, error) in
            
            var goalkeepers: [String] = []
            
            for document in (snap?.documents)! {
                goalkeepers.append(document.documentID)
            }
            
        }
        
        return goalkeepers
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return goalkeepers.count + defenders.count + midfielders.count + forwards.count
        } else {
            return showAgeGroupDropDown ? ageGroups.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "fullRosterCell") as! FullRosterTVCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ageGroupCell") as! AgeGroupTVCell
            cell.ageGroupLbl.text = ageGroups[indexPath.row]
            return cell
        }
        
    }
    
    @objc func handleAgeGroupDropDown() {
        
        print("test")
        showAgeGroupDropDown = !showAgeGroupDropDown
        
        var indexPaths = [IndexPath]()
        
        for index in 0...ageGroups.count-1 {
            let indexPath = IndexPath(row: index, section: 0)
            indexPaths.append(indexPath)
        }
        
        if showAgeGroupDropDown == true {
            ageGroupSelectorTV.insertRows(at: indexPaths, with: .fade)
        } else {
            ageGroupSelectorTV.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    @objc func viewFullRosterBtnTapped() {
        fullRosterTV.isHidden = false
        fullRosterRightView.isHidden = false
        fullRosterLeftView.isHidden = false
        fullRosterTopView.isHidden = false
        fullRosterBottomView.isHidden = false
        cancelFullRosterViewBtn.isHidden = false
        formationLbl.isHidden = true
    }
    
    @objc func cancelFullRosterBtnTapped() {
        fullRosterTV.isHidden = true
        fullRosterRightView.isHidden = true
        fullRosterLeftView.isHidden = true
        fullRosterTopView.isHidden = true
        fullRosterBottomView.isHidden = true
        cancelFullRosterViewBtn.isHidden = true
        formationLbl.isHidden = false
    }

}
