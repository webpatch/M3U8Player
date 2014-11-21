//
//  Parser.h
//  M3U8Player
//
//  Created by Clinic on 14-11-20.
//  Copyright (c) 2014年 Clinic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject
-(void)getM3U8FileByVideoID: (NSString*)vid success:(void (^)(NSString *m3u8File))success;
@end
