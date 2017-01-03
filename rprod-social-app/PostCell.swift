//
//  PostCell.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-02.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImage: DesignCircleView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var postedText: UITextView!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!

    var post: Post!
    
    
    var currentUserLikesRef: FIRDatabaseReference!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
    }
    
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post

        self.postedText.text = post.text
        self.numberOfLikesLabel.text = "\(post.numberOfLikes)"
        
        // Setup the image in cell
        if image != nil {
            self.postedImage.image = image
            // image is chaced
        } else {
            
            let imageRef = FIRStorage.storage().reference(forURL: post.imageUrl)
            
            imageRef.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                // Asynchronously downloads the object at the FIRStorageReference to an NSData object in memory
                if error != nil {
                    print("RASMUS: Unable to download image from Firebase Storage, size limit 2mb, more info \(error.debugDescription)")
                } else {
                    print("RASMUS: Image downloaded from Firebase Storage")
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                           
                            self.postedImage.image = image
                            FeedVC.imageChache.setObject(image, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        
        
        // Gets the users email aderss and uses that as username label
        DataService.ds.REF_USERS.child(post.userId).observeSingleEvent(of: .value, with: { (snapshot) in
           
            let value = snapshot.value as? NSDictionary
            let email = value?["email"] as? String ?? ""
            self.usernameLabel.text = email
        })

        
        
        currentUserLikesRef = DataService.ds.REF_CURRENT_USER.child(KEY_LIKES).child(post.postKey)
    
        currentUserLikesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                // no value found, meaning user dont like this
                self.likeImage.image = UIImage(named: "empty-heart")
            } else {
                self.likeImage.image = UIImage(named: "filled-heart")
            }
        })
        
        
        
        print("\(currentUserLikesRef)")
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        currentUserLikesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "filled-heart")
                self.post.likeChanger(isLiked: true)
                self.currentUserLikesRef.setValue(true)
            } else {
                self.likeImage.image = UIImage(named: "empty-heart")
                self.post.likeChanger(isLiked: false)
                self.currentUserLikesRef.removeValue()
            }
        })
    }
    
}

