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

    @IBOutlet weak var profileImage: DesignCircleButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var postedText: UITextView!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!

    var post: Post!
    var delegate: MyCellDelegate?
    var userId: String!
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
        
        if image != nil {
            // Cached Image
            self.postedImage.image = image
        } else {
            // Not Chached
            let postRef = DataService.ds.REF_POSTS.child(post.postKey)
            DataService.ds.currentUserImage(userRef: postRef , completed: {
                let image = DataService.ds.profileImage
                self.postedImage.image = image
                FeedVC.imageChache.setObject(image, forKey: post.imageUrl as NSString)
            })
        }
        
        
        
        // Gets the users email aderss from users ref and uses that as username label
        DataService.ds.REF_USERS.child(post.userId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                
                let email = value[KEY_EMAIL] as? String ?? ""
                self.usernameLabel.text = email
                let imageUrl = value[KEY_IMAGE_URL] as? String ?? ""
               
                DataService.ds.setImageOf(imageUrl: imageUrl, on: self.profileImage)
            }
        })

        


        
        // Number of likes of the cell
        currentUserLikesRef = DataService.ds.REF_AUTHED_USER.child(KEY_LIKES).child(post.postKey)
        currentUserLikesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                // no value found, meaning user dont like this yet
                self.likeImage.image = UIImage(named: "empty-heart")
            } else {
                self.likeImage.image = UIImage(named: "filled-heart")
            }
        })
        
        
    
        
        
        
 
    }
    
    
    
    func likeTapped(sender: UITapGestureRecognizer) {
        currentUserLikesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "heart-filled")
                self.post.likeChanger(isLiked: true)
                self.currentUserLikesRef.setValue(true)
            } else {
                self.likeImage.image = UIImage(named: "heart-empty")
                self.post.likeChanger(isLiked: false)
                self.currentUserLikesRef.removeValue()
            }
        })
    }
    
 
    @IBAction func profileImageTapped(_ sender: Any) {
       print("tapped")
        
        userId = post.userId
        
        if let delegate = self.delegate {
            delegate.didTapUser(tappedProfileId: self.userId)
        }
    }
    
    
    
}

