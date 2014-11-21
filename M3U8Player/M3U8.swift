//
//  M3U8.swift
//  M3U8Player
//
//  Created by Clinic on 14-11-19.
//  Copyright (c) 2014年 Clinic. All rights reserved.
//

import Foundation
struct M3U8SegmentInfo:Printable {
    var url:String
    var duration:Double
    var description:String
    {
        return "\(url):\(duration)"
    }
}

private func findM3U8(url:String, inArray:[M3U8SegmentInfo]) ->Bool
{
    for i in inArray
    {
        if i.url == url{
            return true
        }
    }
    return false
}

class M3U8 {
    class func decode(content:String) -> [M3U8SegmentInfo]
    {
        var videoURLs = [M3U8SegmentInfo]()
        let arr = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
        var duration:Double = 0
        for str:String in arr
        {
            if str.hasPrefix("#EXTINF:")
            {
                let s = (str as NSString).componentsSeparatedByString(":")[1] as String
                duration = s.subStringTo(s.length-1).toDouble()
            }else if str.hasPrefix("http://"){
                videoURLs.append(M3U8SegmentInfo(url: str, duration: 0));
                videoURLs[videoURLs.count-1].duration += duration
            }
        }
        println(videoURLs)
        return videoURLs
    }
    
    class func encode()
    {
        
    }
}