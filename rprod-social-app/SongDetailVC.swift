//
//  SongDetailVC.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-06.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import UIKit

class SongDetailVC: UIViewController {

    @IBOutlet weak var navProfileImage: DesignCircleButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.nav.initAuthedUserImageTo(uiButton: navProfileImage)

    }


    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true) {
            // call parent to update the image
        }
    }
    

}
