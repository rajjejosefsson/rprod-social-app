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
    private var _imageUrl: String!
    private var _likes: Int!
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
    
    
    init(text: String, imageUrl: String, likes: Int) {
        self._text = text
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let text = postData["text"] as? String {
            self._text = text
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["Likes"] as? Int {
            self._likes = likes
        }
        
    }
    
    

    
}
