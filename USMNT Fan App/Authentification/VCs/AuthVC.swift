//
//  SignUpVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 8/21/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController {
    
    let signInBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        btn.layer.cornerRadius = 2
        btn.setTitle("sign in", for: .normal)
        btn.titleLabel?.textColor = .white
        btn.titleLabel?.font = UIFont(name: "Avenir Medium", size: 15)
        btn.addTarget(self, action: #selector(signInBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    let switchToSignUpBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("don't have an account? sign up here", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir Medium", size: 15)
        btn.setTitleColor(#colorLiteral(red: 1, green: 0.6067909002, blue: 0.5591675639, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(switchToSignUpBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    let switchToResetBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("forgot password?", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir Medium", size: 15)
        btn.setTitleColor(#colorLiteral(red: 1, green: 0.6067909002, blue: 0.5591675639, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(switchToResetBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    let signInEmailTF: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont(name: "Avenir-Medium", size: 15)! // Note the !
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "email", attributes: attributes)
        tf.font = UIFont(name: "Avenir Medium", size: 15)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    let signInPasswordTF: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont(name: "Avenir-Medium", size: 15)! // Note the !
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "password", attributes: attributes)
        tf.font = UIFont(name: "Avenir Medium", size: 15)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let signInEmailUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let signInPasswordUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    
    
    
    
    
    let signUpBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        btn.layer.cornerRadius = 2
        btn.setTitle("sign up", for: .normal)
        btn.titleLabel?.textColor = .white
        btn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 15)
        btn.addTarget(self, action: #selector(signUpBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    let switchToSignInBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("already have an account? sign in here", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir Medium", size: 15)
        btn.setTitleColor(#colorLiteral(red: 1, green: 0.6067909002, blue: 0.5591675639, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(switchToSignInBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    let signUpProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    let signUpEmailTF: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont(name: "Avenir-Medium", size: 15)! // Note the !
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "email", attributes: attributes)
        tf.font = UIFont(name: "Avenir Medium", size: 15)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    let signUpUsernameTF: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont(name: "Avenir-Medium", size: 15)! // Note the !
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "username", attributes: attributes)
        tf.font = UIFont(name: "Avenir Medium", size: 15)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    let signUpPasswordTF: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont(name: "Avenir-Medium", size: 15)! // Note the !
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "password", attributes: attributes)
        tf.font = UIFont(name: "Avenir Medium", size: 15)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let signUpConfirmPasswordTF: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont(name: "Avenir-Medium", size: 15)! // Note the !
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "confirm password", attributes: attributes)
        tf.font = UIFont(name: "Avenir Medium", size: 15)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let signUpEmailUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let signUpUsernameUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let signUpPasswordUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let signUpConfirmPasswordUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    var selectedImage: UIImage?
    
    
    
    
    
    
    
    let resetEmailTF: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont(name: "Avenir-Medium", size: 15)! // Note the !
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "email", attributes: attributes)
        tf.font = UIFont(name: "Avenir Medium", size: 15)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    let resetBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        btn.layer.cornerRadius = 2
        btn.setTitle("request reset email", for: .normal)
        btn.titleLabel?.textColor = .white
        btn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 15)
        btn.addTarget(self, action: #selector(resetBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    let resetEmailUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSignInLayout()
        
    }
    
    func setupSignInLayout() {
        
        view.backgroundColor = .white
        addSignInSubviews()
        applySignInAnchors()
        
    }
    
    func addSignInSubviews() {
        
        view.addSubview(signInEmailTF)
        view.addSubview(signInPasswordTF)
        view.addSubview(signInBtn)
        view.addSubview(signInEmailUnderline)
        view.addSubview(signInPasswordUnderline)
        view.addSubview(switchToSignUpBtn)
        view.addSubview(switchToResetBtn)
        
    }
    
    func applySignInAnchors() {
        
        signInEmailTF.anchors(top: view.topAnchor, topPad: 150, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        signInPasswordTF.anchors(top: signInEmailTF.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        signInBtn.anchors(top: signInPasswordTF.bottomAnchor, topPad: 25, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        signInEmailUnderline.anchors(top: signInEmailTF.bottomAnchor, topPad: -7, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 222)
        
        signInPasswordUnderline.anchors(top: signInPasswordTF.bottomAnchor, topPad: -7, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 222)
        
        switchToResetBtn.anchors(top: signInBtn.bottomAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 222)
        
        switchToSignUpBtn.anchors(top: switchToResetBtn.bottomAnchor, topPad: -10, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 222)
        
    }
    
    @objc func backBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func signInBtnTapped() {
        
        guard let password = signInPasswordTF.text,
            password != "",
            let email = signInEmailTF.text,
            email != "" else {
                AlertController.showAlert(self, title: "Missing Info", message: "Please fill out all required fields")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            guard error == nil else {
                AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                return
            }
            
            guard user?.user.uid != nil else {
                AlertController.showAlert(self, title: "Error", message: "User does not exist")
                return
            }
            
            userHasChanged = true
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func switchToSignUpBtnTapped() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        setupSignUpLayout()
    }
    
    @objc func switchToResetBtnTapped() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        setupResetLayout()
    }
    
    
    
    
    
    // sign up functions
    
    
    
    
    
    func setupSignUpLayout() {
        
        view.backgroundColor = .white
        // add tap recognition to profile pic imageView
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AuthVC.handleSelectProfilePic))
        signUpProfileImageView.addGestureRecognizer(tapRecognizer)
        signUpProfileImageView.isUserInteractionEnabled = true
        
        addSignUpSubviews()
        applySignUpAnchors()
        
    }
    
    func addSignUpSubviews() {
        
        view.addSubview(signUpProfileImageView)
        view.addSubview(signUpEmailTF)
        view.addSubview(signUpUsernameTF)
        view.addSubview(signUpPasswordTF)
        view.addSubview(signUpConfirmPasswordTF)
        view.addSubview(signUpBtn)
        view.addSubview(signUpEmailUnderline)
        view.addSubview(signUpUsernameUnderline)
        view.addSubview(signUpPasswordUnderline)
        view.addSubview(signUpConfirmPasswordUnderline)
        view.addSubview(switchToSignInBtn)
        
    }
    
    func applySignUpAnchors() {
        
        signUpProfileImageView.anchors(top: view.topAnchor, topPad: 150, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 60, width: 60)
        
        signUpEmailTF.anchors(top: signUpProfileImageView.bottomAnchor, topPad: 20, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        signUpUsernameTF.anchors(top: signUpEmailTF.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        signUpPasswordTF.anchors(top: signUpUsernameTF.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        signUpConfirmPasswordTF.anchors(top: signUpPasswordTF.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        signUpBtn.anchors(top: signUpConfirmPasswordTF.bottomAnchor, topPad: 25, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        signUpEmailUnderline.anchors(top: signUpEmailTF.bottomAnchor, topPad: -7, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 222)
        
        signUpUsernameUnderline.anchors(top: signUpUsernameTF.bottomAnchor, topPad: -7, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 222)
        
        signUpPasswordUnderline.anchors(top: signUpPasswordTF.bottomAnchor, topPad: -7, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 222)
        
        signUpConfirmPasswordUnderline.anchors(top: signUpConfirmPasswordTF.bottomAnchor, topPad: -7, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 222)
        
        switchToSignInBtn.anchors(top: signUpBtn.bottomAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 222)
        
    }
    
    @objc func signUpBtnTapped(_ sender: Any) {
        
        guard let email = signUpEmailTF.text,
            email != "",
            let username = signUpUsernameTF.text,
            username != "",
            let password = signUpPasswordTF.text,
            password != "",
            let confirmPassword = signUpConfirmPasswordTF.text,
            confirmPassword != ""
            else {
                AlertController.showAlert(self, title: "Missing Info", message: "Please fill out all fields correctly")
                return
        }
        
        if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // string doesn't contain non-whitespace characters
            AlertController.showAlert(self, title: "Error", message: "username must contain non-whitespace characters")
            return
        }
        
        guard let passwordRequirement = self.signUpPasswordTF.text,
            passwordRequirement.count >= 6
            else    {
                AlertController.showAlert(self, title: "Error", message: "Password must be more than 6 characters")
                return
        }
        
        guard let passwordVerification = self.signUpPasswordTF.text,
            passwordVerification == self.signUpConfirmPasswordTF.text
            else    {
                AlertController.showAlert(self, title: "Error", message: "Password and Confirm Password must be the same")
                return
        }
        
        Firestore.firestore().collection("Users").getDocuments { (snap, err) in
            
            for document in snap!.documents {
                
                let takenUsername = document.data()["username"] as! String
                
                if (takenUsername == self.signUpUsernameTF.text) {
                    AlertController.showAlert(self, title: "Error", message: "Username taken")
                    return
                }
                
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                
                guard error == nil else {
                    AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                    print ("Error: \(error!.localizedDescription)")
                    return
                }
                
                let changeRequest = user?.user.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges { (error) in
                    guard error == nil else {
                        AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                        return
                    }
                }
                
                userHasChanged = true
                
                let uid = user!.user.uid
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
                                
                                let userData: [String : Any] = ["profilePicURL" : profilePicURL.absoluteString,
                                                                 "username" : username,
                                                                 "email" : email]
                                Firestore.firestore().collection("Users").document(uid).setData(userData)
                            }
                            
                        })
                        
                    })
                    
                } else {
                    
                    let userData: [String : Any] = ["profilePicURL" : "",
                                                     "username" : username,
                                                     "email" : email]
                    Firestore.firestore().collection("Users").document((user?.user.uid)!).setData(userData)
                    
                }
                
            }
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func handleSelectProfilePic() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @objc func switchToSignInBtnTapped() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        setupSignInLayout()
    }
    
    
    
    
    
    // reset password functions
    
    
    
    
    
    
    func setupResetLayout() {
        
        view.backgroundColor = .white
        addResetSubviews()
        applyResetAnchors()
        
    }
    
    @objc func resetBtnTapped() {
        
        Auth.auth().sendPasswordReset(withEmail: (resetEmailTF.text)!) { (error) in
            if error != nil {
                AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
            } else {
                AlertController.showAlert(self, title: "Success", message: "an email has been sent this address")
                self.resetEmailTF.text = ""
            }
        }
        
    }
    
    func addResetSubviews() {
        
        view.addSubview(resetEmailTF)
        view.addSubview(resetBtn)
        view.addSubview(resetEmailUnderline)
        view.addSubview(switchToSignInBtn)
        
    }
    
    func applyResetAnchors() {
        
        resetEmailTF.anchors(top: view.topAnchor, topPad: 150, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        resetEmailUnderline.anchors(top: resetEmailTF.bottomAnchor, topPad: -7, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 222)
        
        resetBtn.anchors(top: resetEmailTF.bottomAnchor, topPad: 25, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        switchToSignInBtn.anchors(top: resetBtn.bottomAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 222)
        
    }
    
    

}

extension AuthVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            signUpProfileImageView.image = image
            selectedImage = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
