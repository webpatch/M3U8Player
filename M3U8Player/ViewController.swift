//
//  ViewController.swift
//  M3U8Player
//
//  Created by Clinic on 14-11-17.
//  Copyright (c) 2014年 Clinic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let p = NSBundle.mainBundle().pathForResource("m3u8", ofType: "txt")!
        let m3u8 = NSString(contentsOfFile: p, encoding: NSUTF8StringEncoding, error: nil)!
        let arr = m3u8.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
        var videoURLs = [NSURL]()
        for str:String in arr
        {
            if str.hasPrefix("http://")
            {
                let url:String = (str as NSString).componentsSeparatedByString("?")[0] as String
                println(url)
                videoURLs.append(NSURL(string: url)!)
            }
        }
        
        let vp = NSTemporaryDirectory()
        println(vp)
        var opArr = NSMutableArray()
        var num = 0
        for url in videoURLs
        {
            let r =  NSURLRequest(URL: url)
            var op = AFHTTPRequestOperation(request:r)
//            op.responseSerializer = AFImageResponseSerializer
//            op.outputStream = NSOutputStream(toFileAtPath: NSTemporaryDirectory(), append: false)
            op.setDownloadProgressBlock({ (byetsRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
                println(Double(totalBytesRead)/Double(totalBytesExpectedToRead))
            })
            op.setCompletionBlockWithSuccess({(AFHTTPRequestOperation, AnyObject) -> Void in
//                println(AFHTTPRequestOperation.responseData)
                var data:NSData = AFHTTPRequestOperation.responseData
                println("\(vp)\(num)")
                data.writeToFile("\(vp)\\\(num)", atomically: true)
                
            }, failure: { (AFHTTPRequestOperation, NSError) -> Void in
               
            })
            opArr.addObject(op)
            num+=1
        }
        
        var batches = AFURLConnectionOperation.batchOfRequestOperations(opArr, progressBlock: { (numberOfFinishedOperations, totalNumberOfOperations) -> Void in
            println(numberOfFinishedOperations)
        },completionBlock:{ (operations) -> Void in
            println("zzzzzz")
        })
        
        
        
        NSOperationQueue.mainQueue().addOperations(batches, waitUntilFinished: false)
        
        println("total \(videoURLs.count)")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

