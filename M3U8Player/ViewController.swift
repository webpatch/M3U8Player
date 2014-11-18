//
//  ViewController.swift
//  M3U8Player
//
//  Created by Clinic on 14-11-17.
//  Copyright (c) 2014年 Clinic. All rights reserved.
//

import UIKit
import KinyLib

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let p = NSBundle.mainBundle().pathForResource("m3u8", ofType: "txt")!
        let m3u8 = NSString(contentsOfFile: p, encoding: NSUTF8StringEncoding, error: nil)!
        let arr = m3u8.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
        var videoURLs = [String]()
        for str:String in arr
        {
            if str.hasPrefix("http://")
            {
                let url:String = (str as NSString).componentsSeparatedByString("?")[0] as String
                println(url)
                videoURLs.append(url)
            }
        }
        
        println("total \(videoURLs.count)")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

