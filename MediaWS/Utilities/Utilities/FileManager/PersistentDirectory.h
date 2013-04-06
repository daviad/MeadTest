//
//  PersistentDirectory.h
//  LooCha
//
//  Created by XiongCaixing on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// 访问文件A时，若A修改时间与当前时间间隔超过kModifiedDeltTime时，重新设置修改时间
#define kModifiedDeltTime 60

typedef enum {
    kPathTypeDoc,
    kPathTypeLib,
    kPathTypeTmp
} PathType;

@interface PersistentDirectory : NSObject

// 在cache目录下得到或者创建保存数据持久目录路径
+ (NSString *)persistentDirectory:(NSString*)directory;
+ (UIImage *)cacheImage:(NSString*)fileName;
+ (NSString *)cachePath:(NSString*)fileName;

+ (NSString *)createTmpFilePath;

+ (void)updateModifiedDateForPath:(NSString *)path;

+ (NSString *)pathForType:(PathType)pathType;

+ (NSString *)pathWithSubpath:(NSString *)subpath pathType:(PathType)pathType;

+ (NSString *)createPathWithSubpath:(NSString *)subpath pathType:(PathType)pathType;

@end
