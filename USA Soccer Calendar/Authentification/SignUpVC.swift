//
//  SignUpVC.swift
//  USA Soccer Calendar
//
//  Created by Leon Djusberg on 8/29/19.
//  Copyright © 2019 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SignUpVC: UIViewController {
    
    // only allow certain characters in username
    
    let signUpBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        btn.layer.cornerRadius = 2
        btn.setTitle("Sign Up", for: .normal)
        btn.titleLabel?.textColor = .white
        btn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 15)
        btn.addTarget(self, action: #selector(signUpBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    let signInBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("already have an account? sign in here", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir Medium", size: 15)
        btn.setTitleColor(#colorLiteral(red: 1, green: 0.6067909002, blue: 0.5591675639, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(signInBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    let emailTF: UITextField = {
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
    
    let usernameTF: UITextField = {
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
    
    let passwordTF: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont(name: "Avenir-Medium", size: 15)! // Note the !
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "password", attributes: attributes)
        tf.font = UIFont(name: "Avenir Medium", size: 15)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    let confirmPasswordTF: UITextField = {
        let tf = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont(name: "Avenir-Medium", size: 15)! // Note the !
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "confirm password", attributes: attributes)
        tf.font = UIFont(name: "Avenir Medium", size: 15)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    let emailUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let usernameUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let passwordUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let confirmPasswordUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
    }
    
    func setupLayout() {
        
        view.backgroundColor = .white
        
        // add tap recognition to profile pic imageView
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.handleSelectProfilePic))
        profileImageView.addGestureRecognizer(tapRecognizer)
        profileImageView.isUserInteractionEnabled = true
        
        addSubviews()
        applyAnchors()
        
    }
    
    func addSubviews() {
        
        view.addSubview(profileImageView)
        view.addSubview(emailTF)
        view.addSubview(usernameTF)
        view.addSubview(passwordTF)
        view.addSubview(confirmPasswordTF)
        view.addSubview(signUpBtn)
        view.addSubview(emailUnderline)
        view.addSubview(usernameUnderline)
        view.addSubview(passwordUnderline)
        view.addSubview(confirmPasswordUnderline)
        view.addSubview(signInBtn)
        
    }
    
    func applyAnchors() {
        
        profileImageView.anchors(top: view.topAnchor, topPad: 250, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 60, width: 60)
        
        emailTF.anchors(top: profileImageView.bottomAnchor, topPad: 20, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        usernameTF.anchors(top: emailTF.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        passwordTF.anchors(top: usernameTF.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        confirmPasswordTF.anchors(top: passwordTF.bottomAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        signUpBtn.anchors(top: confirmPasswordTF.bottomAnchor, topPad: 25, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 40, width: 222)
        
        emailUnderline.anchors(top: emailTF.bottomAnchor, topPad: -7, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 222)
        
        usernameUnderline.anchors(top: usernameTF.bottomAnchor, topPad: -7, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 222)
        
        passwordUnderline.anchors(top: passwordTF.bottomAnchor, topPad: -7, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 222)
        
        confirmPasswordUnderline.anchors(top: confirmPasswordTF.bottomAnchor, topPad: -7, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 1, width: 222)
        
        signInBtn.anchors(top: signUpBtn.bottomAnchor, topPad: 0, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, centerX: view.centerXAnchor, centerXPad: 0, centerY: nil, centerYPad: 0, height: 0, width: 222)
        
    }
    
    @objc func signUpBtnTapped(_ sender: Any) {
        
        guard let email = emailTF.text,
            email != "",
            let username = usernameTF.text,
            username != "",
            let password = passwordTF.text,
            password != "",
            let confirmPassword = confirmPasswordTF.text,
            confirmPassword != ""
            else {
                AlertController.showAlert(self, title: "Missing Info", message: "Please fill out all fields correctly")
                return
        }
        
        guard let passwordRequirement = self.passwordTF.text,
            passwordRequirement.count >= 6
            else    {
                AlertController.showAlert(self, title: "Error", message: "Password must be more than 6 characters")
                return
        }
        
        guard let passwordVerification = self.passwordTF.text,
            passwordVerification == self.confirmPasswordTF.text
            else    {
                AlertController.showAlert(self, title: "Error", message: "Password and Confirm Password must be the same")
                return
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
            
            
            let uid = user?.user.uid
            let storageRef = Storage.storage().reference(forURL: "gs://usmnt-fan-app.appspot.com").child("profile_image").child(uid!)
            
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
                            Firestore.firestore().collection("Users").document((user?.user.uid)!).setData(userData)
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
        
        // figure out where to send user
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func handleSelectProfilePic() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @objc func signInBtnTapped() {
        let signInVC = SignInVC()
        navigationController?.pushViewController(signInVC, animated: true)
    }

}

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
            selectedImage = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
