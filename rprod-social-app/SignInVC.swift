//
//  ViewController.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-01.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        view.addSubview(loginButton)
         */
       
    }

    override func viewDidAppear(_ animated: Bool) {
        // Segue should be performed here and not inside didappear because its not yet intilized
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "toFeedVC", sender: nil)
        }
    }
    
    func firebaseAuth(_ fireCredential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: fireCredential, completion: { (fireUser, error) in
            if error != nil {
                print("RASMUS: Unable to autenticate with Firebase - \(error)")
            } else {
                print("Rasmus: User Successfully autenticated with Firebase")
                
                if let fireUser = fireUser {
                    self.completeFirebaseSignIn(uid: fireUser.uid)
                }
            }
        })
    }
    
    
    func completeFirebaseSignIn(uid: String) {
       let keychainData = KeychainWrapper.standard.set(uid, forKey: KEY_UID)
        // Automatically Login with keychain setup
        print("RASMUS: UID Saved to Keychain \(keychainData)")
        
        performSegue(withIdentifier: "toFeedVC", sender: nil)
    }
    
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in

                if error == nil {
                    print("RASMUS: User Successfully signed in with Firebase")
                    if let user = user {
                        self.completeFirebaseSignIn(uid: user.uid)
                    }

                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                        
                        if error != nil {
                            print("RASMUS: Unable to autenticate with email and password using firebase - \(error)")
                        } else {
                            print("Rasmus: User Successfully Created")
                            if let user = user {
                                self.completeFirebaseSignIn(uid: user.uid)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("RASMUS: Unable to autenticate with facebook - \(error)")
            } else if result?.isCancelled == true {
                print("RASMUS: User cancelled Facebook autentication")
            } else {
                print("Rasmus: User Successfully autenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
            
            
        }
    }

}

