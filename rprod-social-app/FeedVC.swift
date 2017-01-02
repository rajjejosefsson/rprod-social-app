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
    UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAddButton: DesignCornerButton!
    @IBOutlet weak var textField: UITextField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    static var imageChache: NSCache<NSString, UIImage> = NSCache()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    
        
        // init the listener as fast as posible, this is the place
        DataService.ds.REF_POSTS.queryOrdered(byChild: KEY_POSTDATE).observe(.value, with: { (snapshot) in
  
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
            
        
            self.posts.reverse()
            self.tableView.reloadData()
        })
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let post = posts[indexPath.row]
        
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
        // info could be video etc
            
            imageAddButton.setImage(image, for: .normal)
            imageSelected = true
        } else {
            print("RASMUS: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addImageBtnTapped(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func postBtnTapped(_ sender: UIButton) {
        
        guard let text = textField.text, text != "" else {
            print("RASMUS: Text must be entered")
            return
        }
        
        guard let image = imageAddButton.image(for: .normal), imageSelected == true else {
            print("RASMUS: Image must be selected")
            return
        }
        
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            let imageUID = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"

            DataService.ds.REF_POST_IMAGES.child(imageUID).put(imageData, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print("RASMUS: Unable to upload image to firebase storage")
                } else {
                    print("RASMUS: Image Uploaded to firebase storage")
                    
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    
                    if let url = downloadURL {
                        self.postToFirebase(imageUrl: url)
                    }
                    
                    
                }
            })
        }
    }
    
    func postToFirebase(imageUrl: String) {
     
        let post: Dictionary<String, AnyObject> = [
            KEY_TEXT: textField.text as AnyObject,
            KEY_IMAGEURL: imageUrl as AnyObject,
            KEY_LIKES: 0 as AnyObject,
            KEY_POSTDATE: FIRServerValue.timestamp() as? [String : Any] as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        imageSelected = false
        textField.text = ""
        imageAddButton.setImage(UIImage(named: "add-image"), for: .normal)

        
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
