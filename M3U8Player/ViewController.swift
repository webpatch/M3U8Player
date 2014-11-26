//
//  ViewController.swift
//  M3U8Player
//
//  Created by Clinic on 14-11-17.
//  Copyright (c) 2014年 Clinic. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    var mp:MPMoviePlayerController!
    var d:VideoDownLoader!
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ws = GCDWebServer()
        ws.addGETHandlerForBasePath("/", directoryPath: FileHelper.videosPath, indexFilename: nil, cacheAge: 3600, allowRangeRequests: true)
        ws.startWithPort(LOCAL_PORT, bonjourName: nil)

        let idStr = "XODMzNzA2NDEy"
        
        d = VideoDownLoader(vid: idStr,progress: { (progress) -> Void in
            self.label.text = String(format: "%.1f", progress)
        })
    }
    
    @IBAction func pause()
    {
        d.pause()
    }
    
    @IBAction func resume()
    {
        d.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

