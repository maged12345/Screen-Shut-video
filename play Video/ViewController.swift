//
//  ViewController.swift
//  play Video
//
//  Created by maged mohamed on 12/7/21.
//  Copyright © 2021 maged mohamed. All rights reserved.
//

import UIKit
import AVKit
import  AVFoundation

class ViewController: UIViewController {
    
    //var playerController = AVPlayerViewController()
    //var playerlayer = AVPlayerLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Screen Shut every 30 second"
    }
    
    
    //MARK: -  playButton Clicked
    @IBAction func playVideoButton(_ sender: Any) {
        
        guard let url = URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")else {return}
        
        
        // here calculate the duration of the video by second
        let asset = AVAsset(url: url)
        
        let duration = asset.duration
        let durationTime = (Int)( CMTimeGetSeconds(duration) )
        print("Total second of video by intiger = \(durationTime)  ........")
        let durationDividedBy30 = durationTime/30
        
        print("we will take = \(durationDividedBy30) screen shut  .........")
        
        // here play video on screen
        let player = AVPlayer(url: url)
        let layer = AVPlayerLayer(player: player)
        //layer.frame = self.view.bounds
        layer.frame = CGRect(x: 0, y: 0, width: 414 , height:800)
        layer.videoGravity = .resizeAspect
        self.view.layer.addSublayer(layer)
        player.play()
        
        // playerController = AVPlayerViewController()
        // playerController.player = player
        // playerController.allowsPictureInPicturePlayback = true
        // playerController.player?.play()
        // self.present(playerController, animated: true, completion: nil)
        
        
        
        // here executing sleep in background thread and
        let queue = DispatchQueue(label: "ScreenShut")
        queue.async {
            
            
            for i in 1...durationDividedBy30 {
                
                sleep(30)
                print("screen shut number = \(i)")
                
                DispatchQueue.main.async {
                    guard let screenShut = self.view.screenShut() else { return }
                    UIImageWriteToSavedPhotosAlbum(screenShut, nil, nil, nil)
                    print("succeed to pick  screen shut after 30 second")
                }
                
            }
            
            
        }
        
        
        
    }
    
}
//MARK: - Screen shut Method by extenstion of uiview
extension UIView {
    func screenShut() -> UIImage?{
        let scale = UIScreen.main.scale
        let bounds = self.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
        if let _ = UIGraphicsGetCurrentContext() {
            self.drawHierarchy(in: bounds, afterScreenUpdates: true)
            let screenshut = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return screenshut
        }
        return  nil
    }
}

