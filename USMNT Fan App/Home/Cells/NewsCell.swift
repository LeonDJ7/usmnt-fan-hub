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
        return imageView
    }()
    
    let articleTitleLbl: UILabel = {
        let lbl = UILabel()
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
        
        self.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        addSubviews() // add all subviews to layout
        applyAnchors() // layout constraints for each subview
        
    }
    
    func addSubviews() {
        
        addSubview(cellView)
        cellView.addSubview(articleImageView)
        cellView.addSubview(articleTitleLbl)
    }
    
    func applyAnchors() {
        
        cellView.anchors(top: <#T##NSLayoutYAxisAnchor?#>, topPad: <#T##CGFloat#>, bottom: <#T##NSLayoutYAxisAnchor?#>, bottomPad: <#T##CGFloat#>, left: <#T##NSLayoutXAxisAnchor?#>, leftPad: <#T##CGFloat#>, right: <#T##NSLayoutXAxisAnchor?#>, rightPad: <#T##CGFloat#>, centerX: <#T##NSLayoutXAxisAnchor?#>, centerXPad: <#T##CGFloat#>, centerY: <#T##NSLayoutYAxisAnchor?#>, centerYPad: <#T##CGFloat#>, height: <#T##CGFloat#>, width: <#T##CGFloat#>)
        
        articleImageView.anchors(top: <#T##NSLayoutYAxisAnchor?#>, topPad: <#T##CGFloat#>, bottom: <#T##NSLayoutYAxisAnchor?#>, bottomPad: <#T##CGFloat#>, left: <#T##NSLayoutXAxisAnchor?#>, leftPad: <#T##CGFloat#>, right: <#T##NSLayoutXAxisAnchor?#>, rightPad: <#T##CGFloat#>, centerX: <#T##NSLayoutXAxisAnchor?#>, centerXPad: <#T##CGFloat#>, centerY: <#T##NSLayoutYAxisAnchor?#>, centerYPad: <#T##CGFloat#>, height: <#T##CGFloat#>, width: <#T##CGFloat#>)
        
        articleTitleLbl.anchors(top: <#T##NSLayoutYAxisAnchor?#>, topPad: <#T##CGFloat#>, bottom: <#T##NSLayoutYAxisAnchor?#>, bottomPad: <#T##CGFloat#>, left: <#T##NSLayoutXAxisAnchor?#>, leftPad: <#T##CGFloat#>, right: <#T##NSLayoutXAxisAnchor?#>, rightPad: <#T##CGFloat#>, centerX: <#T##NSLayoutXAxisAnchor?#>, centerXPad: <#T##CGFloat#>, centerY: <#T##NSLayoutYAxisAnchor?#>, centerYPad: <#T##CGFloat#>, height: <#T##CGFloat#>, width: <#T##CGFloat#>)
        
    }

}
