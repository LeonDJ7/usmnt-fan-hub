//
//  ArticleTableViewCell.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 1/17/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9902476668, green: 0.9319022298, blue: 0.9057593346, alpha: 1)
        return view
    }()
    
    let articleTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Book", size: 14)
        lbl.textColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        return lbl
    }()
    
    let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
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
        
        backgroundColor = .clear
        
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        addSubview(cellView)
        cellView.addSubview(articleTitleLbl)
        cellView.addSubview(articleImageView)
        
    }
    
    func applyAnchors() {
        
        cellView.anchors(top: topAnchor, topPad: 0, bottom: bottomAnchor, bottomPad: -3, left: leftAnchor, leftPad: 0, right: rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        articleImageView.anchors(top: cellView.topAnchor, topPad: 0, bottom: cellView.bottomAnchor, bottomPad: 0, left: cellView.leftAnchor, leftPad: 0, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 50, width: 50)
        
        articleTitleLbl.anchors(top: cellView.topAnchor, topPad: 0, bottom: cellView.bottomAnchor, bottomPad: 0, left: articleImageView.rightAnchor, leftPad: 5, right: cellView.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    func downloadImage(from url: URL) {
        
        getData(from: url) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() { [weak self] in
                self?.articleImageView.image = UIImage(data: data)
            }
            
        }
        
    }

}
