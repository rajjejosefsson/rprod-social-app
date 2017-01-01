//
//  DesignCornerButton.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-01.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import UIKit

class DesignCornerButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
        
    }

}
