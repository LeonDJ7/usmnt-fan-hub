//
//  ArticleTableViewCell.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 1/17/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit

class ArticlesTVCell: UITableViewCell {
    
    let cellView: UIView = {
        let cellView = UIView()
        cellView.backgroundColor = .clear
        cellView.layer.cornerRadius = 3
        return cellView
    }()
    
    var articleNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        lbl.textColor = .darkGray
        lbl.backgroundColor = .clear
        lbl.numberOfLines = 0
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
        
        backgroundColor = .clear
        accessoryType = .disclosureIndicator
        
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        addSubview(cellView)
        cellView.addSubview(articleNameLbl)
        
    }
    
    func applyAnchors() {
        
        cellView.anchors(top: topAnchor, topPad: 5, bottom: bottomAnchor, bottomPad: 0, left: leftAnchor, leftPad: 5, right: rightAnchor, rightPad: -5, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        articleNameLbl.anchors(top: cellView.topAnchor, topPad: 10, bottom: cellView.bottomAnchor, bottomPad: -10, left: cellView.leftAnchor, leftPad: 10, right: cellView.rightAnchor, rightPad: -40, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }

}
