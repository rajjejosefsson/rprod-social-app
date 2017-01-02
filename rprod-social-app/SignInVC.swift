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

class SignInVC: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
 
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    
    func firebaseAuth(_ fireCredential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: fireCredential, completion: { (fireUser, error) in
            if error != nil {
                print("RASMUS: Unable to autenticate with Firebase - \(error)")
            } else {
                print("Rasmus: User Successfully autenticated with Firebase")
            }
        })
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

    
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in

                if error == nil {
                    print("RASMUS: User Successfully signed in with Firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                        
                        if error != nil {
                            print("RASMUS: Unable to autenticate with email and password using firebase - \(error)")
                        } else {
                            print("Rasmus: User Successfully Created")
                        }
                    }
                }
            }
        }
        
    }
    

}

