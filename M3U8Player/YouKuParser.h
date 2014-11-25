//
//  Parser.h
//  M3U8Player
//
//  Created by Clinic on 14-11-20.
//  Copyright (c) 2014年 Clinic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YoukuParser : NSObject
+(void)getM3U8URLByVideoID: (NSString*)vid success:(void (^)(NSString *m3u8URL))success;
@end
