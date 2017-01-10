//
//  Album.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-09.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import Foundation

class Album {
    
    private var _name: String!
    private var _imageUrl: String!
    private var _previewMp3Url: String!
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var name: String {
        return _name
    }
    
    
    var previewMp3Url: String {
        return _previewMp3Url
    }
    
    init(name: String, imageUrl: String, previewMp3Url: String) {
        self._name = name
        self._imageUrl = imageUrl
        self._previewMp3Url = previewMp3Url
    }
    
    
}
