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

class FeedVC:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate, MyCellDelegate
{
    @IBOutlet weak var navProfileImage: DesignCircleButton!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var imageAddButton: DesignCornerShadowButton!
    
    @IBOutlet weak var textField: UITextField!
    
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    static var imageChache: NSCache<NSString, UIImage> = NSCache()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        NavigationHelper.nav.initAuthedUserImageTo(uiButton: navProfileImage)

        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        
        // Load all data into an array of posts
        DataService.ds.REF_POSTS.queryOrdered(byChild: KEY_POST_DATE).observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                self.posts = []
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key // key of the snapshot
                        
                        // Init of the post to get key value pair
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.posts.reverse()
            self.tableView.reloadData()
        })
        
    
        
    
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let image = FeedVC.imageChache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, image: image)
            } else {
                cell.configureCell(post: post)
            }
            
            cell.delegate = self
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
        // info could be video etc
            imageAddButton.setImage(image, for: .normal)
            imageSelected = true
        } else {
            print("MESSAGE: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func addImageBtnTapped(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func postBtnTapped(_ sender: UIButton) {
        
        guard let text = textField.text, text != "" else {
            print("MESSAGE: Text must be entered")
            return
        }
        
        guard let image = imageAddButton.image(for: .normal), imageSelected == true else {
            print("MESSAGE: Image must be selected")
            return
        }
        
        
        let postsStorageRef = DataService.ds.REF_POST_IMAGES
        
        DataService.ds.saveImageToStorage(storageRef: postsStorageRef ,image: image) { responseUrl in
           self.postToFirebase(imageUrl: responseUrl)
        }
    }
    
    
    func postToFirebase(imageUrl: String) {
        
        let post: Dictionary<String, AnyObject> = [
            KEY_TEXT: textField.text as AnyObject,
            KEY_IMAGE_URL: imageUrl as AnyObject,
            KEY_LIKES: 0 as AnyObject,
            KEY_USER_ID: DataService.ds.REF_AUTHED_USER.key as AnyObject,
            KEY_POST_DATE: FIRServerValue.timestamp() as? [String : Any] as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        // Generates a auto id for key
        firebasePost.setValue(post)
        
        DataService.ds.updateUserPostCount()
        
        // Reset addButton UI values
        imageSelected = false
        textField.text = ""
        imageAddButton.setImage(UIImage(named: "add-image"), for: .normal)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desitnation = segue.destination as? ProfileVC {
            if let profile = sender as? Profile {
                desitnation.profile = profile
            }
        }
    }
    
    
    
    

  
    
    @IBAction func navProfileImageTapped(_ sender: DesignCircleButton) {
        DataService.ds.getAuthedProfile { (profile) in
            self.performSegue(withIdentifier: "ProfileVC", sender: profile)
        }
    }

    
  

    
    // Custom Delegate for getting tapped cell
    func didTapUser(tappedProfileId: String) {
        
        let user = DataService.ds.REF_USERS.child(tappedProfileId)
        
        DataService.ds.getTappedProfile(profile: user) { (profile) in
            // When we have the profile go to Profile VC
            print("performSegue user: \(user)")
            self.performSegue(withIdentifier: "ProfileVC", sender: profile)
        }
    }
    
    
    
    @IBAction func signoutBtnTapped(_ sender: UIButton) {
        
        let keychain = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("MESSAGE: Removed UID from keychain: \(keychain)")
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            print("MESSAGE: Successfully signed out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    

}


protocol MyCellDelegate {
    func didTapUser(tappedProfileId: String)
}
