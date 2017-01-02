//
//  FeedVC.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-02.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    

    @IBAction func signoutBtnTapped(_ sender: Any) {
        
        let keychain = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("RASMUS: Removed UID from keychain: \(keychain)")
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            print("RASMUS: Successfully signed out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
        dismiss(animated: true, completion: nil)
    }

}
