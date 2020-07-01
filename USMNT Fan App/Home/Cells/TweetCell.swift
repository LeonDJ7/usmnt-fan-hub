//
//  TweetCell.swift
//  USMNT Fan App
//
//  Created by Leon Djusberg on 6/30/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

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
        
        
        
    }
    
    func applyAnchors() {
        
    
        
    }

}
