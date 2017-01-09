//
//  MusicListVC.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-06.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import UIKit
import Firebase

class UserFavoriteMusicListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navProfileImage: DesignCircleButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NavigationHelper.nav.initAuthedUserImageTo(uiButton: navProfileImage)

    }
    
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "MusicCell") as! MusicCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    
    @IBAction func navProfileImageTapped(_ sender: DesignCircleButton) {
        DataService.ds.getAuthedProfile { (profile) in
            self.performSegue(withIdentifier: "ProfileVC", sender: profile)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
