//
//  M3U8.swift
//  M3U8Player
//
//  Created by Clinic on 14-11-19.
//  Copyright (c) 2014年 Clinic. All rights reserved.
//

import Foundation

enum VideoType
{
    case mp4
    case ts
}

//MARK:- M3U8SegmentInfo
struct M3U8SegmentInfo {
    var url:String
    var duration:Double
}

//MARK: M3U8SegmentInfo Printable
extension M3U8SegmentInfo:Printable
{
    var description:String
    {
        return "\(url):\(duration)"
    }
}

//MARK:- M3U8Handler
class M3U8Handler {
    
    //MARK: Public
    class func download(url:String,success: ([M3U8SegmentInfo],String)->Void)
    {
        let m = AFHTTPRequestOperationManager()
        m.responseSerializer = AFHTTPResponseSerializer()
        m.GET(url, parameters: nil, success: { (operation, responseObj) -> Void in
            println("sucess get M3U8 file")
            let d = responseObj as NSData;
            let m3u8 = NSString(data: d, encoding: NSUTF8StringEncoding)!
            success(self.decode(m3u8))
        }) { (operation, error) -> Void in
            println("get M3U8 file error \(error)")
        }
    }
    
    //MARK: private
    private class func decode(content:String) -> ([M3U8SegmentInfo],String)
    {
        var newM3U8Str = "#EXTM3U\n"
        var videoURLs = [M3U8SegmentInfo]()
        let arr = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
        var duration:Double = 0
        var count = 0
        for str:String in arr
        {
            if str.hasPrefix("#EXTINF:")
            {
                newM3U8Str += (str+"\n")
                let s = (str as NSString).componentsSeparatedByString(":")[1] as String
                duration = s.subStringTo(s.length-1).toDouble()
            }else if str.hasPrefix("http://"){
                newM3U8Str += joinURLPath("\(count)\n")
                videoURLs.append(M3U8SegmentInfo(url: str, duration: 0));
                videoURLs[videoURLs.count-1].duration += duration
                count++
            }else if str.hasPrefix("#EXT-X-TARGETDURATION"){
                newM3U8Str += (str+"\n#EXT-X-VERSION:3\n")
            }
        }
        newM3U8Str += "#EXT-X-ENDLIST"
        println("decode m3u8 file success: \(videoURLs.count)")
        return (videoURLs,newM3U8Str)
    }
}