//
//  SettingsVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 12/26/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    var selectedImage: UIImage?
    
    let profileLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Your Profile"
        lbl.font = UIFont(name: "Avenir-Medium", size: 20)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    let usernameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Username"
        lbl.font = UIFont(name: "Avenir-Book", size: 15)
        lbl.textColor = .white
        return lbl
    }()
    
    let usernameTF: UITextField = {
        let tf = UITextField()
        tf.text = "\(Auth.auth().currentUser?.displayName ?? "")"
        tf.borderStyle = .roundedRect
        tf.font = UIFont(name: "Avenir-Book", size: 15)
        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return tf
    }()
    
    let confirmUsernameBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "Check"), for: .normal)
        btn.addTarget(self, action: #selector(confirmUsername), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    let confirmImageBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "Check"), for: .normal)
        btn.addTarget(self, action: #selector(confirmImage), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    let logOutBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        btn.titleLabel?.font = UIFont(name: "Avenir-Book", size: 15)
        btn.setTitle("log out", for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        return btn
    }()
    
    let termsBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont(name: "Avenir-Book", size: 15)
        btn.setTitle("terms", for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        return btn
    }()
    
    let privacyBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont(name: "Avenir-Book", size: 15)
        btn.setTitle("privacy", for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
    }
    
    func setupLayout() {
        
        view.backgroundColor = #colorLiteral(red: 0.9803355336, green: 0.4550145268, blue: 0.4421662986, alpha: 1)
        
        setUserProfileImage()
        addSubviews()
        applyAnchors()
        
        // add picker ability to imageview
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsVC.handleSelectProfilePic))
        profileImageView.addGestureRecognizer(tapRecognizer)
        profileImageView.isUserInteractionEnabled = true
        
    }
    
    func addSubviews() {
        
        view.addSubview(profileLbl)
        view.addSubview(profileImageView)
        view.addSubview(usernameLbl)
        view.addSubview(usernameTF)
        view.addSubview(logOutBtn)
        view.addSubview(termsBtn)
        view.addSubview(privacyBtn)
        view.addSubview(confirmImageBtn)
        view.addSubview(confirmUsernameBtn)

        
    }
    
    func applyAnchors() {
        
        profileLbl.anchors(top: view.topAnchor, topPad: 100, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 70, right: view.rightAnchor, rightPad: -70, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        profileImageView.anchors(top: profileLbl.bottomAnchor, topPad: 30, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: profileLbl.centerXAnchor, centerXPad: 0, centerY:  nil, centerYPad: 0, height: 60, width: 60)
        
        usernameLbl.anchors(top: profileImageView.bottomAnchor, topPad: 30, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 70, right: view.rightAnchor, rightPad: -70, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        usernameTF.anchors(top: usernameLbl.bottomAnchor, topPad: 5, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 70, right: view.rightAnchor, rightPad: -70, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        logOutBtn.anchors(top: usernameTF.bottomAnchor, topPad: 20, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 70, right: view.rightAnchor, rightPad: -70, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        termsBtn.anchors(top: logOutBtn.bottomAnchor, topPad: 20, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 70, right: view.rightAnchor, rightPad: -70, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        privacyBtn.anchors(top: termsBtn.bottomAnchor, topPad: 20, bottom: nil, bottomPad: 0, left: view.leftAnchor, leftPad: 70, right: view.rightAnchor, rightPad: -70, centerX: nil, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 0)
        
        confirmImageBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: profileImageView.rightAnchor, leftPad: 10, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: profileImageView.centerYAnchor, centerYPad: 0, height: 30, width: 30)
        
        confirmUsernameBtn.anchors(top: nil, topPad: 0, bottom: nil, bottomPad: 0, left: usernameTF.rightAnchor, leftPad: 10, right: nil, rightPad: 0, centerX: nil, centerXPad: 0, centerY: usernameTF.centerYAnchor, centerYPad: 0, height: 30, width: 30)
        
    }
    
    @objc func backBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func setUserProfileImage() {
        
        if let uid = Auth.auth().currentUser?.uid {
            let storageRef = Storage.storage().reference(forURL: "gs://usmnt-fan-app.appspot.com").child("profile_image").child(uid)
            
            let imageURL = storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                
                if let error = error {
                    print("Error: \(error)")
                } else {
                    self.profileImageView.image = UIImage(data: data!)!
                }
            }
        }
    }
    
    @objc func confirmUsername() {
        
        // search firestore to see if username is taken
        
        Firestore.firestore().collection("Users").getDocuments { (snap, err) in
            
            for document in snap!.documents {
                
                let takenUsername = document.data()["username"] as! String
                
                if (takenUsername == self.usernameTF.text) {
                    AlertController.showAlert(self, title: "Error", message: "Username taken")
                    return
                }
                
            }
            
            let user = Auth.auth().currentUser
            let uid = Auth.auth().currentUser!.uid
            let newUsername = self.usernameTF.text
            
            let changeRequest = user!.createProfileChangeRequest()
            changeRequest.displayName = newUsername
            changeRequest.commitChanges { (error) in
                guard error == nil else {
                    AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                    return
                }
            }
            
            Firestore.firestore().collection("Users").document(uid).updateData(["username" : newUsername!])
            
        }
        
        confirmUsernameBtn.isHidden = true
        
    }
    
    @objc func confirmImage() {
        
        let uid = Auth.auth().currentUser!.uid
        let storageRef = Storage.storage().reference(forURL: "gs://usmnt-fan-app.appspot.com").child("profile_image").child(uid)
        
        if let profileImage = self.selectedImage, let imageData = profileImage.jpegData(compressionQuality: 0.1) {
            
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("error")
                    return
                }
                
                metadata?.storageReference?.downloadURL(completion: { (url, error) in
                    
                    if error != nil {
                        print("error")
                        return
                    }
                    
                    if let profilePicURL = url {
                        
                        Firestore.firestore().collection("Users").document(uid).updateData(["profilePicURL" : profilePicURL])
                    }
                    
                })
                
            })
            
        } else {
            
            AlertController.showAlert(self, title: "Error", message: "Could not update profile picture")
            
        }
        
        confirmImageBtn.isHidden = true
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let currentUsername = Auth.auth().currentUser?.displayName
        
        if (currentUsername != usernameTF.text) {
            confirmUsernameBtn.isHidden = false
        } else {
            confirmUsernameBtn.isHidden = true
        }
        
    }
    
    @objc func handleSelectProfilePic() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        confirmImageBtn.isHidden = false
    }
    
    @objc func logOut() {
        presentLogOutAlert(title: "Just Checking", message: "Are you sure you want to log out?")
    }
    
    func presentLogOutAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            // take user back to home
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}

extension SettingsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
            selectedImage = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
