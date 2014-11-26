//
//  VideoDownload.swift
//  M3U8Player
//
//  Created by Clinic on 14-11-26.
//  Copyright (c) 2014年 Clinic. All rights reserved.
//

import Foundation
class VideoDownLoader {
    var opArr = [AFHTTPRequestOperation]()
    var op:NSOperationQueue!
    
    init(vid:String,progress:(Double)->Void)
    {
        YoukuParser.getM3U8URLByVideoID(vid, success: { (m3u8URL:String!) -> Void in
            println(m3u8URL)
            M3U8Handler.download(m3u8URL, success: { (segments:[M3U8SegmentInfo], m3u8Str:String) -> Void in
                let videoPath = FileHelper.videosPath.joinPath(vid)
                NSFileManager().createDirectoryAtPath(videoPath, withIntermediateDirectories: true, attributes: nil, error: nil)
                
                m3u8Str.writeToFile(videoPath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
                
                for (idx,seg) in enumerate(segments)
                {
                    let path =  videoPath.joinPath("\(idx)")
                    var op:AFDownloadRequestOperation = AFDownloadRequestOperation(request: NSURLRequest(URL: NSURL(string: seg.url)!), targetPath: path, shouldResume: true)
                    
                    op.setCompletionBlockWithSuccess({(operation, obj) -> Void in
                        println("save \(path)")
                    }, failure: { (operation, NSError) -> Void in
                        
                    })
                    
                    self.opArr.append(op)
                }
                
                var batches = AFURLConnectionOperation.batchOfRequestOperations(self.opArr, progressBlock: { (numberOfFinishedOperations, totalNumberOfOperations) -> Void in
                    let per = Double(numberOfFinishedOperations)/Double(totalNumberOfOperations) * 100
                    progress(per)
                    println(per)
                },completionBlock:{ (operations) -> Void in
                    println("all done!")
                })
                
                self.op = NSOperationQueue()
                self.op.maxConcurrentOperationCount = 5
                self.op.addOperations(batches, waitUntilFinished: false)
            })
        })

    }
    
    func pause()
    {
        for e in self.opArr{
            (e as AFHTTPRequestOperation).pause();
        }
    }
    
    func resume()
    {
        for e in self.opArr
        {
            (e as AFHTTPRequestOperation).resume();
        }
    }
}