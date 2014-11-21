//
//  Parser.m
//  M3U8Player
//
//  Created by Clinic on 14-11-20.
//  Copyright (c) 2014年 Clinic. All rights reserved.
//

#import "Parser.h"
#import "AFNetworking.h"

@implementation Parser
{
    NSString *ep;
    NSString *ip;
    NSArray *stream_types;
    NSMutableDictionary *streams;
}

void swap(int *a,int *b)
{
    int tmp = *a;
    *a = *b;
    *b = tmp;
}

-(void)getM3U8FileByVideoID: (NSString*)vid success:(void (^)(NSString *m3u8File))success
{
    NSString *url = [NSString stringWithFormat:@"http://v.youku.com/player/getPlayList/VideoIDS/%@/Pf/4/ctype/12/ev/1",vid];
    AFHTTPRequestOperationManager *m = [AFHTTPRequestOperationManager manager];
    [m GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"sucess get ep");
        
        id metadata0 = responseObject[@"data"][0];
        ep = metadata0[@"ep"];
        ip = metadata0[@"ip"];
        
        for (id stream_type in stream_types) {
            if(metadata0[@"streamsizes"][stream_type[@"id"]]){
                NSString *stream_id = stream_type[@"id"];
                NSNumber *stream_size = [NSNumber numberWithLongLong:(long long)metadata0[@"streamsizes"][stream_id]];
                streams[stream_id] = @{@"container": stream_type[@"container"],
                                       @"video_profile": stream_type[@"video_profile"],
                                       @"size": stream_size};
            }
        }
        
        if (streams.count == 0) {
            for (id stream_type in stream_types) {
                if(metadata0[@"streamtypes_o"][stream_type[@"id"]]){
                    NSString *stream_id = stream_type[@"id"];
                    NSNumber *stream_size = [NSNumber numberWithLongLong:(long long)metadata0[@"streamsizes"][stream_id]];
                    streams[stream_id] = @{@"container": stream_type[@"container"],
                                           @"video_profile": stream_type[@"video_profile"],
                                           @"size": stream_size};
                }
            }
        }
        
        NSString *stream_id = @"mp4";
        NSDictionary *out = [self generate:vid withEP:ep];
        NSDictionary *requestParams = @{@"ctype":@12,
                                        @"ep":out[@"new_ep"],
                                        @"ev":@1,
                                        @"keyframe":@1,
                                        @"oip":ip,
                                        @"sid":out[@"sid"],
                                        @"token":out[@"token"],
                                        @"ts":[NSNumber numberWithLong:(long)time(NULL)],
                                        @"type":stream_id,
                                        @"vid":vid};
        
        NSMutableURLRequest *rq = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                                URLString:@"http://pl.youku.com/playlist/m3u8"
                                                                               parameters:requestParams error:nil];
        m.responseSerializer = [AFHTTPResponseSerializer serializer];
        [[m HTTPRequestOperationWithRequest:rq success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSData *d = responseObject;
            NSString *m3u8 = [[NSString alloc]initWithData:d encoding:NSUTF8StringEncoding];
            NSLog(@"sucess get M3U8 file");
            success(m3u8);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Get M3U8 file error: %@", error);
        }] start];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get EP error: %@", error);
    }];
}

-(instancetype)init
{
    if(self = [super init])
    {
        streams = [[NSMutableDictionary alloc]init];
        stream_types = @[@{@"id": @"hd3", @"container": @"flv", @"video_profile": @"1080P"},
                         @{@"id": @"hd2", @"container": @"flv", @"video_profile": @"超清"},
                         @{@"id": @"mp4", @"container": @"mp4", @"video_profile": @"高清"},
                         @{@"id": @"flvhd", @"container": @"flv", @"video_profile": @"高清"},
                         @{@"id": @"flv", @"container": @"flv", @"video_profile": @"标清"},
                         @{@"id": @"3gphd", @"container": @"3gp", @"video_profile": @"高清（3GP）"}];
    }
    return self;
}

-(NSDictionary *)generate:(NSString *)vid withEP:(NSString*)epIn
{
    NSString *f_code_1 = @"becaf9be";
    NSString *f_code_2 = @"bf7e5f01";
    
    NSData *d = [[NSData alloc]initWithBase64EncodedString:epIn options:0];
    const unsigned char *rawData = [d bytes];
    NSData *e_data = [self trans_e:f_code_1 withCharPointer:rawData withCharLen:d.length];
    NSString *e_code = [[NSString alloc]initWithData:e_data encoding:NSUTF8StringEncoding];
    NSArray *arr = [e_code componentsSeparatedByString:@"_"];
    NSString *sid = arr[0];
    NSString *token = arr[1];
    
    NSString *raw_new_ep = [NSString stringWithFormat:@"%@_%@_%@",sid, vid, token];
    const unsigned char *raw_new_ep_char = (const unsigned char *)[raw_new_ep UTF8String];
    NSData *new_ep_Data = [self trans_e:f_code_2 withCharPointer:raw_new_ep_char withCharLen:raw_new_ep.length];
    NSString *new_ep = [new_ep_Data base64EncodedStringWithOptions:0];
    
    return @{@"new_ep":new_ep,@"sid":sid,@"token":token};
}

-(NSData *)trans_e:(NSString *)a withCharPointer:(const unsigned char *)c withCharLen:(NSUInteger) clen
{
    int f = 0, h = 0;
    int b[256];
    for(int i = 0 ;i<256;i++){
        b[i] = i;
    }
    while (h < 256){
        f = (f + b[h] + [a characterAtIndex:h % a.length]) % 256;
        swap(&b[h], &b[f]);
        h += 1;
    }
    char rs[clen];
    int q = 0;
    f = h = 0;
    while (q < clen){
        h = (h + 1) % 256;
        f = (f + b[h]) % 256;
        swap(&b[h], &b[f]);
        rs[q] = (char) c[q] ^ b[(b[h] + b[f]) % 256];
        //NSLog(@"result:%d %d %c",q,c[q] ^ b[(b[h] + b[f]) % 256],outP[q]);
        q += 1;
    }
    return [[NSData alloc]initWithBytes:rs length:clen];
}
@end
