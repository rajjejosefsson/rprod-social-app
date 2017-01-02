//
//  Post.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-02.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import Foundation

class Post {

    private var _text: String!
    private var _email: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postDate: String!
    private var _postKey: String!
    
    
    var text: String {
        return _text
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    var postDate: String {
        return _postDate
    }
    
    var email: String {
        return _email
    }
    
    // used when creating the post
    init(text: String, imageUrl: String, email: String, likes: Int) {
        self._text = text
        self._imageUrl = imageUrl
        self._likes = likes
        self._email = email
        self._postDate = postDate
    }
    
    
    // used when loading data from snapshot into the view inside FeedVC in viewDidLoad
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let text = postData["text"] as? String {
            self._text = text
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        if let email = postData["email"] as? String {
            self._email = email
        }
        
        if let postDate = postData["postDate"] as? String {
            self._postDate = postDate
        }
        
    }
    
    

    
}
