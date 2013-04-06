//
//  JobInfoEntity.m
//  DataBase
//
//  Created by hh k on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JobInfoEntity.h"
#import "DatabaseConstants.h"

@implementation JobInfoEntity

@synthesize Id = _Id;
@synthesize command = _command;
@synthesize URL = _URL;
@synthesize json = _json;
@synthesize fileURL = _fileURL;
@synthesize taskId = _taskId;
@synthesize status = _status;
@synthesize header = _header;
@synthesize isMainJob = _isMainJob;
-(void)dealloc
{
    [_Id release];
    [_command release];
    [_URL release];
    [_json release];
    [_fileURL release];
    [_taskId release];
    [super dealloc];
}

+(NSDictionary *)generateJobDic:(JobInfoEntity *)job
{
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    [dic setValue:job.command forKey:JOB_COMMAND];
    [dic setValue:job.URL forKey:JOB_URL];
    [dic setValue:job.json forKey:JOB_JSON];
    [dic setValue:job.fileURL forKey:JOB_FILE_PATH];
    [dic setValue:job.taskId forKey:JOB_TASK_ID];
    [dic setValue:job.header forKey:JOB_HEADER];
    [dic setValue:[NSNumber numberWithInt:job.status] forKey:JOB_STATUS];
    [dic setValue:[NSNumber numberWithBool:job.isMainJob] forKey:JOB_IS_MAIN];
    return dic;
}


@end
