//
//  ViewController.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 1/10/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

var selectedEvent = ""
var selectedYear = 0

class CalendarVC: UIViewController {
    
    var events: [Event] = []
    
    var interstitial: GADInterstitial!
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .singleLine
        tv.separatorColor = #colorLiteral(red: 1, green: 0.8878712058, blue: 0.872946322, alpha: 1)
        tv.register(CalendarCell.self, forCellReuseIdentifier: "eventCell")
        return tv
    }()
    
    let yearLbl: UILabel = {
        let yearLbl = UILabel()
        yearLbl.textAlignment = .center
        yearLbl.textColor = .white
        yearLbl.font = UIFont(name: "Avenir-Book", size: 22)
        yearLbl.text = String(Calendar.current.component(.year, from: Date()))
        return yearLbl
    }()
    
    let increaseYearBtn: UIButton = {
        let increaseYearBtn = UIButton()
        increaseYearBtn.contentHorizontalAlignment = .left
        increaseYearBtn.addTarget(self, action: #selector(increaseYear), for: .touchUpInside)
        increaseYearBtn.setImage(UIImage(named: "IncreaseArrow"), for: .normal)
        return increaseYearBtn
    }()
    
    let decreaseYearBtn: UIButton = {
        let decreaseYearBtn = UIButton()
        decreaseYearBtn.contentHorizontalAlignment = .right
        decreaseYearBtn.addTarget(self, action: #selector(decreaseYear), for: .touchUpInside)
        decreaseYearBtn.setImage(UIImage(named: "DecreaseArrow"), for: .normal)
        return decreaseYearBtn
    }()
    
    var janEvents: [Event] = []
    var febEvents: [Event] = []
    var marEvents: [Event] = []
    var aprEvents: [Event] = []
    var mayEvents: [Event] = []
    var junEvents: [Event] = []
    var julEvents: [Event] = []
    var augEvents: [Event] = []
    var sepEvents: [Event] = []
    var octEvents: [Event] = []
    var novEvents: [Event] = []
    var decEvents: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        selectedYear = Calendar.current.component(.year, from: Date())
        loadEvents()
        setupLayout()
        
        interstitial = createAndLoadInterstitial()
        
        tableView.reloadData()
        
    }
    
    func setupLayout() {
        
        view.backgroundColor = #colorLiteral(red: 0.2513133883, green: 0.2730262578, blue: 0.302120626, alpha: 1)
        addSubviews()
        applyAnchors()
        
        // if the year represented by yearLbl is the current year, hide decreaseYearBtn (maybe change to 2020 so ppl can see previous years)
        
        if yearLbl.text == String(Calendar.current.component(.year, from: Date())) {
            decreaseYearBtn.isHidden = true
        }
        
    }
    
    func addSubviews() {
        
        view.addSubview(yearLbl)
        view.addSubview(tableView)
        view.addSubview(increaseYearBtn)
        view.addSubview(decreaseYearBtn)
        
    }
    
    func applyAnchors() {
        
        yearLbl.anchors(top: view.topAnchor, topPad: 60, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 30, width: 60)
        
        tableView.anchors(top: yearLbl.bottomAnchor, topPad: 10, bottom: view.bottomAnchor, bottomPad: -(self.tabBarController?.tabBar.frame.size.height)!, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        increaseYearBtn.anchors(top: view.topAnchor, topPad: 60, bottom: nil, bottomPad: 0, left: yearLbl.rightAnchor, leftPad: 0, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 30, width: 60)
        
        decreaseYearBtn.anchors(top: view.topAnchor, topPad: 60, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: yearLbl.leftAnchor, rightPad: 0, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 30, width: 60)
        
    }
    
    @objc func increaseYear() {
        selectedYear += 1
        yearLbl.text = String(selectedYear)
        decreaseYearBtn.isHidden = false
        loadEvents()
        tableView.reloadData()
    }
    
    @objc func decreaseYear() {
        selectedYear -= 1
        yearLbl.text = String(selectedYear)
        if selectedYear == 2020 {
            decreaseYearBtn.isHidden = true
        }
        loadEvents()
        tableView.reloadData()
    }
    
    func loadEvents() {
        
        Firestore.firestore().collection("Years").document(String(selectedYear)).collection("Events").getDocuments(completion: { (snap, error) in
            
            self.events = []
            
            if let snap = snap {
                
                for document in snap.documents {
                    let name = document.documentID
                    let data = document.data()
                    let month = data["month"] as? Int
                    let day = data["day"] as? Int
                    let event = Event(name: name, month: month ?? 0, day: day ?? 0)
                    self.events.append(event)
                }
                
            }
            
            self.janEvents = self.events.filter { $0.month == 1 }
            self.febEvents = self.events.filter { $0.month == 2 }
            self.marEvents = self.events.filter { $0.month == 3 }
            self.aprEvents = self.events.filter { $0.month == 4 }
            self.mayEvents = self.events.filter { $0.month == 5 }
            self.junEvents = self.events.filter { $0.month == 6 }
            self.julEvents = self.events.filter { $0.month == 7 }
            self.augEvents = self.events.filter { $0.month == 8 }
            self.sepEvents = self.events.filter { $0.month == 9 }
            self.octEvents = self.events.filter { $0.month == 10 }
            self.novEvents = self.events.filter { $0.month == 11 }
            self.decEvents = self.events.filter { $0.month == 12 }
            
            self.janEvents.sort { $0.day < $1.day }
            self.febEvents.sort { $0.day < $1.day }
            self.marEvents.sort { $0.day < $1.day }
            self.aprEvents.sort { $0.day < $1.day }
            self.mayEvents.sort { $0.day < $1.day }
            self.junEvents.sort { $0.day < $1.day }
            self.julEvents.sort { $0.day < $1.day }
            self.augEvents.sort { $0.day < $1.day }
            self.sepEvents.sort { $0.day < $1.day }
            self.octEvents.sort { $0.day < $1.day }
            self.novEvents.sort { $0.day < $1.day }
            self.decEvents.sort { $0.day < $1.day }
            
            self.tableView.reloadData()
            
        })
        
    }

}

extension CalendarVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Remove seperator inset
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = .zero
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.darkGray
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "January" }
        else if section == 1 { return "February" }
        else if section == 2 { return "March" }
        else if section == 3 { return "April" }
        else if section == 4 { return "May" }
        else if section == 5 { return "June" }
        else if section == 6 { return "July" }
        else if section == 7 { return "August" }
        else if section == 8 { return "September" }
        else if section == 9 { return "October" }
        else if section == 10 { return "November" }
        else { return "December" }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return self.events.filter{ $0.month == 1 }.count }
        else if section == 1 { return self.events.filter { $0.month == 2 }.count }
        else if section == 2 { return self.events.filter { $0.month == 3 }.count }
        else if section == 3 { return self.events.filter { $0.month == 4 }.count }
        else if section == 4 { return self.events.filter { $0.month == 5 }.count }
        else if section == 5 { return self.events.filter { $0.month == 6 }.count }
        else if section == 6 { return self.events.filter { $0.month == 7 }.count }
        else if section == 7 { return self.events.filter { $0.month == 8 }.count }
        else if section == 8 { return self.events.filter { $0.month == 9 }.count }
        else if section == 9 { return self.events.filter { $0.month == 10 }.count }
        else if section == 10 { return self.events.filter { $0.month == 11 }.count }
        else { return self.events.filter { $0.month == 12 }.count }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            selectedEvent = janEvents[indexPath.row].name
        } else if indexPath.section == 1 {
            selectedEvent = febEvents[indexPath.row].name
        } else if indexPath.section == 2 {
            selectedEvent = marEvents[indexPath.row].name
        } else if indexPath.section == 3 {
            selectedEvent = aprEvents[indexPath.row].name
        } else if indexPath.section == 4 {
            selectedEvent = mayEvents[indexPath.row].name
        } else if indexPath.section == 5 {
            selectedEvent = junEvents[indexPath.row].name
        } else if indexPath.section == 6 {
            selectedEvent = julEvents[indexPath.row].name
        } else if indexPath.section == 7 {
            selectedEvent = augEvents[indexPath.row].name
        } else if indexPath.section == 8 {
            selectedEvent = sepEvents[indexPath.row].name
        } else if indexPath.section == 9 {
            selectedEvent = octEvents[indexPath.row].name
        } else if indexPath.section == 10 {
            selectedEvent = novEvents[indexPath.row].name
        } else {
            selectedEvent = decEvents[indexPath.row].name
        }
        
        let vc = ArticlesVC()
        
        let random = arc4random_uniform(3)
        
        if random == 0 {
            
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
                navigationController?.pushViewController(vc, animated: true)
            } else {
                print("interstitial not ready")
                navigationController?.pushViewController(vc, animated: true)
            }
            
        } else {
            print("random number not correct")
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! CalendarCell
        
        cell.eventNameLbl.numberOfLines = 0
        
        if indexPath.section == 0 {
            cell.eventNameLbl.text = janEvents[indexPath.row].name
            
            let day = janEvents[indexPath.row].day
            let month = janEvents[indexPath.row].month
            var dayString: String
            var monthString: String
            
            if day < 10 {
                dayString = "0" + String(day)
            } else {
                dayString = String(day)
            }
            
            if month < 10 {
                monthString = "0" + String(month)
            } else {
                monthString = String(month)
            }
            
            cell.eventDateLbl.text = "\(monthString)/\(dayString)/\(selectedYear)"
        } else if indexPath.section == 1 {
            cell.eventNameLbl.text = febEvents[indexPath.row].name
            
            let day = febEvents[indexPath.row].day
            let month = febEvents[indexPath.row].month
            var dayString: String
            var monthString: String
            
            if day < 10 {
                dayString = "0" + String(day)
            } else {
                dayString = String(day)
            }
            
            if month < 10 {
                monthString = "0" + String(month)
            } else {
                monthString = String(month)
            }
            
            cell.eventDateLbl.text = "\(monthString)/\(dayString)/\(selectedYear)"
        } else if indexPath.section == 2 {
            cell.eventNameLbl.text = marEvents[indexPath.row].name
            
            let day = marEvents[indexPath.row].day
            let month = marEvents[indexPath.row].month
            var dayString: String
            var monthString: String
            
            if day < 10 {
                dayString = "0" + String(day)
            } else {
                dayString = String(day)
            }
            
            if month < 10 {
                monthString = "0" + String(month)
            } else {
                monthString = String(month)
            }
            
            cell.eventDateLbl.text = "\(monthString)/\(dayString)/\(selectedYear)"
        } else if indexPath.section == 3 {
            cell.eventNameLbl.text = aprEvents[indexPath.row].name
            
            let day = aprEvents[indexPath.row].day
            let month = aprEvents[indexPath.row].month
            var dayString: String
            var monthString: String
            
            if day < 10 {
                dayString = "0" + String(day)
            } else {
                dayString = String(day)
            }
            
            if month < 10 {
                monthString = "0" + String(month)
            } else {
                monthString = String(month)
            }
            
            cell.eventDateLbl.text = "\(monthString)/\(dayString)/\(selectedYear)"
        } else if indexPath.section == 4 {
            cell.eventNameLbl.text = mayEvents[indexPath.row].name
            
            let day = mayEvents[indexPath.row].day
            let month = mayEvents[indexPath.row].month
            var dayString: String
            var monthString: String
            
            if day < 10 {
                dayString = "0" + String(day)
            } else {
                dayString = String(day)
            }
            
            if month < 10 {
                monthString = "0" + String(month)
            } else {
                monthString = String(month)
            }
            
            cell.eventDateLbl.text = "\(monthString)/\(dayString)/\(selectedYear)"
        } else if indexPath.section == 5 {
            cell.eventNameLbl.text = junEvents[indexPath.row].name
            
            let day = junEvents[indexPath.row].day
            let month = junEvents[indexPath.row].month
            var dayString: String
            var monthString: String
            
            if day < 10 {
                dayString = "0" + String(day)
            } else {
                dayString = String(day)
            }
            
            if month < 10 {
                monthString = "0" + String(month)
            } else {
                monthString = String(month)
            }
            
            cell.eventDateLbl.text = "\(monthString)/\(dayString)/\(selectedYear)"
        } else if indexPath.section == 6 {
            cell.eventNameLbl.text = julEvents[indexPath.row].name
            
            let day = julEvents[indexPath.row].day
            let month = julEvents[indexPath.row].month
            var dayString: String
            var monthString: String
            
            if day < 10 {
                dayString = "0" + String(day)
            } else {
                dayString = String(day)
            }
            
            if month < 10 {
                monthString = "0" + String(month)
            } else {
                monthString = String(month)
            }
            
            cell.eventDateLbl.text = "\(monthString)/\(dayString)/\(selectedYear)"
        } else if indexPath.section == 7 {
            cell.eventNameLbl.text = augEvents[indexPath.row].name
            
            let day = augEvents[indexPath.row].day
            let month = augEvents[indexPath.row].month
            var dayString: String
            var monthString: String
            
            if day < 10 {
                dayString = "0" + String(day)
            } else {
                dayString = String(day)
            }
            
            if month < 10 {
                monthString = "0" + String(month)
            } else {
                monthString = String(month)
            }
            
            cell.eventDateLbl.text = "\(monthString)/\(dayString)/\(selectedYear)"
        } else if indexPath.section == 8 {
            cell.eventNameLbl.text = sepEvents[indexPath.row].name
            
            let day = sepEvents[indexPath.row].day
            let month = sepEvents[indexPath.row].month
            var dayString: String
            var monthString: String
            
            if day < 10 {
                dayString = "0" + String(day)
            } else {
                dayString = String(day)
            }
            
            if month < 10 {
                monthString = "0" + String(month)
            } else {
                monthString = String(month)
            }
            
            cell.eventDateLbl.text = "\(monthString)/\(dayString)/\(selectedYear)"
        } else if indexPath.section == 9 {
            cell.eventNameLbl.text = octEvents[indexPath.row].name
            
            let day = octEvents[indexPath.row].day
            let month = octEvents[indexPath.row].month
            var dayString: String
            var monthString: String
            
            if day < 10 {
                dayString = "0" + String(day)
            } else {
                dayString = String(day)
            }
            
            if month < 10 {
                monthString = "0" + String(month)
            } else {
                monthString = String(month)
            }
            
            cell.eventDateLbl.text = "\(monthString)/\(dayString)/\(selectedYear)"
        } else if indexPath.section == 10 {
            cell.eventNameLbl.text = novEvents[indexPath.row].name
            
            let day = novEvents[indexPath.row].day
            let month = novEvents[indexPath.row].month
            var dayString: String
            var monthString: String
            
            if day < 10 {
                dayString = "0" + String(day)
            } else {
                dayString = String(day)
            }
            
            if month < 10 {
                monthString = "0" + String(month)
            } else {
                monthString = String(month)
            }
            
            cell.eventDateLbl.text = "\(monthString)/\(dayString)/\(selectedYear)"
        } else {
            cell.eventNameLbl.text = decEvents[indexPath.row].name
            
            let day = decEvents[indexPath.row].day
            let month = decEvents[indexPath.row].month
            var dayString: String
            var monthString: String
            
            if day < 10 {
                dayString = "0" + String(day)
            } else {
                dayString = String(day)
            }
            
            if month < 10 {
                monthString = "0" + String(month)
            } else {
                monthString = String(month)
            }
            
            cell.eventDateLbl.text = "\(monthString)/\(dayString)/\(selectedYear)"
        }
        
        cell.eventNameLbl.sizeToFit()
        cell.layoutSubviews()
        cell.layoutIfNeeded()
        
        return cell
    }
    
}

extension CalendarVC: GADInterstitialDelegate {
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-2790005755690511/9849495395")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
}
