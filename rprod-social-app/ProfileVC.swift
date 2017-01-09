//
//  ProfileVC.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-03.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//
import UIKit
import Firebase

class ProfileVC:
UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numberOfPostsLabel: UILabel!    
    @IBOutlet weak var profileImage: DesignCornerView!
    @IBOutlet weak var navProfileImage: DesignCircleButton!
    @IBOutlet weak var addImage: DesignCircleButton!
    
    
    static var imageChache: NSCache<NSString, UIImage> = NSCache()

    var imagePicker: UIImagePickerController!
    var isLoggedInUser = false
    var profile: Profile!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        NavigationHelper.nav.initAuthedUserImageTo(uiButton: navProfileImage)

        
        updateUI()

        
        if let test = profile {
            print("INSIDE PROFILE PAGE")
            print(test.email)
        }
    }
    

    
    
    func updateUI() {

        
        // Check if its current logged in user or not
        // Disable add image button
        let authedUser = DataService.ds.REF_AUTHED_USER
        
        if profile.userKey == authedUser.key {
            self.isLoggedInUser = true
            print("AUTHED")
            addImage.isHidden = false
        } else {
            self.isLoggedInUser = false
            print("NOT AUTHED")
            addImage.isHidden = true
        }
        

        DataService.ds.setImageOf(imageUrl: profile.imageUrl, on: profileImage)

        
        
        // Setting up user data
        self.numberOfPostsLabel.text = "\(profile.numberOfPosts)"
        self.emailLabel.text = profile.email
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
          profileImage.image = image
          navProfileImage.setImage(image, for: .normal)
        }
        
        imagePicker.dismiss(animated: true) { 
            self.addImageToProfileStorage()
        }
    }
    
    
    func addImageToProfileStorage() {
        guard let image = profileImage.image else {
            print("MESSAGE: Image must be selected")
            return
        }
        

        // Save Profile Image to storage
        let profileStorageRef = DataService.ds.REF_PROFILE_IMAGES
        DataService.ds.saveImageToStorage(storageRef: profileStorageRef, image: image) { responseImageUrl in
            DataService.ds.REF_AUTHED_USER.updateChildValues([KEY_IMAGE_URL: responseImageUrl])
            DataService.imageChache.setObject(image, forKey: responseImageUrl as NSString)
        }
    }
    
    
    // Show the imagepicker to select an image
    @IBAction func addImageBtnTapped(_ sender: UIButton) {
        if isLoggedInUser {
            present(imagePicker, animated: true, completion: nil)
        }
    }

    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true) { 
            // call parent to update the image
        }
    }


}
