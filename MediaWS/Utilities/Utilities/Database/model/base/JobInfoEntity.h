//
//  JobInfoEntity.h
//  DataBase
//
//  Created by hh k on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface JobInfoEntity : NSObject

@property(nonatomic,copy) NSString *Id;
@property(nonatomic,copy) NSString *command;
@property(nonatomic,copy) NSString *URL;
@property(nonatomic,copy) NSString *json;
@property(nonatomic,copy) NSString *fileURL;
@property(nonatomic,copy) NSString *taskId;
@property(nonatomic,copy) NSString *header;
@property(nonatomic,assign) int status;
@property(nonatomic,assign) BOOL isMainJob;

+(NSDictionary *)generateJobDic:(JobInfoEntity *)job;
@end
