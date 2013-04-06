/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageManager.h"
#import "SDImageCache.h"
//#import "SDWebImageDownloader.h"
#import <objc/message.h>

#import "ASIHTTPRequest.h"

static SDWebImageManager *instance;

@implementation SDWebImageManager

#if NS_BLOCKS_AVAILABLE
@synthesize cacheKeyFilter;
#endif

- (id)init
{
    if ((self = [super init]))
    {
        downloadInfo = [[NSMutableArray alloc] init];
        downloadDelegates = [[NSMutableArray alloc] init];
        downloaders = [[NSMutableArray alloc] init];
        cacheDelegates = [[NSMutableArray alloc] init];
        cacheURLs = [[NSMutableArray alloc] init];
        downloaderForURL = [[NSMutableDictionary alloc] init];
        failedURLs = [[NSMutableArray alloc] init];
        networkQueue = [[ASINetworkQueue alloc] init];
        networkQueue.maxConcurrentOperationCount = 2;
        networkQueue.shouldCancelAllRequestsOnFailure = NO;
        networkQueue.showAccurateProgress = YES;
        [networkQueue go];
    }
    return self;
}

- (void)dealloc
{
    SDWISafeRelease(downloadInfo);
    SDWISafeRelease(downloadDelegates);
    SDWISafeRelease(downloaders);
    SDWISafeRelease(cacheDelegates);
    SDWISafeRelease(cacheURLs);
    SDWISafeRelease(downloaderForURL);
    SDWISafeRelease(failedURLs);
    SDWISafeRelease(networkQueue);
    SDWISuperDealoc;
}


+ (id)sharedManager
{
    if (instance == nil)
    {
        instance = [[SDWebImageManager alloc] init];
    }

    return instance;
}

- (NSString *)cacheKeyForURL:(NSURL *)url
{
#if NS_BLOCKS_AVAILABLE
    if (self.cacheKeyFilter)
    {
        return self.cacheKeyFilter(url);
    }
    else
    {
        return [url absoluteString];
    }
#else
    return [url absoluteString];
#endif
}

/*
 * @deprecated
 */
- (UIImage *)imageWithURL:(NSURL *)url
{
    return [[SDImageCache sharedImageCache] imageFromKey:[self cacheKeyForURL:url]];
}

/*
 * @deprecated
 */
- (void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed
{
    [self downloadWithURL:url delegate:delegate options:(retryFailed ? SDWebImageRetryFailed : 0)];
}

/*
 * @deprecated
 */
- (void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed lowPriority:(BOOL)lowPriority
{
    SDWebImageOptions options = 0;
    if (retryFailed) options |= SDWebImageRetryFailed;
    if (lowPriority) options |= SDWebImageLowPriority;
    [self downloadWithURL:url delegate:delegate options:options];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)delegate
{
    [self downloadWithURL:url delegate:delegate options:0];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)delegate options:(SDWebImageOptions)options
{
    [self downloadWithURL:url delegate:delegate options:options userInfo:nil];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)delegate options:(SDWebImageOptions)options userInfo:(NSDictionary *)userInfo
{
    // Very common mistake is to send the URL using NSString object instead of NSURL. For some strange reason, XCode won't
    // throw any warning for this type mismatch. Here we failsafe this error by allowing URLs to be passed as NSString.
    if ([url isKindOfClass:NSString.class])
    {
        url = [NSURL URLWithString:(NSString *)url];
    }
    else if (![url isKindOfClass:NSURL.class])
    {
        url = nil; // Prevent some common crashes due to common wrong values passed like NSNull.null for instance
    }

    if (!url || !delegate || (!(options & SDWebImageRetryFailed) && [failedURLs containsObject:url]))
    {
        return;
    }
    
    // Check the on-disk cache async so we don't block the main thread
    [cacheDelegates addObject:delegate];
    [cacheURLs addObject:url];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          delegate, @"delegate",
                          url, @"url",
                          [NSNumber numberWithInt:options], @"options",
                          userInfo ? userInfo : [NSNull null], @"userInfo",
                          nil];
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:[self cacheKeyForURL:url] delegate:self userInfo:info];
}

#if NS_BLOCKS_AVAILABLE
- (void)downloadWithURL:(NSURL *)url delegate:(id)delegate options:(SDWebImageOptions)options success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure
{
    [self downloadWithURL:url delegate:delegate options:options userInfo:nil success:success failure:failure];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id)delegate options:(SDWebImageOptions)options userInfo:(NSDictionary *)userInfo success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure
{
    // repeated logic from above due to requirement for backwards compatability for iOS versions without blocks
    
    // Very common mistake is to send the URL using NSString object instead of NSURL. For some strange reason, XCode won't
    // throw any warning for this type mismatch. Here we failsafe this error by allowing URLs to be passed as NSString.
    if ([url isKindOfClass:NSString.class])
    {
        url = [NSURL URLWithString:(NSString *)url];
    }
    
    if (!url || !delegate || (!(options & SDWebImageRetryFailed) && [failedURLs containsObject:url]))
    {
        return;
    }
    
    // Check the on-disk cache async so we don't block the main thread
    [cacheDelegates addObject:delegate];
    [cacheURLs addObject:url];
    SDWebImageSuccessBlock successCopy = [success copy];
    SDWebImageFailureBlock failureCopy = [failure copy];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          delegate, @"delegate",
                          url, @"url",
                          [NSNumber numberWithInt:options], @"options",
                          userInfo ? userInfo : [NSNull null], @"userInfo",
                          successCopy, @"success",
                          failureCopy, @"failure",
                          nil];
    SDWIRelease(successCopy);
    SDWIRelease(failureCopy);
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:[self cacheKeyForURL:url] delegate:self userInfo:info];
}
#endif

- (void)cancelForDelegate:(id<SDWebImageManagerDelegate>)delegate
{
    NSUInteger idx;
    while ((idx = [cacheDelegates indexOfObjectIdenticalTo:delegate]) != NSNotFound)
    {
        [cacheDelegates removeObjectAtIndex:idx];
        [cacheURLs removeObjectAtIndex:idx];
    }

    while ((idx = [downloadDelegates indexOfObjectIdenticalTo:delegate]) != NSNotFound)
    {
//        SDWebImageDownloader *downloader = SDWIReturnRetained([downloaders objectAtIndex:idx]);
        ASIHTTPRequest *downloader = SDWIReturnRetained([downloaders objectAtIndex:idx]);

        [downloadInfo removeObjectAtIndex:idx];
        [downloadDelegates removeObjectAtIndex:idx];
        [downloaders removeObjectAtIndex:idx];

        if (![downloaders containsObject:downloader])
        {
            // No more delegate are waiting for this download, cancel it
            [downloader cancel];
            [downloaderForURL removeObjectForKey:downloader.url];
        }

        SDWIRelease(downloader);
    }
}

- (void)cancelForDelegate:(id<SDWebImageManagerDelegate>)delegate url:(NSURL *)url
{
    if (url == nil) {
        [self cancelForDelegate:delegate];
        return;
    }
    NSInteger idx;
    for (idx = [cacheDelegates count]-1; idx >= 0; idx--) {
        if ([cacheDelegates objectAtIndex:idx] == delegate
            && [[cacheURLs objectAtIndex:idx] isEqual:url]) {
            [cacheDelegates removeObjectAtIndex:idx];
            [cacheURLs removeObjectAtIndex:idx];
        }
        if ([downloadDelegates objectAtIndex:idx] == delegate) {
            ASIHTTPRequest *downloader = [downloaders objectAtIndex:idx];
            
            if ([downloader.url isEqual:url]) {
                SDWIReturnRetained([downloaders objectAtIndex:idx]);
                
                [downloadInfo removeObjectAtIndex:idx];
                [downloadDelegates removeObjectAtIndex:idx];
                [downloaders removeObjectAtIndex:idx];
                if (![downloaders containsObject:downloader])
                {
                    // No more delegate are waiting for this download, cancel it
                    [downloader cancel];
                    [downloaderForURL removeObjectForKey:downloader.url];
                }
                
                SDWIRelease(downloader);
            }
            
        }
    }
}

#pragma mark SDImageCacheDelegate

- (NSUInteger)indexOfDelegate:(id<SDWebImageManagerDelegate>)delegate waitingForURL:(NSURL *)url
{
    // Do a linear search, simple (even if inefficient)
    NSUInteger idx;
    for (idx = 0; idx < [cacheDelegates count]; idx++)
    {
        if ([cacheDelegates objectAtIndex:idx] == delegate && [[cacheURLs objectAtIndex:idx] isEqual:url])
        {
            return idx;
        }
    }
    return NSNotFound;
}

- (void)imageCache:(SDImageCache *)imageCache didFindImage:(UIImage *)image forKey:(NSString *)key userInfo:(NSDictionary *)info
{
    NSURL *url = [info objectForKey:@"url"];
    
    if([[info objectForKey:@"delegate"] isKindOfClass:[NSSet class]])
    {
        
        for(id<SDWebImageManagerDelegate> delegate in [info objectForKey:@"delegate"])
        {
            
            if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:)])
            {
                [delegate performSelector:@selector(webImageManager:didFinishWithImage:) withObject:self withObject:image];
            }
            if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:forURL:)])
            {
                objc_msgSend(delegate, @selector(webImageManager:didFinishWithImage:forURL:), self, image, url);
            }
            if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:forURL:userInfo:)])
            {
                NSDictionary *userInfo = [info objectForKey:@"userInfo"];
                if ([userInfo isKindOfClass:NSNull.class])
                {
                    userInfo = nil;
                }
                objc_msgSend(delegate, @selector(webImageManager:didFinishWithImage:forURL:userInfo:), self, image, url, userInfo);
            }
#if NS_BLOCKS_AVAILABLE
            if ([info objectForKey:@"success"])
            {
                SDWebImageSuccessBlock success = [info objectForKey:@"success"];
                success(image, YES);
            }
#endif
            
            NSUInteger idx = [self indexOfDelegate:delegate waitingForURL:url];
            if (idx != NSNotFound)
            {
                [cacheDelegates removeObjectAtIndex:idx];
                [cacheURLs removeObjectAtIndex:idx];
            }
        }
        
        
    }
    else
    {
        id<SDWebImageManagerDelegate> delegate = [info objectForKey:@"delegate"];

        NSUInteger idx = [self indexOfDelegate:delegate waitingForURL:url];
        if (idx == NSNotFound)
        {
            // Request has since been canceled
            return;
        }

        if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:)])
        {
            [delegate performSelector:@selector(webImageManager:didFinishWithImage:) withObject:self withObject:image];
        }
        if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:forURL:)])
        {
            objc_msgSend(delegate, @selector(webImageManager:didFinishWithImage:forURL:), self, image, url);
        }
        if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:forURL:userInfo:)])
        {
            NSDictionary *userInfo = [info objectForKey:@"userInfo"];
            if ([userInfo isKindOfClass:NSNull.class])
            {
                userInfo = nil;
            }
            objc_msgSend(delegate, @selector(webImageManager:didFinishWithImage:forURL:userInfo:), self, image, url, userInfo);
        }
    #if NS_BLOCKS_AVAILABLE
        if ([info objectForKey:@"success"])
        {
            SDWebImageSuccessBlock success = [info objectForKey:@"success"];
            success(image, YES);
        }
    #endif

        [cacheDelegates removeObjectAtIndex:idx];
        [cacheURLs removeObjectAtIndex:idx];
    }
}

#define kHTTPScheme @"http://"

- (BOOL)isSupportedURL:(NSString *)url
{
    return [url compare:kHTTPScheme options:0 range:NSMakeRange(0, [kHTTPScheme length])] == NSOrderedSame;
}

- (void)imageCache:(SDImageCache *)imageCache didNotFindImageForKey:(NSString *)key userInfo:(NSDictionary *)info
{
    NSURL *url = [info objectForKey:@"url"];
    
    id<SDWebImageManagerDelegate> delegate = [info objectForKey:@"delegate"];
    
//    SDWebImageOptions options = [[info objectForKey:@"options"] intValue];

    NSUInteger idx = [self indexOfDelegate:delegate waitingForURL:url];
    if (idx == NSNotFound)
    {
        // Request has since been canceled
        return;
    }

    if (![self isSupportedURL:[url absoluteString]]) {
        RCError(@"Not support url : %@", url);
        [self reportFailure:delegate info:info error:[NSError errorWithDomain:NSURLErrorKey code:-1 userInfo:nil]];
        
        [cacheDelegates removeObjectAtIndex:idx];
        [cacheURLs removeObjectAtIndex:idx];
        return;
    }
    
    [cacheDelegates removeObjectAtIndex:idx];
    [cacheURLs removeObjectAtIndex:idx];
    
    // Share the same downloader for identical URLs so we don't download the same URL several times
    // Modified: by zhangjinquan. Begin
    /* 
    SDWebImageDownloader *downloader = [downloaderForURL objectForKey:url];
    if (!downloader)
    {
        downloader = [SDWebImageDownloader downloaderWithURL:url delegate:self userInfo:info lowPriority:(options & SDWebImageLowPriority)];
        [downloaderForURL setObject:downloader forKey:url];
    }
    else
    {
        // Reuse shared downloader
        downloader.lowPriority = (options & SDWebImageLowPriority);
    }

    if ((options & SDWebImageProgressiveDownload) && !downloader.progressive)
    {
        // Turn progressive download support on demand
        downloader.progressive = YES;
    }
     */
    ASIHTTPRequest *downloader = [downloaderForURL objectForKey:url];
    if (!downloader) {
        NSString *cachePath = [[SDImageCache sharedImageCache] cachePathForKey:[url absoluteString]];
        downloader = [[ASIHTTPRequest alloc] initWithURL:url];
        downloader.delegate = self;
        downloader.downloadProgressDelegate = self;
        downloader.timeOutSeconds = 30;
        downloader.allowResumeForFileDownloads = YES;
        downloader.didFinishSelector = @selector(loadFinished:);
        downloader.didFailSelector = @selector(loadFailed:);
        downloader.downloadDestinationPath = cachePath;
        downloader.temporaryFileDownloadPath = [cachePath stringByAppendingString:@".tmp"];
        [downloader setQueuePriority:NSOperationQueuePriorityVeryLow];
        [downloaderForURL setObject:downloader forKey:url];
        
        RCTrace(@"starting new downloader with URL : %@, delegate : %@", url, delegate);
        
        [networkQueue addOperation:downloader];
        SDWIRelease(downloader);
    }
    else {
        // Reuse shared downloader
    }
    // Modified: by zhangjinquan. End
    [downloadInfo addObject:info];
    [downloadDelegates addObject:delegate];
    [downloaders addObject:downloader];
}

#pragma mark ASIHTTPRequest callbacks

- (void)reportFailure:(id<SDWebImageManagerDelegate>)delegate info:(NSDictionary *)info error:(NSError *)error
{
    NSURL *url = [info objectForKey:@"url"];
    if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:)])
    {
        [delegate performSelector:@selector(webImageManager:didFailWithError:) withObject:self withObject:error];
    }
    if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:forURL:)])
    {
        objc_msgSend(delegate, @selector(webImageManager:didFailWithError:forURL:), self, error, url);
    }
    if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:forURL:userInfo:)])
    {
        NSDictionary *userInfo = [info objectForKey:@"userInfo"];
        if ([userInfo isKindOfClass:NSNull.class])
        {
            userInfo = nil;
        }
        objc_msgSend(delegate, @selector(webImageManager:didFailWithError:forURL:userInfo:), self, error, url, userInfo);
    }
#if NS_BLOCKS_AVAILABLE
    if ([info objectForKey:@"failure"])
    {
        SDWebImageFailureBlock failure = [info objectForKey:@"failure"];
        failure(error);
    }
#endif
}

- (void)loadFinished:(ASIHTTPRequest *)downloader
{
    if (downloader.responseStatusCode >= 400) {
        [[NSFileManager defaultManager] removeItemAtPath:downloader.downloadDestinationPath error:NULL];
        downloader.error = [NSError errorWithDomain:NetworkRequestErrorDomain code:downloader.responseStatusCode userInfo:downloader.userInfo];
        [self loadFailed:downloader];
        return;
    }
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(loadFinished:) withObject:downloader waitUntilDone:NO];
        return;
    }
    for (NSInteger idx = (NSInteger)[downloaders count] - 1; idx >= 0; idx--) {
        NSUInteger uidx = (NSUInteger)idx;
        ASIHTTPRequest *aDownloader = [downloaders objectAtIndex:uidx];
        if (aDownloader == downloader) {
            [downloaders removeObjectAtIndex:uidx];
            
            id delegate = [downloadDelegates objectAtIndex:uidx];
            
            RCTrace(@"loadFinished with URL : %@, delegate : %@", downloader.url, delegate);
            
            [cacheURLs addObject:downloader.url];
            [cacheDelegates addObject:delegate];
            [downloadDelegates removeObjectAtIndex:uidx];
            
            NSDictionary *userInfo = [downloadInfo objectAtIndex:uidx];
            [[SDImageCache sharedImageCache] queryDiskCacheForKey:[self cacheKeyForURL:downloader.url] delegate:self userInfo:userInfo];
            [downloadInfo removeObjectAtIndex:uidx];
        }
    }
    [downloaderForURL removeObjectForKey:downloader.url];
}

- (void)loadFailed:(ASIHTTPRequest *)downloader
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(loadFailed:) withObject:downloader waitUntilDone:NO];
        return;
    }
    NSError *error = downloader.error;
    RCError(@"loadFailed : %@", downloader.error);
    
    if ([error.domain isEqualToString:NetworkRequestErrorDomain]
        && error.code == ASIRequestCancelledErrorType) {
        return;
    }
    SDWIRetain(downloader);
    
    // Notify all the downloadDelegates with this downloader
    for (NSInteger idx = (NSInteger)[downloaders count] - 1; idx >= 0; idx--)
    {
        NSUInteger uidx = (NSUInteger)idx;
        ASIHTTPRequest *aDownloader = [downloaders objectAtIndex:uidx];
        if (aDownloader == downloader)
        {
            id<SDWebImageManagerDelegate> delegate = [downloadDelegates objectAtIndex:uidx];
            SDWIRetain(delegate);
            SDWIAutorelease(delegate);
            
            [self reportFailure:delegate info:[downloadInfo objectAtIndex:uidx] error:downloader.error];
            
            [downloaders removeObjectAtIndex:uidx];
            [downloadInfo removeObjectAtIndex:uidx];
            [downloadDelegates removeObjectAtIndex:uidx];
        }
    }
    
    // Release the downloader
    [downloaderForURL removeObjectForKey:downloader.url];
    SDWIRelease(downloader);
}

#pragma mark ASIProgressDelegate

- (void)request:(ASIHTTPRequest *)downloader didReceiveBytes:(long long)bytes
{
    CGFloat cur = downloader.totalBytesRead + downloader.partialDownloadSize;
    CGFloat total = downloader.contentLength + downloader.partialDownloadSize;
    CGFloat rate = cur/total;
    for (NSInteger idx = (NSInteger)[downloaders count] - 1; idx >= 0; idx--) {
        NSUInteger uidx = (NSUInteger)idx;
        ASIHTTPRequest *aDownloader = [downloaders objectAtIndex:uidx];
        if (aDownloader == downloader) {
            id delegate = [downloadDelegates objectAtIndex:uidx];
            NSDictionary *info = [downloadInfo objectAtIndex:uidx];
            SDWebImageOptions options = [[info objectForKey:@"options"] intValue];
            if (options & SDWebImageProgressRated) {
                if ([delegate respondsToSelector:@selector(webImageManager:didProgressWithRate:forURL:userInfo:)]) {
                    NSDictionary *userInfo = [info objectForKey:@"userInfo"];
                    [delegate webImageManager:self didProgressWithRate:rate forURL:downloader.url userInfo:userInfo];
                }
            }
        }
    }
}

@end
