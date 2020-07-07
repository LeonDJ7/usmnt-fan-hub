//
//  NewsCell.swift
//  USMNT Fan App
//
//  Created by Leon Djusberg on 6/30/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9902476668, green: 0.9319022298, blue: 0.9057593346, alpha: 1)
        return view
    }()
    
    let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    let articleTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Book", size: 14)
        lbl.textColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
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
    
        backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        addSubviews() // add all subviews to layout
        applyAnchors() // layout constraints for each subview
        
    }
    
    func addSubviews() {
        
        addSubview(cellView)
        cellView.addSubview(articleImageView)
        cellView.addSubview(articleTitleLbl)
    }
    
    func applyAnchors() {
        
        cellView.anchors(top: topAnchor, topPad: 0, bottom: bottomAnchor, bottomPad: -3, left: leftAnchor, leftPad: 0, right: rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        articleImageView.anchors(top: cellView.topAnchor, topPad: 0, bottom: cellView.bottomAnchor, bottomPad: 0, left: cellView.leftAnchor, leftPad: 0, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 50, width: 50)
        
        articleTitleLbl.anchors(top: cellView.topAnchor, topPad: 0, bottom: cellView.bottomAnchor, bottomPad: 0, left: articleImageView.rightAnchor, leftPad: 5, right: cellView.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }

}
