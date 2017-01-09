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
    
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_AUTHED_USER: FIRDatabaseReference {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let user = REF_USERS.child(uid!)
        
        return user
    }
    
    
    
    // Storage reference
    private var _REF_POST_IMAGES = STORAGE_ROOT.child("post-images")
    private var _REF_PROFILE_IMAGES = STORAGE_ROOT.child("profile-images")
    
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    var REF_PROFILE_IMAGES: FIRStorageReference {
        return _REF_PROFILE_IMAGES
    }
    

    
    
    
   
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
        // If uid doesn't exists already it will create one and pass its userData
        // Updates the values at the specified paths in the dictionary without overwriting other keys at this location.
    }
    
    
    
    func updateUserPostCount() {
        
        let currentUser =  DataService.ds.REF_AUTHED_USER;
        
        DataService.ds.REF_AUTHED_USER.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            var numberOfPosts = value?["numberOfPosts"] as? Int ?? 0
            
            numberOfPosts = numberOfPosts + 1
            
            currentUser.updateChildValues(["numberOfPosts": numberOfPosts])
        })
        
    }
    
    
   
    
    
    
    // Insert an image to Firebase Storage
    // Takes an image
    // and reference to the Firebase Storage where the image should be inserted
    // returns the url of the location of the image in the Firebase Storage
    func saveImageToStorage(storageRef: FIRStorageReference, image: UIImage, completed: @escaping (_ DownloadComplete: String) -> Void ) {
        var url = ""
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            let imageUID = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            storageRef.child(imageUID).put(imageData, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print("MESSAGE: Unable to upload image to firebase storage")
                } else {
                    print("MESSAGE: Image Uploaded to firebase storage")
                    
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    
                    if let imageUrl = downloadURL {
                       url = imageUrl
                    }
                }
                completed(url)
            })
        }
    }
    
  
    
    
    static var imageChache: NSCache<NSString, UIImage> = NSCache()
    var profileImage = UIImage()
    
    
    func currentUserImage(userRef: FIRDatabaseReference ,completed: @escaping DownloadComplete) {
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let value = snapshot.value as? NSDictionary
            
            if let imageUrl = value?["imageUrl"] as? String  {
                let imageRef = FIRStorage.storage().reference(forURL: imageUrl)
                imageRef.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    // Asynchronously downloads the object at the FIRStorageReference to an NSData object in memory
                    if error != nil {
                        print("RASMUS: Unable to download image from Firebase Storage, size limit 2mb, more info \(error.debugDescription)")
                    } else {
                        print("RASMUS: Image downloaded from Firebase Storage")
                        if let imageData = data {
                            if let image = UIImage(data: imageData) {
                                print("RASMUS: FOUND IMAGE")
                                self.profileImage = image
                                DataService.imageChache.setObject(image, forKey: userRef.key as NSString)
                            }
                        }
                    }
                    completed()
                })
            }
        })
    }
    
    
    
    
    func getUserImageOf(imageUrl: String, completed: @escaping (_ DownloadComplete: UIImage) -> Void ) {
       
    
                var profileImage = UIImage()
    
                let imageRef = FIRStorage.storage().reference(forURL: imageUrl)
                imageRef.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    // Asynchronously downloads the object at the FIRStorageReference to an NSData object in memory
                    if error != nil {
                        print("RASMUS: Unable to download image from Firebase Storage, size limit 2mb, more info \(error.debugDescription)")
                    } else {
                        print("RASMUS: Image downloaded from Firebase Storage")
                        if let imageData = data {
                            if let image = UIImage(data: imageData) {
                                print("RASMUS: FOUND IMAGE")
                                profileImage = image
                                DataService.imageChache.setObject(image, forKey: imageUrl as NSString)
                            }
                        }
                    }
                    completed(profileImage)
                })
     }
    
    
    
    
    func setImageOf(imageUrl: String, on imageView: UIImageView) {
        
        
        if let image = DataService.imageChache.object(forKey: imageUrl as NSString) {
            // Chached
            imageView.image = image
        } else {
            // Not Cached
            if imageUrl != "" {
                DataService.ds.getUserImageOf(imageUrl: imageUrl, completed: { (image) in
                    imageView.image = image
                })
            }
            
         
        }
    }
    
    
    func setImageOf(imageUrl: String, on uiButton: UIButton) {
        if let image = DataService.imageChache.object(forKey: imageUrl as NSString) {
            // Chached
            uiButton.setImage(image, for: .normal)
        } else {
            // Not Cached
            DataService.ds.getUserImageOf(imageUrl: imageUrl, completed: { (image) in
               uiButton.setImage(image, for: .normal)
            })
        }
    }
    
    
    
    
    // Returns a profile of the authed user
    func getAuthedProfile(completed: @escaping (_ DownloadComplete: Profile) -> Void ) {
    
        var profile = Profile()
        
        let profileRef = DataService.ds.REF_AUTHED_USER
        
        let selectedUser = DataService.ds.REF_USERS.child(profileRef.key)
        selectedUser.observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let email = value[KEY_EMAIL] as? String ?? ""
                let numberOfPosts = value[KEY_NUMBER_OF_POSTS] as? Int ?? 0
                let imageUrl = value[KEY_IMAGE_URL] as? String ?? ""
                
                // Load Profile
                profile = Profile.init(email: email, numberOfPosts: numberOfPosts, userKey: selectedUser.key, imageUrl: imageUrl)
            }
            completed(profile)
        })
    }
    
    
    
    
    
    
    
    func getTappedProfile(profile: FIRDatabaseReference, completed: @escaping (_ DownloadComplete: Profile) -> Void ) {
        
        var tappedProfile = Profile()
        let selectedUser = DataService.ds.REF_USERS.child(profile.key)
        
        selectedUser.observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let email = value[KEY_EMAIL] as? String ?? ""
                let numberOfPosts = value[KEY_NUMBER_OF_POSTS] as? Int ?? 0
                let imageUrl = value[KEY_IMAGE_URL] as? String ?? ""
                
                // Load Profile
                tappedProfile = Profile.init(email: email, numberOfPosts: numberOfPosts, userKey: selectedUser.key, imageUrl: imageUrl)
            }
            completed(tappedProfile)
        })
    }

    
    
}
