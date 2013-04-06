//
//  PersistentDirectory.m
//  LooCha
//
//  Created by XiongCaixing on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersistentDirectory.h"
static   NSMutableDictionary *fileAttributeDic;
@implementation PersistentDirectory

static NSString *documentPath = nil;
static NSString *libraryPath = nil;
static NSString *tmpPath = nil;

+ (NSString *)persistentDirectory:(NSString*)directory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    NSString *directoryPath = [basePath stringByAppendingPathComponent:directory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:directoryPath])
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    return directoryPath;
}

+ (UIImage *)cacheImage:(NSString*)fileName {
    NSString *cachePath = [PersistentDirectory persistentDirectory:@"cache"];
	NSString *path = [cachePath stringByAppendingPathComponent:fileName];
    UIImage *avatar = [UIImage imageWithContentsOfFile:path];
    return avatar;
}

+ (NSString *)cachePath:(NSString*)fileName {
    NSString *cachePath = [PersistentDirectory persistentDirectory:@"cache"];
	NSString *path = [cachePath stringByAppendingPathComponent:fileName];
    return path;
}

+ (void)updateModifiedDateForPath:(NSString *)path
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileAttributeDic = [[NSMutableDictionary alloc] init];
    });
    if([fileAttributeDic valueForKey:path])
        return; 
    [fileAttributeDic setValue:[NSNumber numberWithBool:YES] forKey:path];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attr = [fm attributesOfItemAtPath:path error:NULL];
    if (attr) {
        NSDate *lastModifiedDate = [attr fileModificationDate];
        NSDate *now = [NSDate date];
        NSTimeInterval delt = [now timeIntervalSinceDate:lastModifiedDate];
        if (delt > kModifiedDeltTime) {
            NSMutableDictionary *mAttr = [attr mutableCopy];
            [mAttr setObject:[NSDate date] forKey:NSFileModificationDate];
            [fm setAttributes:mAttr ofItemAtPath:path error:NULL];
            [mAttr release];
        }
    }
}

+(NSString *)createTmpFilePath
{
#define DOWN_LOAD_TMP_FOLDER   @"downloadTmp"
    NSString *libary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *folder = [libary stringByAppendingPathComponent:DOWN_LOAD_TMP_FOLDER];
    if (![fileManager fileExistsAtPath:folder])
    {
        [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return folder;
}

#pragma mark - path management

+ (NSString *)documentPath
{
    if (documentPath == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([paths count] > 0) {
            documentPath = [[paths objectAtIndex:0] retain];
        }
    }
    return documentPath;
}

+ (NSString *)libraryPath
{
    if (libraryPath == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        if ([paths count] > 0) {
            libraryPath = [[paths objectAtIndex:0] retain];
        }
    }
    return libraryPath;
}

+ (NSString *)tmpPath
{
    if (tmpPath == nil) {
        tmpPath = NSTemporaryDirectory();
        [tmpPath retain];
    }
    return tmpPath;
}

+ (NSString *)pathForType:(PathType)pathType
{
    switch (pathType) {
        case kPathTypeDoc:
            return [self documentPath];
            break;
            
        case kPathTypeLib:
            return [self libraryPath];
            break;
            
        case kPathTypeTmp:
            return [self tmpPath];
            break;
            
        default:
            break;
    }
    return nil;
}

+ (NSString *)pathWithSubpath:(NSString *)subpath pathType:(PathType)pathType
{
    NSString *path = [self pathForType:pathType];
    if (path) {
        return [path stringByAppendingPathComponent:subpath];
    }
    return nil;
}

+ (NSString *)createPathWithSubpath:(NSString *)subpath pathType:(PathType)pathType
{
    NSString *path = [self pathWithSubpath:subpath pathType:pathType];
    if (path) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return path;
}




@end
