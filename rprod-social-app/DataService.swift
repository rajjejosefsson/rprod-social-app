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

class DataService {

    static let ds = DataService()
    
    private var _REF_POSTS = DB_ROOT.child("posts")
    private var _REF_USERS = DB_ROOT.child("users")
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
        // If uid doesn't exists already it will create one and pass its userData
        // Updates the values at the specified paths in the dictionary without overwriting other keys at this location.
    }
    
    
    
    
}
