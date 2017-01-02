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
    
    var post: Post!
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        self.postedText.text = post.text
        self.numberOfLikesLabel.text = "\(post.likes)"
        
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
    }
    
}

