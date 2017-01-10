//
//  MusicListVC.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-06.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import AVFoundation

var player = AVAudioPlayer()

class SearchSongVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navProfileImage: DesignCircleButton!

    @IBOutlet weak var searchBar: UISearchBar!
    
    typealias JSONStandard = [String : AnyObject]
    
    
    var albums = [Album]()
    var searchUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        searchBar.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        
        
        NavigationHelper.nav.initAuthedUserImageTo(uiButton: navProfileImage)
        
        
    }
    
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    
    
    // SearchBar When text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
          
            tableView.reloadData()
            view.endEditing(true)
            
        } else {
            
            
            if let keywords = searchBar.text {
                
                let searchQuery = keywords.replacingOccurrences(of: " ", with: "+")
                
                searchUrl = "https://api.spotify.com/v1/search?q=\(searchQuery)&type=track"
                searchForUrl(url: searchUrl)
                
            }
        }
    }
    
    
   
    func searchForUrl(url: String) {
        Alamofire.request(url).responseJSON { (response) in
            self.parseJSONData(JSONData: response.data!)
        }
    }
    
    
    
    func parseJSONData(JSONData: Data) {
        
        albums = []
        
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let tracks = readableJSON["tracks"] as? JSONStandard {
                if let items = tracks["items"] as? [JSONStandard] {
                   
                    for i in 0..<items.count {
                      
                        var imageUrl = ""
                        
                        let item = items[i]
                        
                        // Album Name
                        let name = item["name"] as? String ?? ""
                        
                        
                        // Album image
                        if let album = item["album"] as? JSONStandard {
                            if let images = album["images"] as? [JSONStandard] {
                            
                                let image = images[0]
                                imageUrl = image["url"] as? String ?? ""
                            }
                        }
                        
                        let previewUrl = item["preview_url"] as? String ?? ""
                        
                    
                        // Add new album to array
                        let newAlbum = Album(name: name, imageUrl: imageUrl, previewMp3Url: previewUrl)
                        albums.append(newAlbum)

                        
                        self.tableView.reloadData()
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell") as? MusicCell {
        
            let album = albums[indexPath.row]
            cell.configureCell(album: album)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    

    // Tells the delegate that the specified row is now selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        // Pass item to sender delegate
        performSegue(withIdentifier: "SongDetailVC", sender: album)
    }
    
    
    

    @IBAction func navProfileImageTapped(_ sender: DesignCircleButton) {
        DataService.ds.getAuthedProfile { (profile) in
            self.performSegue(withIdentifier: "ProfileVC", sender: profile)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        
       
            
            if segue.identifier == "SongDetailVC" {
                
                
                if let desitnation = segue.destination as? SongDetailVC {
                    if let album = sender as? Album {
                        desitnation.album = album
                    }
                }
                
            
            } else if segue.identifier == "ProfileVC" {
            
                if let desitnation = segue.destination as? ProfileVC {
                
                    if let profile = sender as? Profile {
                        desitnation.profile = profile
                    }
                }
            
            }
            
        
            
        
    }
    
    


 
    
    
    



}
