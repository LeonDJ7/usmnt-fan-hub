//
//  TeamSelectorTVCell.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 7/17/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit

class AgeGroupCell: UITableViewCell {
    
    let ageGroupLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .darkGray
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Book", size: 15)
        return lbl
    }()
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.75)
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        addSubview(cellView)
        cellView.addSubview(ageGroupLbl)
        
    }
    
    func applyAnchors() {
        
        cellView.anchors(top: topAnchor, topPad: 0, bottom: bottomAnchor, bottomPad: 0, left: leftAnchor, leftPad: 0, right: rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        ageGroupLbl.anchors(top: cellView.topAnchor, topPad: 10, bottom: cellView.bottomAnchor, bottomPad: -10, left: cellView.leftAnchor, leftPad: 10, right: cellView.rightAnchor, rightPad: -10, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    

}
