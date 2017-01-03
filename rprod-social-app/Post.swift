//
//  Post.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-02.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import Foundation
import Firebase

class Post {

    private var _text: String!
    private var _userId: String!
    private var _imageUrl: String!
    private var _numberOfLikes: Int!
    private var _postDate: String!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    var text: String {
        return _text
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var numberOfLikes: Int {
        return _numberOfLikes
    }
    
    var postKey: String {
        return _postKey
    }
    
    var postDate: String {
        return _postDate
    }
    
    var userId: String {
        return _userId
    }
    
    // used when creating the post
    init(text: String, imageUrl: String, numberOfLikes: Int) {
        self._text = text
        self._imageUrl = imageUrl
        self._numberOfLikes = numberOfLikes
        
        self._userId = userId
        self._postDate = postDate
    }
    
    
    // used when loading data from snapshot into the view inside FeedVC in viewDidLoad
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
       
        self._postKey = postKey
        
        if let text = postData[KEY_TEXT] as? String {
            self._text = text
        }
        
        if let imageUrl = postData[KEY_IMAGE_URL] as? String {
            self._imageUrl = imageUrl
        }
        
        if let numberOfLikes = postData[KEY_LIKES] as? Int {
            self._numberOfLikes = numberOfLikes
        }
        
        if let userId = postData[KEY_USER_ID] as? String {
            self._userId = userId
        }
        
        if let postDate = postData[KEY_POST_DATE] as? String {
            self._postDate = postDate
        }
        
        self._postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    
    

    func likeChanger(isLiked: Bool){
        if isLiked {
            _numberOfLikes = _numberOfLikes + 1
        } else {
            _numberOfLikes = _numberOfLikes - 1
        }
        
        _postRef.child(KEY_LIKES).setValue(_numberOfLikes)
    }
    
}
