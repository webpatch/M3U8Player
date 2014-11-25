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
    var opArr:NSMutableArray!
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ws = GCDWebServer()
        ws.addGETHandlerForBasePath("/", directoryPath: NSHomeDirectory(), indexFilename: nil, cacheAge: 3600, allowRangeRequests: true)
        ws.startWithPort(LOCAL_PORT, bonjourName: nil)
        
//        let p =
        let idStr = "XODMzNzA2NDEy"
        
        YoukuParser.getM3U8URLByVideoID("XODM0NTcwOTky", success: { (m3u8URL) -> Void in
            println(m3u8URL)
        })
        
        YoukuParser.getM3U8URLByVideoID(idStr, success: { (m3u8URL) -> Void in
            println(m3u8URL)
//            let (videoURLs,m3u8Str) = M3U8.decode(m3u8File)
//            
//            let tmpPath = NSHomeDirectory()
//            println(tmpPath)
//            self.opArr = NSMutableArray()
//            var num = 0
//            var count = 0
////
//            var lastBytesReceived:Double = 0
//            for seg in videoURLs
//            {
//                let path =  tmpPath.stringByAppendingPathComponent("\(count)")
//                var op:AFDownloadRequestOperation = AFDownloadRequestOperation(request: NSURLRequest(URL: NSURL(string: seg.url)!), targetPath: path, shouldResume: true)
//                
//                op.setCompletionBlockWithSuccess({(ff, obj) -> Void in
//                    let g:AFDownloadRequestOperation = ff as AFDownloadRequestOperation
//                    (ff as AFDownloadRequestOperation).deleteTempFileWithError(nil)
//                    println("save \(path)")
//                }, failure: { (AFHTTPRequestOperation, NSError) -> Void in
//                   
//                })
//                
//                self.opArr.addObject(op)
//                count++
//            }
//            m3u8Str.writeToFile(tmpPath.stringByAppendingPathComponent("a.m3u8"), atomically: true, encoding: NSUTF8StringEncoding, error: nil)
//            
//            var h = CFAbsoluteTimeGetCurrent()
//            var batches = AFURLConnectionOperation.batchOfRequestOperations(self.opArr, progressBlock: { (numberOfFinishedOperations, totalNumberOfOperations) -> Void in
//                let per = Double(numberOfFinishedOperations)/Double(totalNumberOfOperations) * 100
//                self.label.text = String(format: "%.1f", per)
//            },completionBlock:{ (operations) -> Void in
//                let hx = CFAbsoluteTimeGetCurrent() - h
//                println("all done!",hx)
//                
//                let mp2 = MPMoviePlayerController(contentURL: NSURL(string: "http://127.0.0.1:12345/a.m3u8"))
//                mp2.view.frame = self.view.frame
//                self.view.addSubview(mp2.view)
//                mp2.setFullscreen(true, animated: true)
//                mp2.play()
//                self.mp = mp2
//                
//            })
//            
//            self._op = NSOperationQueue()
//            self._op.maxConcurrentOperationCount = 5
//            self._op.addOperations(batches, waitUntilFinished: false)
        })
        

    }
    
    @IBAction func pause()
    {
        for e in self.opArr{
            (e as AFHTTPRequestOperation).pause();
        }
    }
    
    @IBAction func resume()
    {
        for e in self.opArr
        {
            (e as AFHTTPRequestOperation).resume();
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

