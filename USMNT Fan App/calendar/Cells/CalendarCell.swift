//
//  EventTableViewCell.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 1/10/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit

class CalendarCell: UITableViewCell {
    
    let cellView: UIView = {
        let cellView = UIView()
        //cellView.backgroundColor = .white
        cellView.alpha = 0.6
        cellView.layer.cornerRadius = 3
        return cellView
    }()
    
    let eventNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        lbl.numberOfLines = 0
        lbl.textColor = .white
        lbl.lineBreakMode = .byWordWrapping
        lbl.text = ""
        return lbl
    }()
    
    let eventDateLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        //lbl.numberOfLines = 0
        lbl.textColor = .white
        lbl.text = ""
        return lbl
    }()
    
    let customDisclosureIndicator: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "ListClosed")
        return imgView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
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
        cellView.addSubview(eventDateLbl)
        cellView.addSubview(eventNameLbl)
        cellView.addSubview(customDisclosureIndicator)
        
    }
    
    func applyAnchors() {
        
        cellView.anchors(top: topAnchor, topPad: 0, bottom: bottomAnchor, bottomPad: 0, left: leftAnchor, leftPad: 5, right: rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        customDisclosureIndicator.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: cellView.rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: cellView.centerYAnchor, centerYPad: 0, height: 0, width: 0)
        
        eventDateLbl.anchors(top: cellView.topAnchor, topPad: 10, bottom: cellView.bottomAnchor, bottomPad: -10, left: cellView.leftAnchor, leftPad: 20, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 100)
        
        eventNameLbl.anchors(top: cellView.topAnchor, topPad: 10, bottom: cellView.bottomAnchor, bottomPad: -10, left: eventDateLbl.rightAnchor, leftPad: 20, right: cellView.rightAnchor, rightPad: -30, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        
        
    }
    
}
