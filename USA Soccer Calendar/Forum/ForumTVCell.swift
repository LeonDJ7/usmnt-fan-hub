//
//  ForumTVCell.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 4/4/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit

class ForumTVCell: UITableViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        return view
    }()
    
    let topicLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        return lbl
    }()
    
    let authorLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        return lbl
    }()
    
    let lastActiveView: UIView = {
        let view = UIView()
        return view
    }()
    
    let lastActiveLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        return lbl
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupLayout() {
        
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        addSubview(cellView)
        cellView.addSubview(topicLbl)
        cellView.addSubview(authorLbl)
        cellView.addSubview(lastActiveView)
        lastActiveView.addSubview(lastActiveLbl)
        
    }
    
    func applyAnchors() {
        
        cellView.anchors(top: topAnchor, topPad: 5, bottom: bottomAnchor, bottomPad: -5, left: leftAnchor, leftPad: 5, right: rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        topicLbl.anchors(top: cellView.topAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: cellView.leftAnchor, leftPad: 5, right: cellView.rightAnchor, rightPad: -80, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        authorLbl.anchors(top: topicLbl.topAnchor, topPad: 5, bottom: cellView.bottomAnchor, bottomPad: -5, left: cellView.leftAnchor, leftPad: 5, right: cellView.rightAnchor, rightPad: -80, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        lastActiveView.anchors(top: cellView.topAnchor, topPad: 0, bottom: cellView.bottomAnchor, bottomPad: 0, left: cellView.rightAnchor, leftPad: -80, right: cellView.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }

}
