//
//  NavigationHelper.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-08.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import UIKit
import Firebase

class NavigationHelper {

   static let nav = NavigationHelper()
    
    
    
    // Sets Navigation Profile image
    let currentUser = DataService.ds.REF_AUTHED_USER
    var profile = Profile()

 
    func initAuthedUserImageTo(uiButton: UIButton) {
       
        // Check if profile image is chached else load it from db
        if let image = DataService.imageChache.object(forKey: currentUser.key as NSString) {
           uiButton.setImage(image, for: .normal)
        } else {
            DataService.ds.currentUserImage(userRef: currentUser, completed: {
              uiButton.setImage(DataService.ds.profileImage, for: .normal)
            })
        }
    }
    
    
    
    
    
    

    
    

}
