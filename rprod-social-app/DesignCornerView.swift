//
//  DesignCornerView.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-03.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import UIKit


class DesignCornerView: UIImageView  {

    
        override func awakeFromNib() {
            super.awakeFromNib()
            self.layer.cornerRadius = 8.0
            self.clipsToBounds = true
        }
        
    
    
}
