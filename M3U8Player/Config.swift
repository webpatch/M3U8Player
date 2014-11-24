//
//  Config.swift
//  M3U8Player
//
//  Created by Clinic on 14-11-24.
//  Copyright (c) 2014年 Clinic. All rights reserved.
//

import Foundation

let LOCAL_PORT:UInt = 12345
let LOCAL_SERVER_ADDR = "http://127.0.0.1:\(LOCAL_PORT)"

func joinURLPath(args:String...)->String
{
    return  LOCAL_SERVER_ADDR + "/" + join("/", args)
}