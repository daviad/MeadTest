//
//  TaskEntity.m
//  LoochaCampus
//
//  Created by hh k on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TaskEntity.h"
#import "DatabaseConstants.h"


@implementation TaskEntity
@synthesize taskId = _taskId;
@synthesize type = _type;
@synthesize status = _status;
@synthesize tableName = _tableName;
@synthesize userId = _userId;

-(void)dealloc
{
    [_taskId release];
    [_type release];
    [_status release];
    [_tableName release];
    [_userId release];
    [super dealloc];
}


+(NSDictionary *)generateTaskDic:(TaskEntity *)task
{
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];

    [dic setValue:task.taskId forKey:TASK_ID];
    [dic setValue:task.type forKey:TASK_TYPE];
    [dic setValue:task.status forKey:TASK_STATUS];
    [dic setValue:task.tableName forKey:TASK_TABLENAME];
    [dic setValue:task.userId forKey:TASK_USERID];
    return dic;
}
@end
