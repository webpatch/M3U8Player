//
//  String.swift
//  MobileAsking
//
//  Created by Clinic on 14-10-24.
//  Copyright (c) 2014年 Clinic. All rights reserved.
//

import Foundation
extension String {
    var length:Int{
        return countElements(self)
    }
    
    func toDouble()->Double{
        return (self as NSString).doubleValue
    }
    
    func indexOf(sub:String)->Int {
        var pos = -1
        if let range = self.rangeOfString(sub) {
            if !range.isEmpty {
                pos = distance(self.startIndex, range.startIndex)
            }
        }
        return pos
    }
    
    func isContain(sub:String)->Bool
    {
        return self.indexOf(sub) != -1
    }
    
    func toCharCode()->Int{
        let s = self.unicodeScalars
        return Int(s[s.startIndex].value)
    }
    
    func remove(start:Int,_ count:Int)->String{
        return (self as NSString).stringByReplacingCharactersInRange(NSRange(location: start, length: count), withString: "")
    }
    
    func subStringFrom(pos:Int)->String {
        return (self as NSString).substringFromIndex(pos)
    }
    
    func splitToArray()->[String]{
        var arr = [String]()
        for i in self
        {
            arr.append(String(i))
        }
        return arr
    }
    
    func PadLeft()->String{
        var s = self
        s = "0000" + s
        return s.substring(s.length - 5, 5)
    }
    
    func substring(start:Int,_ count:Int)->String{
        return self[start..<(start + count)]
//        return (self as NSString).substringWithRange(NSRange(location: start, length: count))
    }
    
    func subStringTo(pos:Int)->String {
        var substr = ""
        let end = advance(self.startIndex, pos-1)
        let range = self.startIndex...end
        substr = self[range]
        return substr
    }

    subscript(start:Int, count:Int)->String
    {
        return self[start..<(start + count)]
    }
    
    subscript(r:Range<Int>)->String
    {
        let start = advance(self.startIndex, r.startIndex)
        let end = advance(start,r.endIndex - r.startIndex)
        return self.substringWithRange(Range<String.Index>(start: start, end: end))
    }
    
    subscript(i:Int)->String
    {
        return self.substring(i, 1)
    }
}