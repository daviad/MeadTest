/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDImageCache.h"
#import "SDWebImageDecoder.h"
#import <CommonCrypto/CommonDigest.h>
#import "SDWebImageDecoder.h"
#import <mach/mach.h>
#import <mach/mach_host.h>

#import "SDWebImageManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <OpenGLES/ES2/gl.h>
#import "PersistentDirectory.h"
#import "UIImage+animatedGIF.h"

@implementation ImageSize
@synthesize width,height;
-(id)initWithSize:(CGSize)size
{
    self = [super init];
    if(self)
    {
        width = size.width;
        height = size.height;
    }
    return self;
}

@end




static SDImageCache *instance;

static NSInteger cacheMaxCacheAge = 60*60*24*7; // 1 week
//static natural_t minFreeMemLeft = UINT32_MAX;   //1024*1024*12; // reserve 12MB RAM
#define CACHEIMAGE  1
#if CACHEIMAGE
static natural_t minFreeMemLeft = 1024*1024*20; // reserve 20MB RAM
#else
static natural_t minFreeMemLeft = INT_MAX; 
#endif
// inspired by http://stackoverflow.com/questions/5012886/knowing-available-ram-on-an-ios-device
static natural_t get_free_memory(void)
{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;

    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);

    vm_statistics_data_t vm_stat;

    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
    {
        NSLog(@"Failed to fetch vm statistics");
        return 0;
    }

    /* Stats in bytes */
    natural_t mem_free = vm_stat.free_count * pagesize;
    return mem_free;
}

@implementation SDImageCache

@synthesize diskCachePath;
@synthesize URLToDelegatesMap;
#pragma mark NSObject

- (id)init
{
    if ((self = [super init]))
    {
        // Init the memory cache
        memCache = [[NSMutableDictionary alloc] init];
        memArray = [[NSMutableArray alloc] init];
        URLToDelegatesMap = [[NSMutableDictionary alloc] init];
        // Init the disk cache
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        diskCachePath = SDWIReturnRetained([[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"]);

        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }

        // Init the operation queue
        cacheInQueue = [[NSOperationQueue alloc] init];
        cacheInQueue.maxConcurrentOperationCount = 1;
        cacheOutQueue = [[NSOperationQueue alloc] init];
        cacheOutQueue.maxConcurrentOperationCount = 1;

#if TARGET_OS_IPHONE
        // Subscribe to app events
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0
        UIDevice *device = [UIDevice currentDevice];
        if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported)
        {
            // When in background, clean memory in order to have less chance to be killed
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(clearMemory)
                                                         name:UIApplicationDidEnterBackgroundNotification
                                                       object:nil];
        }
#endif
#endif
    }

    return self;
}

- (void)dealloc
{
    SDWISafeRelease(memCache);
    SDWISafeRelease(diskCachePath);
    SDWISafeRelease(cacheInQueue);
    SDWISafeRelease(memArray);
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    SDWISuperDealoc;
}

#pragma mark SDImageCache (class methods)

+ (SDImageCache *)sharedImageCache
{
    if (instance == nil)
    {
        instance = [[SDImageCache alloc] init];
    }

    return instance;
}

+ (void) setMaxCacheAge:(NSInteger)maxCacheAge
{
    cacheMaxCacheAge = maxCacheAge;
}

#pragma mark SDImageCache (private)

- (NSString *)cachePathForKey:(NSString *)key
{
    if ([key compare:kLocalFileScheme options:0 range:NSMakeRange(0, [kLocalFileScheme length])] == NSOrderedSame) {
        return [[NSURL URLWithString:key] path];
    }
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];

    return [diskCachePath stringByAppendingPathComponent:filename];
}

- (void)storeKeyWithDataToDisk:(NSArray *)keyAndData
{
    // Can't use defaultManager another thread
    NSFileManager *fileManager = [[NSFileManager alloc] init];

    NSString *key = [keyAndData objectAtIndex:0];
    NSData *data = [keyAndData count] > 1 ? [keyAndData objectAtIndex:1] : nil;

    if (data)
    {
        [fileManager createFileAtPath:[self cachePathForKey:key] contents:data attributes:nil];
    }
    else
    {
        // If no data representation given, convert the UIImage in JPEG and store it
        // This trick is more CPU/memory intensive and doesn't preserve alpha channel
        UIImage *image = SDWIReturnRetained([self imageFromKey:key fromDisk:YES]); // be thread safe with no lock
        if (image)
        {
#if TARGET_OS_IPHONE
            [fileManager createFileAtPath:[self cachePathForKey:key] contents:UIImageJPEGRepresentation(image, (CGFloat)1.0) attributes:nil];
#else
            NSArray*  representations  = [image representations];
            NSData* jpegData = [NSBitmapImageRep representationOfImageRepsInArray: representations usingType: NSJPEGFileType properties:nil];
            [fileManager createFileAtPath:[self cachePathForKey:key] contents:jpegData attributes:nil];
#endif
            SDWIRelease(image);
        }
    }

    SDWIRelease(fileManager);
}

- (void)notifyDelegate:(NSDictionary *)arguments
{
    NSString *key = [arguments objectForKey:@"key"];
    id <SDImageCacheDelegate> delegate = [arguments objectForKey:@"delegate"];
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:[arguments objectForKey:@"userInfo"]];
    UIImage *image = [arguments objectForKey:@"image"];
    if (image)
    {
        dispatch_block_t block = ^{
            if (get_free_memory() < minFreeMemLeft)
            {
                [self removeOldCache:20];
            }
            [memCache setObject:image forKey:key];
            [memArray addObject:key];
        };
        if([NSThread isMainThread])
            block();
        else
            dispatch_sync(dispatch_get_main_queue(), ^{block();});
        
        @synchronized(self.URLToDelegatesMap)
        {
            if([self.URLToDelegatesMap valueForKeyPath:key])
                [info setValue:[self.URLToDelegatesMap valueForKeyPath:key] forKey:@"delegate"];
            [self.URLToDelegatesMap removeObjectForKey:key];
            if ([delegate respondsToSelector:@selector(imageCache:didFindImage:forKey:userInfo:)])
            {
                [delegate imageCache:self didFindImage:image forKey:key userInfo:info];
            }
        }

    }
    else
    {
        if ([delegate respondsToSelector:@selector(imageCache:didNotFindImageForKey:userInfo:)])
        {
            [delegate imageCache:self didNotFindImageForKey:key userInfo:info];
        }
    }
}

- (void)queryLibrary:(NSDictionary *)arguments
{
    NSString *key = [arguments objectForKey:@"key"];
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:[NSURL URLWithString:key] resultBlock:^(ALAsset *asset) {
        NSDictionary *info = [arguments objectForKey:@"userInfo"];
        NSNumber *options = [info objectForKey:@"options"];
        CGImageRef image = nil;
        NSMutableDictionary *mutableArguments = [NSMutableDictionary dictionaryWithDictionary:arguments];
        ALAssetOrientation orie = ALAssetOrientationUp;
        if ([options intValue] & SDWebImageThumbnail) {
            image = [asset thumbnail];
        }
        else {
            ALAssetRepresentation *repr = [asset defaultRepresentation];
            orie = [repr orientation];
            image = [repr fullResolutionImage];
        }
        if (image) {
            UIImage *img = [[UIImage alloc] initWithCGImage:image scale:1.0 orientation:orie];
            if (img) {
                UIImage *decodedImage = [UIImage decodedImageWithImage:img];
                [mutableArguments setObject:decodedImage forKey:@"image"];
                [img release];
            }
        }
        [self performSelectorOnMainThread:@selector(notifyDelegate:) withObject:mutableArguments waitUntilDone:NO];
    } failureBlock:^(NSError *error){
        [self performSelectorOnMainThread:@selector(notifyDelegate:) withObject:arguments waitUntilDone:NO];
    }];
    [lib release];
}

- (void)queryDiskCacheOperation:(NSDictionary *)arguments
{
    NSString *key = [arguments objectForKey:@"key"];
    NSMutableDictionary *mutableArguments = SDWIReturnAutoreleased([arguments mutableCopy]);
    @synchronized(self.URLToDelegatesMap)
    {
        NSMutableSet *set = [self.URLToDelegatesMap valueForKey:key];
        id delegate = [arguments valueForKeyPath:@"userInfo.delegate"];
        if([delegate isKindOfClass:[UIImageView class]])
        {
            if(set)
            {
                
                [set addObject:delegate];
                return;
            }
            else
            {
                NSMutableSet *set = [NSMutableSet setWithObject:delegate];
                [self.URLToDelegatesMap setValue:set forKey:key];
                
            }
        }
    }
    if ([key compare:kAssetsLibraryScheme options:0 range:NSMakeRange(0, [kAssetsLibraryScheme length])] == NSOrderedSame) {
        [self queryLibrary:mutableArguments];
        return;
    }
    NSString *filepath = [self cachePathForKey:key];
    NSData *imgdata = [NSData dataWithContentsOfFile:filepath];
    
    UIImage *image;
    if([UIImage isGifImageWithData:imgdata])
        image = [UIImage animatedImageWithAnimatedGIFData:imgdata];
    else
    {
        image = SDScaledImageForPath(key, imgdata);
        if (image)
        {
            UIImage *decodedImage = [UIImage decodedImageWithImage:image];
            if (decodedImage)
                image = decodedImage;
        }
        
    }
    if (image)
    {
        [PersistentDirectory updateModifiedDateForPath:filepath];
        [mutableArguments setObject:image forKey:@"image"];
    }
    [self performSelectorOnMainThread:@selector(notifyDelegate:) withObject:mutableArguments waitUntilDone:NO];
}

#pragma mark ImageCache

- (void)storeImage:(UIImage *)image imageData:(NSData *)data forKey:(NSString *)key toDisk:(BOOL)toDisk
{
    if (!image || !key)
    {
        return;
    }
    
    dispatch_block_t block = ^{
        if (get_free_memory() < minFreeMemLeft)
        {
            [self removeOldCache:20];
        }
//        if(!image.images)
//        {
            [memCache setObject:image forKey:key];
            [memArray addObject:key];
//        }
    };
    if([NSThread isMainThread])
        block();
    else
        dispatch_sync(dispatch_get_main_queue(), ^{block();});
    
    if (toDisk)
    {
        NSArray *keyWithData;
        if (data)
        {
            keyWithData = [NSArray arrayWithObjects:key, data, nil];
        }
        else
        {
            keyWithData = [NSArray arrayWithObjects:key, nil];
        }

        NSInvocationOperation *operation = SDWIReturnAutoreleased([[NSInvocationOperation alloc] initWithTarget:self
                                                                                                       selector:@selector(storeKeyWithDataToDisk:)
                                                                                                         object:keyWithData]);
        [cacheInQueue addOperation:operation];
    }
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key
{
    [self storeImage:image imageData:nil forKey:key toDisk:YES];
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk
{
    [self storeImage:image imageData:nil forKey:key toDisk:toDisk];
}


- (UIImage *)imageFromKey:(NSString *)key
{
    return [self imageFromKey:key fromDisk:YES];
}

- (UIImage *)imageFromKey:(NSString *)key fromDisk:(BOOL)fromDisk
{
    if (key == nil)
    {
        return nil;
    }

    NSString *filepath = [self cachePathForKey:key];
    UIImage *image = [memCache objectForKey:key];

    if (!image && fromDisk)
    {
        image = SDScaledImageForPath(key, [NSData dataWithContentsOfFile:filepath]);
        if (image)
        {
            dispatch_block_t block = ^{
                if (get_free_memory() < minFreeMemLeft)
                {
                    [self removeOldCache:20];
                }
//                if(!image.images)
//                {
                    [memCache setObject:image forKey:key];
                    [memArray addObject:key];
//                }
            };
            if([NSThread isMainThread])
                block();
            else
                dispatch_sync(dispatch_get_main_queue(), ^{block();});
        }
    }
    if (image) {
        [PersistentDirectory updateModifiedDateForPath:filepath];
    }

    return image;
}

- (void)queryDiskCacheForKey:(NSString *)key delegate:(id <SDImageCacheDelegate>)delegate userInfo:(NSDictionary *)info
{
    if (!delegate)
    {
        return;
    }

    if (!key)
    {
        if ([delegate respondsToSelector:@selector(imageCache:didNotFindImageForKey:userInfo:)])
        {
            [delegate imageCache:self didNotFindImageForKey:key userInfo:info];
        }
        return;
    }

    // First check the in-memory cache...
    UIImage *image = [memCache objectForKey:key];
    if (image)
    {
        // ...notify delegate immediately, no need to go async
        if ([delegate respondsToSelector:@selector(imageCache:didFindImage:forKey:userInfo:)])
        {
            [delegate imageCache:self didFindImage:image forKey:key userInfo:info];
        }
        return;
    }
    
    NSMutableDictionary *arguments = [NSMutableDictionary dictionaryWithCapacity:3];
    [arguments setObject:key forKey:@"key"];
    [arguments setObject:delegate forKey:@"delegate"];
    if (info)
        [arguments setObject:info forKey:@"userInfo"];
    
    NSNumber *options = [info objectForKey:@"options"];
    NSString *filepath = [self cachePathForKey:key];
    NSURL *url = [NSURL fileURLWithPath:filepath];
    
    if([UIImage isGifImage:url])
    {
        options = [NSNumber numberWithInt:[options intValue] | SDWebImageAsyncLoadFromDisk];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:info];
        [dic setObject:options forKey:@"options"];
        [arguments setObject:dic forKey:@"userInfo"];
    }
    if (!([options intValue] & SDWebImageAsyncLoadFromDisk)) {
        if ([key compare:kAssetsLibraryScheme options:0 range:NSMakeRange(0, [kAssetsLibraryScheme length])] == NSOrderedSame) {
            [self queryLibrary:arguments];
            return;
        }
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                         forKey:(id)kCGImageSourceShouldCache];
        UIImage *retImage = nil;
        if(url)
        {
            CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
            if(source)
            {
                CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, 0, (CFDictionaryRef)dict);
                retImage = [UIImage imageWithCGImage:cgImage];
                CGImageRelease(cgImage);
                CFRelease(source);
            }
        }
        UIImage *image = retImage;
        if (image) {
            [PersistentDirectory updateModifiedDateForPath:filepath];
            [arguments setObject:image forKey:@"image"];
        }
        [self notifyDelegate:arguments];
        return;
    }
    
    NSInvocationOperation *operation = SDWIReturnAutoreleased([[NSInvocationOperation alloc] initWithTarget:self
                                                                                                   selector:@selector(queryDiskCacheOperation:)
                                                                                                     object:arguments]);
    [cacheOutQueue addOperation:operation];
}

- (void)removeImageForKey:(NSString *)key
{
    [self removeImageForKey:key fromDisk:YES];
}

- (void)removeImageForKey:(NSString *)key fromDisk:(BOOL)fromDisk
{
    if (key == nil)
    {
        return;
    }

    [memCache removeObjectForKey:key];

    if (fromDisk)
    {
        [[NSFileManager defaultManager] removeItemAtPath:[self cachePathForKey:key] error:nil];
    }
}

- (void)clearMemory
{
    [cacheInQueue cancelAllOperations]; // won't be able to complete
    if ([NSThread isMainThread])
    {
        [memCache removeAllObjects];
        [memArray removeAllObjects];

    }
    else
        dispatch_sync(dispatch_get_main_queue(), ^{
            [memCache removeAllObjects];
            [memArray removeAllObjects];

        });
}

- (void)clearDisk
{
    [cacheInQueue cancelAllOperations];
    [[NSFileManager defaultManager] removeItemAtPath:diskCachePath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
}

- (void)cleanDisk
{
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-cacheMaxCacheAge];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        if ([[[attrs fileModificationDate] laterDate:expirationDate] isEqualToDate:expirationDate])
        {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
}

-(int)getSize
{
    int size = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}

- (int)getDiskCount
{
    int count = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator)
    {
        count += 1;
    }
    
    return count;
}

- (int)getMemorySize
{
    int size = 0;
    
    for(id key in [memCache allKeys])
    {
        UIImage *img = [memCache valueForKey:key];
        size += [UIImageJPEGRepresentation(img, 0) length];
    };
    
    return size;
}

- (int)getMemoryCount
{
    return [[memCache allKeys] count];
}

-(void)removeOldCache:(int)number
{
    if([memCache count] <= number)
    {
        [memCache removeAllObjects];
        [memArray removeAllObjects];
        return;
    }
    NSMutableArray *tmparray = [[NSMutableArray alloc] init];
    int i = 0;
    for(i=0;i<number;i++)
    {
        [memCache removeObjectForKey:memArray[i]];
    }
    for(;i<[memArray count];i++)
    {
        [tmparray addObject:memArray[i]];
    }
    [memArray release];
    memArray = tmparray;


}

@end
