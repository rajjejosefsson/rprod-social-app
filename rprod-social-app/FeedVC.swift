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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAddButton: DesignCornerButton!
    
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    
    static var imageChache: NSCache<NSString, UIImage> = NSCache()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    
        
        // init the listener as fast as posible, this is the place
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
  
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {

                self.posts = []

                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                    
                        let key = snap.key // key of the snapshot
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
    
      
        let post = posts[indexPath.row]
        print("TABLEPOST: \(post.text) \n")
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            
            if let image = FeedVC.imageChache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, image: image)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
            
         
        } else {
            return UITableViewCell()
        }
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageAddButton.setImage(image, for: .normal)
            
        } else {
            print("RASMUS: A valid image wasn't selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageBtnTapped(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    

    @IBAction func signoutBtnTapped(_ sender: UIButton) {
        
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
