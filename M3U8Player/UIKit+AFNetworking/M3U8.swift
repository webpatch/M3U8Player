//
//  M3U8.swift
//  M3U8Player
//
//  Created by Clinic on 14-11-19.
//  Copyright (c) 2014年 Clinic. All rights reserved.
//

import Foundation
struct M3U8SegmentInfo {
    var url:String
    var duration:String
}

class M3U8 {
    class func decode(content:String)->[String]
    {
        var videoURLs = [String]()
        let arr = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
        for str:String in arr
        {
            if str.hasPrefix("http://")
            {
                let url:String = (str as NSString).componentsSeparatedByString("?")[0] as String
                if(find(videoURLs, url) == nil)
                {
                    println(url)
                    videoURLs.append(url)
                }
            }
        }
        return videoURLs
    }
    
    class func encode()
    {
        
    }
}