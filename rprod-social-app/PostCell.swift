//
//  PostCell.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-02.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImage: DesignCircleView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var postedText: UITextView!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    
    var post: Post!
    
    func configureCell(post: Post) {
        self.post = post
    
        self.postedText.text = post.text
        self.numberOfLikesLabel.text = "\(post.likes)"
        
    }
}
