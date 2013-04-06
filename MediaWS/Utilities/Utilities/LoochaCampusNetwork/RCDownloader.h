//
//  RCDownloader.h
//  LoochaUtilities
//
//  Created by jinquan zhang on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

@protocol RCDownloaderDelegate <NSObject>

@optional

- (void)downloadingWithRequest:(ASIHTTPRequest *)request didProgressWithRate:(CGFloat)progress;

- (void)downloadDidFinishWithRequest:(ASIHTTPRequest *)request;

- (void)downloadDidFailWithRequest:(ASIHTTPRequest *)request error:(NSError *)error;

@end

@interface RCDownloader : NSObject <ASIProgressDelegate>
{
    NSMutableArray *delegates;
    NSMutableArray *requests;
    ASINetworkQueue *networkQueue;
}

+ (RCDownloader *)sharedInstance;

- (void)downloadWithURL:(NSURL *)url delegate:(id<RCDownloaderDelegate>)delegate;

- (void)downloadWithURL:(NSURL *)url dstPath:(NSString *)dstPath delegate:(id<RCDownloaderDelegate>)delegate;

- (void)cancelForDelegate:(id<RCDownloaderDelegate>)delegate;

@end
