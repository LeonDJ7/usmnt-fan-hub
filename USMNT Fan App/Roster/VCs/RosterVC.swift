//
//  LineupBuilderVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 6/26/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase



class RosterVC: UIViewController {
    
    var showAgeGroupDropDown = false
    
    var bannerView: GADBannerView!
    
    var ageGroupSelected = "USMNT"
    var ageGroups: [String] = ["USMNT", "U-23", "U-20", "U-17"]
    
    var goalkeepers: [Player] = []
    var defenders: [Player] = []
    var midfielders: [Player] = []
    var forwards: [Player] = []
    
    var ageGroupSelectorTV: UITableView = {
        let tv = UITableView()
        tv.tag = 1
        tv.separatorStyle = .none
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.layer.cornerRadius = 5
        tv.clipsToBounds = true
        tv.register(AgeGroupCell.self, forCellReuseIdentifier: "ageGroupCell")
        return tv
    }()
    
    let ageGroupSelectorBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("USMNT", for: .normal)
        btn.addTarget(self, action: #selector(handleAgeGroupDropDown), for: .touchUpInside)
        btn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 22)
        return btn
    }()

    let rosterTV: UITableView = {
        let tv = UITableView()
        tv.tag = 0
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        tv.register(RosterCell.self, forCellReuseIdentifier: "rosterCell")
        return tv
    }()
    
    let leftBorder: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9703117013, green: 0.845465064, blue: 0.8473052382, alpha: 1)
        return view
    }()
    
    let rightBorder: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        return view
    }()
    
    let centerLeftBorder: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.6477842331, blue: 0.6557761431, alpha: 1)
        return view
    }()
    
    let centerRightBorder: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9552132487, green: 0.9736793637, blue: 1, alpha: 1)
        return view
    }()
    
    let listIndicator: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "ListClosed")
        return imgView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .whiteLarge
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rosterTV.delegate = self
        rosterTV.dataSource = self
        ageGroupSelectorTV.delegate = self
        ageGroupSelectorTV.dataSource = self
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-2790005755690511/7934596736"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        setupLayout()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        activityIndicator.startAnimating()
        
        DispatchQueue.global().async { // might take a sec or 2
            
            while USMNTforwards.count == 0 {
                
            }
            
            let deadline = DispatchTime.now() + .milliseconds(100) // give little gap to make sure rest of players load
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                self.activityIndicator.stopAnimating()
                self.setPlayers()
            }
            
        }
        
    }
    
    func setupLayout() {
        
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(ageGroupSelectorBtn)
        view.addSubview(listIndicator)
        view.addSubview(bannerView)
        view.addSubview(rosterTV)
        view.addSubview(leftBorder)
        view.addSubview(centerLeftBorder)
        view.addSubview(centerRightBorder)
        view.addSubview(rightBorder)
        view.addSubview(ageGroupSelectorTV)
        view.addSubview(activityIndicator)
        
    }
    
    func applyAnchors() {
        
        ageGroupSelectorBtn.anchors(top: view.topAnchor, topPad: 40, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        listIndicator.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: ageGroupSelectorBtn.rightAnchor, leftPad: 3, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: ageGroupSelectorBtn.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        leftBorder.anchors(top: ageGroupSelectorBtn.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 0, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 15, width: view.frame.width/4)
        
        centerLeftBorder.anchors(top: ageGroupSelectorBtn.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: leftBorder.rightAnchor, leftPad: 0, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 15, width: view.frame.width/4)
        
        centerRightBorder.anchors(top: ageGroupSelectorBtn.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: centerLeftBorder.rightAnchor, leftPad: 0, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 15, width: view.frame.width/4)
        
        rightBorder.anchors(top: ageGroupSelectorBtn.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: centerRightBorder.rightAnchor, leftPad: 0, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 15, width: view.frame.width/4)
        
        bannerView.anchors(top: nil, topPad: 0, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        rosterTV.anchors(top: centerLeftBorder.bottomAnchor, topPad: 0, bottom: bannerView.topAnchor, bottomPad: 0, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        ageGroupSelectorTV.anchors(top: ageGroupSelectorBtn.bottomAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 160, width: 150)
        
        activityIndicator.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: view.centerYAnchor, centerYPad: 0, height: 0, width: 0)
    }
    
    @objc func handleAgeGroupDropDown() {
        
        showAgeGroupDropDown = !showAgeGroupDropDown
        
        var indexPaths = [IndexPath]()
        
        for index in 0...ageGroups.count-1 {
            let indexPath = IndexPath(row: index, section: 0)
            indexPaths.append(indexPath)
        }
        
        if showAgeGroupDropDown == true {
            ageGroupSelectorTV.insertRows(at: indexPaths, with: .fade)
            listIndicator.image = UIImage(named: "ListOpen")
        } else {
            ageGroupSelectorTV.deleteRows(at: indexPaths, with: .fade)
            listIndicator.image = UIImage(named: "ListClosed")
        }
    }
    
    func setPlayers() {
        
        if ageGroupSelected == "USMNT" {
            goalkeepers = USMNTgoalkeepers
            defenders = USMNTdefenders
            midfielders = USMNTmidfielders
            forwards = USMNTforwards
        }
        
        if ageGroupSelected == "U-23" {
            goalkeepers = U23goalkeepers
            defenders = U23defenders
            midfielders = U23midfielders
            forwards = U23forwards
        }
        
        if ageGroupSelected == "U-20" {
            goalkeepers = U20goalkeepers
            defenders = U20defenders
            midfielders = U20midfielders
            forwards = U20forwards
        }
        
        if ageGroupSelected == "U-17" {
            goalkeepers = U17goalkeepers
            defenders = U17defenders
            midfielders = U17midfielders
            forwards = U17forwards
        }
        
        rosterTV.reloadData()
        
    }
    
}

extension RosterVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "rosterCell") as! RosterCell
            
            if indexPath.section == 0 {
                cell.playerLbl.text = goalkeepers[indexPath.row].name
                cell.ageLbl.text = goalkeepers[indexPath.row].age
                cell.clubLbl.text = goalkeepers[indexPath.row].club
            } else if indexPath.section == 1 {
                cell.playerLbl.text = defenders[indexPath.row].name
                cell.ageLbl.text = defenders[indexPath.row].age
                cell.clubLbl.text = defenders[indexPath.row].club
            } else if indexPath.section == 2 {
                cell.playerLbl.text = midfielders[indexPath.row].name
                cell.ageLbl.text = midfielders[indexPath.row].age
                cell.clubLbl.text = midfielders[indexPath.row].club
            } else if indexPath.section == 3 {
                cell.playerLbl.text = forwards[indexPath.row].name
                cell.ageLbl.text = forwards[indexPath.row].age
                cell.clubLbl.text = forwards[indexPath.row].club
            } else {
                
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ageGroupCell") as! AgeGroupCell
            cell.ageGroupLbl.text = ageGroups[indexPath.row]
            
            return cell
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 0 {
            return 4
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == 0 {
            if section == 0 {
                return "Goalkeepers"
            } else if section == 1 {
                return "Defenders"
            } else if section == 2 {
                return "Midfielders"
            } else {
                return "Forwards"
            }
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            if section == 0 {
                return goalkeepers.count
            } else if section == 1 {
                return defenders.count
            } else if section == 2 {
                return midfielders.count
            } else {
                return forwards.count
            }
        } else {
            return showAgeGroupDropDown ? ageGroups.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 {
            return UITableView.automaticDimension
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 {
            return UITableView.automaticDimension
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1 {
            if indexPath.row == 0 && ageGroupSelected != "USMNT" {
                ageGroupSelected = "USMNT"
            } else if indexPath.row == 1 && ageGroupSelected != "U-23" {
                ageGroupSelected = "U-23"
            } else if indexPath.row == 2 && ageGroupSelected != "U-20" {
                ageGroupSelected = "U-20"
            } else if indexPath.row == 3 && ageGroupSelected != "U-17"{
                ageGroupSelected = "U-17"
            }
            
            ageGroupSelectorBtn.setTitle(ageGroupSelected, for: .normal)
            setPlayers()
            handleAgeGroupDropDown()
            
        }
    }
    
}
