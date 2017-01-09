//
//  DesignCornerButton.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-04.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import UIKit

class DesignCornerButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        layer.cornerRadius = 18.0
        
    }
    
}


class DesignCornerFieldView: UITextField{
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.cornerRadius = 18.0
        
    }}

class DesignRoundedView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.cornerRadius = 15.0
        
    }
}
