//
//  WebVC.swift
//  USMNT Fan App
//
//  Created by Leon Djusberg on 6/26/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import UIKit

class WebVC: UIViewController {
    
    let webView: UIWebView = {
        let wv = UIWebView()
        return wv
    }()
    
    var url: URL = URL(fileURLWithPath: "https://www.google.com")

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadRequest(URLRequest(url: url))
        
    }
    
    func setupLayout() {
        
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(webView)
        
    }
    
    func applyAnchors() {
        
        webView.anchors(top: view.topAnchor, topPad: 0, bottom: view.bottomAnchor, bottomPad: 0, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
    }

}
