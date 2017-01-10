//
//  SongDetailVC.swift
//  rprod-social-app
//
//  Created by Rasmus Josefsson on 2017-01-06.
//  Copyright © 2017 Rasmus Josefsson. All rights reserved.
//

import UIKit
import AVFoundation

class SongDetailVC: UIViewController {

    @IBOutlet weak var navProfileImage: DesignCircleButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var albumImage: DesignShadowImage!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    
    var album: Album!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.nav.initAuthedUserImageTo(uiButton: navProfileImage)

        
        getMp3FromURL(url: URL(string: album.previewMp3Url)!)
        
        albumLabel.text = album.name
        
        let imageUrl = URL(string: album.imageUrl)
        let imageData = NSData(contentsOf: imageUrl!)
        let image = UIImage(data: imageData as! Data)
        backgroundImage.image = image
        albumImage.image = image
    }


    
   
    func getMp3FromURL(url: URL) {
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (url, response, error) in
            
            if let downloadedUrl = url {
                self.playUrl(url: downloadedUrl)
            }
        })
        
        // Start the download
        downloadTask.resume()
    }
    
    
    func playUrl(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func playPause(_ sender: UIButton) {
        
        if player.isPlaying {
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            player.pause()
        } else {
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            player.play()
        }
    }
    
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true) {
            // call parent to update the image
        }
    }
    

}
