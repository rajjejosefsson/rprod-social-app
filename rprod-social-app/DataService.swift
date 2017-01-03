//
//  DataService.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-02.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import Foundation
import Firebase


let DB_ROOT = FIRDatabase.database().reference()
let STORAGE_ROOT = FIRStorage.storage().reference()

class DataService {
    // Creates the singleton
    static let ds = DataService()
    
    // Database reference
    private var _REF_POSTS = DB_ROOT.child("posts")
    private var _REF_USERS = DB_ROOT.child("users")
    
    // Storage reference
    private var _REF_POST_IMAGES = STORAGE_ROOT.child("post-images")
    
    
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_CURRENT_USER: FIRDatabaseReference {
       
        let uid = FIRAuth.auth()?.currentUser?.uid
        let user = REF_USERS.child(uid!)
      
        return user
    }
    
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
        // If uid doesn't exists already it will create one and pass its userData
        // Updates the values at the specified paths in the dictionary without overwriting other keys at this location.
    }
    
    
    
    
}
