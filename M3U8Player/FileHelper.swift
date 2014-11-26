//
//  FileHelper.swift
//  M3U8Player
//
//  Created by Clinic on 14-11-26.
//  Copyright (c) 2014年 Clinic. All rights reserved.
//

import Foundation


func joinURLPath(args:String...)->String
{
    return  LOCAL_SERVER_ADDR + "/" + join("/", args)
}

func joinPath(args:String...)->String
{
    return join("/", args)
}

class FileHelper {
    
    class var videosPath:String{
        return self.documentPath.stringByAppendingPathComponent("videos")
    }
    
    class var documentPath:String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0] as String
    }
}