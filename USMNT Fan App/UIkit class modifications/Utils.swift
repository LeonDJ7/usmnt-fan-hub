//
//  Utils.swift
//  USMNT Fan App
//
//  Created by Leon Djusberg on 1/16/21.
//  Copyright © 2021 Leon Djusberg. All rights reserved.
//

import Foundation
import UIKit

class CustomTableView: UITableView {
    
    override var intrinsicContentSize: CGSize {
            self.layoutIfNeeded()
            return self.contentSize
        }

    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
    
}
