//
//  Profile.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-04.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import Foundation
import Firebase

class Profile {

    private var _userKey: String!
    private var _email: String!
    private var _provider: String!
    private var _numberOfPosts: Int!
    private var _imageUrl: String!
    private var _userRef: FIRDatabaseReference!
 
    
    var userKey: String {
        return _userKey
    }
    
    var email: String {
        return _email
    }
    
    var provider: String {
        return _provider
    }
    
    var numberOfPosts: Int {
        return _numberOfPosts
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    

    
    
    
    init() {
    }
   
    
    
    init(email: String, numberOfPosts: Int, userKey: String, imageUrl: String) {
        self._email = email
        self._numberOfPosts = numberOfPosts
        self._userKey = userKey
        self._imageUrl = imageUrl
    }
    
    
    
    
    
    
    
    
    // Not used yet
    init(userKey: String, profileData: Dictionary<String, AnyObject>) {
        self._userKey = userKey
        
        
        if let email = profileData[KEY_EMAIL] as? String {
            self._email = email
        }
        
        if let numberOfPosts = profileData[KEY_NUMBER_OF_POSTS] as? Int {
            self._numberOfPosts = numberOfPosts
        }
        
        if let imageUrl = profileData[KEY_IMAGE_URL] as? String {
            self._imageUrl = imageUrl
        }
        
        
        self._userRef = DataService.ds.REF_AUTHED_USER
    }
    

    
    
    
    
    

}
