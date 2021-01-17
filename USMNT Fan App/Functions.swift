//
//  Functions.swift
//  USMNT Fan App
//
//  Created by Leon Djusberg on 7/7/20.
//  Copyright © 2020 Leon Djusberg. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup
import Firebase

func scrapeUSMNTRosterFromWikipedia() {
    
    USMNTgoalkeepers = []
    USMNTdefenders = []
    USMNTmidfielders = []
    USMNTforwards = []

    let url = URL(string: "https://en.wikipedia.org/wiki/United_States_men%27s_national_soccer_team#Current_squad")!

    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        
        guard let data = data else { return }
        
        let htmlContent = String(data: data, encoding: .utf8)!
        
        do {
            
            let doc: Document = try SwiftSoup.parse(htmlContent)
            
            let elements: Elements = try doc.getElementsByClass("nat-fs-player")
            
            for subElements in elements {
                
                let positionString = try subElements.select("td").select("span").text()
                
                if (String(positionString[positionString.startIndex]) == "1") { // goalkeepers
                    
                    var name = ""
                    
                    let aArr = try subElements.select("a")
                    if aArr.count > 1 {
                        name = try aArr[1].text()
                    }
                    
                    let spanArr = try subElements.select("td")[2].select("span")
                    var age = ""
                    
                    if spanArr.count > 2 {
                        
                        let ageStr = try spanArr[2].text()
                        
                        for character in ageStr {
                            if character.asciiValue == nil {
                                age.append(" ")
                            } else {
                                age.append(character)
                            }
                        }
                        
                        age = String(age.split(separator: " ")[1].split(separator: ")")[0])
                        
                    }
                    
                    let club = try subElements.select("td")[5].text()
                    let player = Player(name: name, age: age, club: club)
                    USMNTgoalkeepers.append(player)
                    
                } else if (String(positionString[positionString.startIndex]) == "2") { // defenders
                    
                    var name = ""
                    
                    let aArr = try subElements.select("a")
                    if aArr.count > 1 {
                        name = try aArr[1].text()
                    }
                    
                    let spanArr = try subElements.select("td")[2].select("span")
                    var age = ""
                    
                    if spanArr.count > 2 {
                        
                        let ageStr = try spanArr[2].text()
                        
                        for character in ageStr {
                            if character.asciiValue == nil {
                                age.append(" ")
                            } else {
                                age.append(character)
                            }
                        }
                        
                        age = String(age.split(separator: " ")[1].split(separator: ")")[0])
                        
                    }
                    
                    let club = try subElements.select("td")[5].text()
                    let player = Player(name: name, age: age, club: club)
                    USMNTdefenders.append(player)
                    
                } else if (String(positionString[positionString.startIndex]) == "3") { // midfielders
                    
                    var name = ""
                    
                    let aArr = try subElements.select("a")
                    if aArr.count > 1 {
                        name = try aArr[1].text()
                    }
                    
                    let spanArr = try subElements.select("td")[2].select("span")
                    var age = ""
                    
                    if spanArr.count > 2 {
                        
                        let ageStr = try spanArr[2].text()
                        
                        for character in ageStr {
                            if character.asciiValue == nil {
                                age.append(" ")
                            } else {
                                age.append(character)
                            }
                        }
                        
                        age = String(age.split(separator: " ")[1].split(separator: ")")[0])
                        
                    }
                    
                    let club = try subElements.select("td")[5].text()
                    let player = Player(name: name, age: age, club: club)
                    USMNTmidfielders.append(player)
                    
                } else if (String(positionString[positionString.startIndex]) == "4") { // forwards
                    
                    var name = ""
                    
                    let aArr = try subElements.select("a")
                    if aArr.count > 1 {
                        name = try aArr[1].text()
                    }
                    
                    let spanArr = try subElements.select("td")[2].select("span")
                    var age = ""
                    
                    if spanArr.count > 2 {
                        
                        let ageStr = try spanArr[2].text()
                        
                        for character in ageStr {
                            if character.asciiValue == nil {
                                age.append(" ")
                            } else {
                                age.append(character)
                            }
                        }
                        
                        age = String(age.split(separator: " ")[1].split(separator: ")")[0])
                        
                    }
                    
                    let club = try subElements.select("td")[5].text()
                    let player = Player(name: name, age: age, club: club)
                    USMNTforwards.append(player)
                    
                }
                
            }
            
        } catch Exception.Error(let type, let message) {
            print(type)
            print(message)
        } catch {
            print("error")
        }
        
    }

    task.resume()
    
}

func scrapeU23RosterFromWikipedia() {
    
    U23goalkeepers = []
    U23defenders = []
    U23midfielders = []
    U23forwards = []
    
    let url = URL(string: "https://en.wikipedia.org/wiki/United_States_men%27s_national_under-23_soccer_team")!

    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        
        guard let data = data else { return }
        
        let htmlContent = String(data: data, encoding: .utf8)!
        
        do {
            
            let doc: Document = try SwiftSoup.parse(htmlContent)
            
            let elements: Elements = try doc.getElementsByClass("nat-fs-player")
            
            for subElements in elements {
                
                let positionString = try subElements.select("td").select("span").text()
                
                if (String(positionString[positionString.startIndex]) == "1") { // goalkeepers
                    
                    var name = ""
                    
                    let aArr = try subElements.select("a")
                    if aArr.count > 1 {
                        name = try aArr[1].text()
                    }
                    
                    let spanArr = try subElements.select("td")[2].select("span")
                    var age = ""
                    
                    if spanArr.count > 2 {
                        
                        let ageStr = try spanArr[2].text()
                        
                        for character in ageStr {
                            if character.asciiValue == nil {
                                age.append(" ")
                            } else {
                                age.append(character)
                            }
                        }
                        
                        age = String(age.split(separator: " ")[1].split(separator: ")")[0])
                        
                    }
                    
                    let club = try subElements.select("td")[5].text()
                    let player = Player(name: name, age: age, club: club)
                    U23goalkeepers.append(player)
                    
                } else if (String(positionString[positionString.startIndex]) == "2") { // defenders
                    
                    var name = ""
                    
                    let aArr = try subElements.select("a")
                    if aArr.count > 1 {
                        name = try aArr[1].text()
                    }
                    
                    let spanArr = try subElements.select("td")[2].select("span")
                    var age = ""
                    
                    if spanArr.count > 2 {
                        
                        let ageStr = try spanArr[2].text()
                        
                        for character in ageStr {
                            if character.asciiValue == nil {
                                age.append(" ")
                            } else {
                                age.append(character)
                            }
                        }
                        
                        age = String(age.split(separator: " ")[1].split(separator: ")")[0])
                        
                    }
                    
                    let club = try subElements.select("td")[5].text()
                    let player = Player(name: name, age: age, club: club)
                    U23defenders.append(player)
                    
                } else if (String(positionString[positionString.startIndex]) == "3") { // midfielders
                    
                    var name = ""
                    
                    let aArr = try subElements.select("a")
                    if aArr.count > 1 {
                        name = try aArr[1].text()
                    }
                    
                    let spanArr = try subElements.select("td")[2].select("span")
                    var age = ""
                    
                    if spanArr.count > 2 {
                        
                        let ageStr = try spanArr[2].text()
                        
                        for character in ageStr {
                            if character.asciiValue == nil {
                                age.append(" ")
                            } else {
                                age.append(character)
                            }
                        }
                        
                        age = String(age.split(separator: " ")[1].split(separator: ")")[0])
                        
                    }
                    
                    let club = try subElements.select("td")[5].text()
                    let player = Player(name: name, age: age, club: club)
                    U23midfielders.append(player)
                    
                } else if (String(positionString[positionString.startIndex]) == "4") { // forwards
                    
                    var name = ""
                    
                    let aArr = try subElements.select("a")
                    if aArr.count > 1 {
                        name = try aArr[1].text()
                    }
                    
                    let spanArr = try subElements.select("td")[2].select("span")
                    var age = ""
                    
                    if spanArr.count > 2 {
                        
                        let ageStr = try spanArr[2].text()
                        
                        for character in ageStr {
                            if character.asciiValue == nil {
                                age.append(" ")
                            } else {
                                age.append(character)
                            }
                        }
                        
                        age = String(age.split(separator: " ")[1].split(separator: ")")[0])
                        
                    }
                    
                    let club = try subElements.select("td")[5].text()
                    let player = Player(name: name, age: age, club: club)
                    U23forwards.append(player)
                    
                }
                
            }
            
        } catch Exception.Error(let type, let message) {
            print(type)
            print(message)
        } catch {
            print("error")
        }
        
    }

    task.resume()
    
}

func scrapeU20RosterFromWikipedia() {

    U20goalkeepers = []
    U20defenders = []
    U20midfielders = []
    U20forwards = []
    
    let url = URL(string: "https://en.wikipedia.org/wiki/United_States_men%27s_national_under-20_soccer_team")!

    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        
        guard let data = data else { return }
        
        let htmlContent = String(data: data, encoding: .utf8)!
        
        do {
            
            let doc: Document = try SwiftSoup.parse(htmlContent)
            
            let elements: Elements = try doc.getElementsByClass("nat-fs-player")
            
            for subElements in elements {
                
                let positionString = try subElements.select("td").select("span").text()
                
                if (String(positionString[positionString.startIndex]) == "1") { // goalkeepers
                    
                    var name = ""
                    
                    let aArr = try subElements.select("a")
                    if aArr.count > 1 {
                        name = try aArr[1].text()
                    }
                    
                    let spanArr = try subElements.select("td")[2].select("span")
                    var age = ""
                    
                    if spanArr.count > 2 {
                        
                        let ageStr = try spanArr[2].text()
                        
                        for character in ageStr {
                            if character.asciiValue == nil {
                                age.append(" ")
                            } else {
                                age.append(character)
                            }
                        }
                        
                        age = String(age.split(separator: " ")[1].split(separator: ")")[0])
                        
                    }
                    
                    let club = try subElements.select("td")[5].text()
                    let player = Player(name: name, age: age, club: club)
                    U20goalkeepers.append(player)
                    
                } else if (String(positionString[positionString.startIndex]) == "2") { // defenders
                    
                    var name = ""
                    
                    let aArr = try subElements.select("a")
                    if aArr.count > 1 {
                        name = try aArr[1].text()
                    }
                    
                    let spanArr = try subElements.select("td")[2].select("span")
                    var age = ""
                    
                    if spanArr.count > 2 {
                        
                        let ageStr = try spanArr[2].text()
                        
                        for character in ageStr {
                            if character.asciiValue == nil {
                                age.append(" ")
                            } else {
                                age.append(character)
                            }
                        }
                        
                        age = String(age.split(separator: " ")[1].split(separator: ")")[0])
                        
                    }
                    
                    let club = try subElements.select("td")[5].text()
                    let player = Player(name: name, age: age, club: club)
                    U20defenders.append(player)
                    
                } else if (String(positionString[positionString.startIndex]) == "3") { // midfielders
                    
                    var name = ""
                    
                    let aArr = try subElements.select("a")
                    if aArr.count > 1 {
                        name = try aArr[1].text()
                    }
                    
                    let spanArr = try subElements.select("td")[2].select("span")
                    var age = ""
                    
                    if spanArr.count > 2 {
                        
                        let ageStr = try spanArr[2].text()
                        
                        for character in ageStr {
                            if character.asciiValue == nil {
                                age.append(" ")
                            } else {
                                age.append(character)
                            }
                        }
                        
                        age = String(age.split(separator: " ")[1].split(separator: ")")[0])
                        
                    }
                    
                    let club = try subElements.select("td")[5].text()
                    let player = Player(name: name, age: age, club: club)
                    U20midfielders.append(player)
                    
                } else if (String(positionString[positionString.startIndex]) == "4") { // forwards
                    
                    var name = ""
                    
                    let aArr = try subElements.select("a")
                    if aArr.count > 1 {
                        name = try aArr[1].text()
                    }
                    
                    let spanArr = try subElements.select("td")[2].select("span")
                    var age = ""
                    
                    if spanArr.count > 2 {
                        
                        let ageStr = try spanArr[2].text()
                        
                        for character in ageStr {
                            if character.asciiValue == nil {
                                age.append(" ")
                            } else {
                                age.append(character)
                            }
                        }
                        
                        age = String(age.split(separator: " ")[1].split(separator: ")")[0])
                        
                    }
                    
                    let club = try subElements.select("td")[5].text()
                    let player = Player(name: name, age: age, club: club)
                    U20forwards.append(player)
                    
                }
                
            }
            
        } catch Exception.Error(let type, let message) {
            print(type)
            print(message)
        } catch {
            print("error")
        }
        
    }

    task.resume()
    
}

func scrapeU17RosterFromWikipedia() {

    U17goalkeepers = []
    U17defenders = []
    U17midfielders = []
    U17forwards = []
    
    let url = URL(string: "https://en.wikipedia.org/wiki/United_States_men%27s_national_under-17_soccer_team")!

    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        
        guard let data = data else { return }
        
        let htmlContent = String(data: data, encoding: .utf8)!
        
        do {
            
            let doc: Document = try SwiftSoup.parse(htmlContent)
            
            let elements: Elements = try doc.getElementsByClass("nat-fs-player")
            
            for subElements in elements {
                
                let positionString = try subElements.select("td").select("span").text()
                
                if (positionString.count > 0) {
                    
                    if (String(positionString[positionString.startIndex]) == "1") { // goalkeepers
                        
                        var name = ""
                        
                        let aArr = try subElements.select("a")
                        if aArr.count > 1 {
                            name = try aArr[1].text()
                        }
                        
                        let spanArr = try subElements.select("td")[2].select("span")
                        var age = ""
                        
                        if spanArr.count > 2 {
                            
                            let ageStr = try spanArr[2].text()
                            
                            for character in ageStr {
                                if character.asciiValue == nil {
                                    age.append(" ")
                                } else {
                                    age.append(character)
                                }
                            }
                            
                            age = String(age.split(separator: " ")[1].split(separator: ")")[0])
                            
                        }
                        
                        let club = try subElements.select("td")[5].text()
                        let player = Player(name: name, age: age, club: club)
                        U17goalkeepers.append(player)
                        
                    } else if (String(positionString[positionString.startIndex]) == "2") { // defenders
                        
                        var name = ""
                        
                        let aArr = try subElements.select("a")
                        if aArr.count > 1 {
                            name = try aArr[1].text()
                        }
                        
                        let spanArr = try subElements.select("td")[2].select("span")
                        var age = ""
                        
                        if spanArr.count > 2 {
                            
                            let ageStr = try spanArr[2].text()
                            
                            for character in ageStr {
                                if character.asciiValue == nil {
                                    age.append(" ")
                                } else {
                                    age.append(character)
                                }
                            }
                            
                            age = String(age.split(separator: " ")[1].split(separator: ")")[0])
                            
                        }
                        
                        let club = try subElements.select("td")[5].text()
                        let player = Player(name: name, age: age, club: club)
                        U17defenders.append(player)
                        
                    } else if (String(positionString[positionString.startIndex]) == "3") { // midfielders
                        
                        var name = ""
                        
                        let aArr = try subElements.select("a")
                        if aArr.count > 1 {
                            name = try aArr[1].text()
                        }
                        
                        let spanArr = try subElements.select("td")[2].select("span")
                        var age = ""
                        
                        if spanArr.count > 2 {
                            
                            let ageStr = try spanArr[2].text()
                            
                            for character in ageStr {
                                if character.asciiValue == nil {
                                    age.append(" ")
                                } else {
                                    age.append(character)
                                }
                            }
                            
                            age = String(age.split(separator: " ")[1].split(separator: ")")[0])
                            
                        }
                        
                        let club = try subElements.select("td")[5].text()
                        let player = Player(name: name, age: age, club: club)
                        U17midfielders.append(player)
                        
                    } else if (String(positionString[positionString.startIndex]) == "4") { // forwards
                        
                        var name = ""
                        
                        let aArr = try subElements.select("a")
                        if aArr.count > 1 {
                            name = try aArr[1].text()
                        }
                        
                        let spanArr = try subElements.select("td")[2].select("span")
                        var age = ""
                        
                        if spanArr.count > 2 {
                            
                            let ageStr = try spanArr[2].text()
                            
                            for character in ageStr {
                                if character.asciiValue == nil {
                                    age.append(" ")
                                } else {
                                    age.append(character)
                                }
                            }
                            
                            age = String(age.split(separator: " ")[1].split(separator: ")")[0])
                            
                        }
                        
                        let club = try subElements.select("td")[5].text()
                        let player = Player(name: name, age: age, club: club)
                        U17forwards.append(player)
                        
                    }
                    
                }
                
                
                
            }
            
        } catch Exception.Error(let type, let message) {
            print(type)
            print(message)
        } catch {
            print("error")
        }
        
    }

    task.resume()
    
}

func loadBlockedUsers() {
    
    if let user = Auth.auth().currentUser {
        
        // gather uids of user's blocked list
        
        Firestore.firestore().collection("Users").document(user.uid).collection("Blocked").getDocuments { (snap, err) in
            
            guard err == nil else {
                print(err?.localizedDescription ?? "")
                return
            }
            
            guard let snap = snap else {
                return
            }
            
            for document in snap.documents {
                blockedUIDs.append(document.documentID)
            }
            
        }
        
    }
    
}

