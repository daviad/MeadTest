//
//  RCDownloader.m
//  LoochaUtilities
//
//  Created by jinquan zhang on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCDownloader.h"

#import "SDImageCache.h"

@implementation RCDownloader

static RCDownloader *instance;

+ (RCDownloader *)sharedInstance
{
    if (instance == nil) {
        instance = [[RCDownloader alloc] init];
    }
    return instance;
}

- (oneway void)release
{
    
}

- (id)retain
{
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        delegates = [[NSMutableArray alloc] init];
        requests = [[NSMutableArray alloc] init];
        networkQueue = [[ASINetworkQueue alloc] init];
        networkQueue.shouldCancelAllRequestsOnFailure = NO;
        networkQueue.showAccurateProgress = YES;
        [networkQueue go];
    }
    return self;
}

- (void)downloadWithURL:(NSURL *)url delegate:(id<RCDownloaderDelegate>)delegate
{
    [self downloadWithURL:url dstPath:nil delegate:delegate];
}

- (void)downloadWithURL:(NSURL *)url dstPath:(NSString *)dstPath delegate:(id<RCDownloaderDelegate>)delegate
{
    if ([delegates indexOfObject:delegate] != NSNotFound) {
        RCWarn(@"delegate has been exist in delegates - ignore");
        return;
    }
    if (dstPath == nil) {
        dstPath = [[SDImageCache sharedImageCache] cachePathForKey:[url absoluteString]];
    }
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    request.delegate = self;
    request.downloadProgressDelegate = self;
    request.timeOutSeconds = 30;
    request.allowResumeForFileDownloads = YES;
    request.didFinishSelector = @selector(loadFinished:);
    request.didFailSelector = @selector(loadFailed:);
    request.downloadDestinationPath = dstPath;
    request.temporaryFileDownloadPath = [dstPath stringByAppendingString:@".tmp"];
    [requests addObject:request];
    [delegates addObject:delegate];
    [networkQueue addOperation:request];
    [request release];
}

- (id<RCDownloaderDelegate>)delegateForRequest:(ASIHTTPRequest *)request
{
    NSUInteger idx = [requests indexOfObject:request];
    if (idx != NSNotFound) {
        return [delegates objectAtIndex:idx];
    }
    return nil;
}

- (ASIHTTPRequest *)requestForDelegate:(id<RCDownloaderDelegate>)delegate
{
    NSUInteger idx = [delegates indexOfObject:delegate];
    if (idx != NSNotFound) {
        return [requests objectAtIndex:idx];
    }
    return nil;
}

- (void)cancelForDelegate:(id<RCDownloaderDelegate>)delegate
{
    NSUInteger idx = [delegates indexOfObject:delegate];
    if (idx != NSNotFound) {
        [[requests objectAtIndex:idx] cancel];
    }
}

#pragma mark ASIProgressDelegate

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    id<RCDownloaderDelegate> delegate = [self delegateForRequest:request];
    if (delegate && [delegate respondsToSelector:@selector(downloadingWithRequest:didProgressWithRate:)]) {
        CGFloat cur = request.totalBytesRead + request.partialDownloadSize;
        CGFloat total = request.contentLength + request.partialDownloadSize;
        CGFloat rate = cur/total;
        [delegate downloadingWithRequest:request didProgressWithRate:rate];
    }
}

- (void)loadFinished:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode >= 400) {
        [[NSFileManager defaultManager] removeItemAtPath:request.downloadDestinationPath error:NULL];
        request.error = [NSError errorWithDomain:NetworkRequestErrorDomain code:request.responseStatusCode userInfo:request.userInfo];
        [self loadFailed:request];
        return;
    }
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(loadFinished:) withObject:request waitUntilDone:NO];
        return;
    }
    id<RCDownloaderDelegate> delegate = [self delegateForRequest:request];
    if (delegate) {
        if ([delegate respondsToSelector:@selector(downloadDidFinishWithRequest:)]) {
            [delegate downloadDidFinishWithRequest:request];
        }
        [requests removeObject:request];
        [delegates removeObject:delegate];
    }
}

- (void)loadFailed:(ASIHTTPRequest *)request
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(loadFailed:) withObject:request waitUntilDone:NO];
        return;
    }
    id<RCDownloaderDelegate> delegate = [self delegateForRequest:request];
    if (delegate) {
        if ([delegate respondsToSelector:@selector(downloadDidFailWithRequest:error:)]) {
            [delegate downloadDidFailWithRequest:request error:request.error];
        }
        [requests removeObject:request];
        [delegates removeObject:delegate];
    }
}

@end
