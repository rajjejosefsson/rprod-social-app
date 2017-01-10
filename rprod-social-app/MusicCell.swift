//
//  MusicCell.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-06.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import UIKit

class MusicCell: UITableViewCell {

    
    @IBOutlet weak var albumImage: UIImageView!
    
    var album: Album!

    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    func configureCell(album: Album) {
        self.album = album
       
        
        
        self.nameLabel.text = album.name
        
        
        let imageUrl = URL(string: album.imageUrl)
        let imageData = NSData(contentsOf: imageUrl!)
        let image = UIImage(data: imageData as! Data)
        self.albumImage.image = image
     
        
    }


    
}
