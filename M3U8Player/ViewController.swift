//
//  ViewController.swift
//  M3U8Player
//
//  Created by Clinic on 14-11-17.
//  Copyright (c) 2014年 Clinic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var _op:NSOperationQueue!

    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let p = NSBundle.mainBundle().pathForResource("m3u8", ofType: "txt")!
        let m3u8File = NSString(contentsOfFile: p, encoding: NSUTF8StringEncoding, error: nil)!
        let videoURLs = M3U8.decode(m3u8File)
        
        let tmpPath = NSHomeDirectory()
        println(tmpPath)
        var opArr = NSMutableArray()
        var num = 0
        var currProgressNum:Double = 0
        var totalProgressNum:Double = 0
        for url in videoURLs
        {
            
            var op = AFHTTPRequestOperation(request:NSURLRequest(URL: NSURL(string: url)!))
            
            op.setDownloadProgressBlock({ (byetsRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
                currProgressNum = Double(totalBytesRead)/Double(totalBytesExpectedToRead) * Double(100.0)/Double(videoURLs.count)
                self.label.text = String(format: "%.1f",currProgressNum+totalProgressNum)
            })
            
            op.setCompletionBlockWithSuccess({(AFHTTPRequestOperation, AnyObject) -> Void in
                totalProgressNum += currProgressNum
                currProgressNum = 0
                
                let path = tmpPath.stringByAppendingPathComponent("\(num).\(url.pathExtension)")
                var data:NSData = AFHTTPRequestOperation.responseData
                println("write to \(path)")
                data.writeToFile(path, atomically: true)
                num++
            }, failure: { (AFHTTPRequestOperation, NSError) -> Void in
               
            })
            opArr.addObject(op)
        }
        
        var batches = AFURLConnectionOperation.batchOfRequestOperations(opArr, progressBlock: { (numberOfFinishedOperations, totalNumberOfOperations) -> Void in
            
        },completionBlock:{ (operations) -> Void in
            println("all done!")
        })
        
        _op = NSOperationQueue()
        _op.maxConcurrentOperationCount = 1
        _op.addOperations(batches, waitUntilFinished: false)
        println("total \(videoURLs.count)")
        
        let ws = GCDWebServer()
        ws.addGETHandlerForBasePath("/", directoryPath: NSHomeDirectory(), indexFilename: nil, cacheAge: 3600, allowRangeRequests: true)
        ws.startWithPort(8080, bonjourName: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

