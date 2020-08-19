//
//  FullRosterTVCell.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 7/15/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit

class RosterCell: UITableViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        return view
    }()
    
    let playerLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        lbl.textColor = .white
        return lbl
    }()
    
    let ageLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 12)
        lbl.textColor = .lightGray
        return lbl
    }()
    
    let clubLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 12)
        lbl.textColor = .lightGray
        return lbl
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        addSubview(cellView)
        cellView.addSubview(playerLbl)
        cellView.addSubview(ageLbl)
        cellView.addSubview(clubLbl)
        
    }
    
    func applyAnchors() {
        
        cellView.anchors(top: topAnchor, topPad: 0, bottom: bottomAnchor, bottomPad: 0, left: leftAnchor, leftPad: 0, right: rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        playerLbl.anchors(top: cellView.topAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: cellView.leftAnchor, leftPad: 10, right: cellView.rightAnchor, rightPad: -10, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        ageLbl.anchors(top: playerLbl.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: cellView.leftAnchor, leftPad: 10, right: cellView.rightAnchor, rightPad: -10, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        clubLbl.anchors(top: ageLbl.bottomAnchor, topPad: 5, bottom: cellView.bottomAnchor, bottomPad: -10, left: cellView.leftAnchor, leftPad: 10, right: cellView.rightAnchor, rightPad: -10, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
}
