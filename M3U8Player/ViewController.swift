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
    var _op:NSOperationQueue!
    var mp:MPMoviePlayerController!
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ws = GCDWebServer()
        ws.addGETHandlerForBasePath("/", directoryPath: NSHomeDirectory(), indexFilename: nil, cacheAge: 3600, allowRangeRequests: true)
        ws.startWithPort(12345, bonjourName: nil)
        
        let p = Parser()
        let idStr = "XODMxNjM2MTI0"
        p.getM3U8FileByVideoID(idStr, success: { (m3u8File) -> Void in
            let videoURLs = M3U8.decode(m3u8File)
            
            let tmpPath = NSHomeDirectory()
            println(tmpPath)
            var opArr = NSMutableArray()
            var num = 0
            var count = 0
            var currProgressNum:Double = 0
            var totalProgressNum:Double = 0
            
            var out_m3u8 = "#EXTM3U\n#EXT-X-TARGETDURATION:12\n#EXT-X-VERSION:3\n"
            for seg in videoURLs
            {
                var op = AFHTTPRequestOperation(request:NSURLRequest(URL: NSURL(string: seg.url)!))
                
                op.setDownloadProgressBlock({ (byetsRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
                    currProgressNum = Double(totalBytesRead)/Double(totalBytesExpectedToRead) * Double(100.0)/Double(videoURLs.count)
                    self.label.text = String(format: "%.1f",currProgressNum+totalProgressNum)
                })
                
                op.setCompletionBlockWithSuccess({(AFHTTPRequestOperation, AnyObject) -> Void in
                    totalProgressNum += currProgressNum
                    currProgressNum = 0
                    
                    let path = tmpPath.stringByAppendingPathComponent("\(num)")
                    var data:NSData = AFHTTPRequestOperation.responseData
                    println("write to \(path)")
                    
                    data.writeToFile(path, atomically: true)
                    num++
                    }, failure: { (AFHTTPRequestOperation, NSError) -> Void in
                   
                })
                opArr.addObject(op)
                out_m3u8 += "#EXTINF:\(seg.duration),\nhttp://127.0.0.1:12345/\(count)\n"
                count++
            }
            out_m3u8 += "#EXT-X-ENDLIST"
            out_m3u8.writeToFile(tmpPath.stringByAppendingPathComponent("a.m3u8"), atomically: true, encoding: NSUTF8StringEncoding, error: nil)
            
            
            var batches = AFURLConnectionOperation.batchOfRequestOperations(opArr, progressBlock: { (numberOfFinishedOperations, totalNumberOfOperations) -> Void in
                
            },completionBlock:{ (operations) -> Void in
                println("all done!")
                
                let mp2 = MPMoviePlayerController(contentURL: NSURL(string: "http://127.0.0.1:12345/a.m3u8"))
                mp2.view.frame = self.view.frame
                self.view.addSubview(mp2.view)
                mp2.setFullscreen(true, animated: true)
                mp2.play()
                self.mp = mp2
            })
            
            self._op = NSOperationQueue()
            self._op.maxConcurrentOperationCount = 1
            self._op.addOperations(batches, waitUntilFinished: false)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

