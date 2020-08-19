//
//  AlertController.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 8/30/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import Foundation
import UIKit

class AlertController: UIViewController {
    
    static func showAlert(_ inViewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        inViewController.present(alert, animated: true, completion: nil)
    }
    
}

