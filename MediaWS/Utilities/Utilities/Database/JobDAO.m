//
//  JobDAO.m
//  LoochaUtilities
//
//  Created by hh k on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JobDAO.h"
#import "UpLoadResourceConstants.h"
@implementation JobDAO
-(id)init
{
    self = [super init];
    if(self)
    {
        self.tableName = TABLE_NAME_JOB;
    }
    return self;
}



-(NSArray *)searchJobByTaskId:(NSString *)taskId
{
    if(!taskId || [taskId isEqualToString:@""]) return nil;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:taskId,JOB_TASK_ID ,nil];
    NSString *sql = [self generateQuerySQLWith:dic];
    sql = [sql stringByAppendingFormat:@" AND %@ = %d",JOB_STATUS,jobIsReady];
    NSArray *result = [self searchWithSQL:sql param:dic type:0 waitUntiDone:YES];
    for (NSDictionary *dic in result)
        [self updateStatus:jobProcessing byId:[[dic valueForKey:JOB_ID] intValue]];
    return result;
}


#define SEARCH_JOB_BY_URL @"select "JOB_TASK_ID" from "TABLE_NAME_JOB" where"JOB_URL" = '%@' and ("JOB_STATUS" = %d or "JOB_STATUS" = %d)"
-(NSArray *)searchRunningJobByURL:(NSString *)url
{
    if(!url || [url isEqualToString:@""]) return nil;
    NSString *sql = [NSString stringWithFormat:SEARCH_JOB_BY_URL,url,jobIsReady,jobProcessing];
    return [self searchWithSQL:sql type:0 waitUntiDone:YES];
}



-(void)updateStatus:(int)status byId:(int)Id
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:status],JOB_STATUS, nil];
    NSString *sql = [self generateUpdateSQL:dic withPrimeKey:[NSNumber numberWithInt:Id]];
    [self update:sql parameter:dic type:0 waitUntilDone:YES];
}

#define UPDATE_JOB_DEPENDENCY @"update "TABLE_NAME_JOB" set "JOB_STATUS" = "JOB_STATUS" + 1 where "JOB_TASK_ID" = '%@' AND "JOB_STATUS" < %d "
-(void)updateJobDependency:(NSString *)taskId
{
    NSString *sql = [NSString stringWithFormat:UPDATE_JOB_DEPENDENCY,taskId,jobIsReady];
    [self update:sql parameter:nil type:0 waitUntilDone:YES];
}


-(void)updateMainJobJson:(NSString *)attachmentId withTaskId:(NSString*)taskId
{
    if(!taskId || [taskId isEqualToString:@""] || !attachmentId || [attachmentId isEqualToString:@""]) return;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:taskId,JOB_TASK_ID ,nil];
    NSArray *result = [self search:dic type:0 waitUntiDone:YES];
    NSString *json = [[result lastObject] valueForKey:JOB_JSON];
    if([json containsString:MARK_ITEMID])
    {
        [[result lastObject] setValue:[json stringByReplacingCharactersInRange:[json rangeOfString:MARK_ITEMID] withString:attachmentId] forKey:JOB_JSON];
        [self save:[result lastObject] type:0 waitUntilDone:YES];
    }
}
#define UPDATE_JOB_STATUS @"update "TABLE_NAME_JOB" set "JOB_STATUS" = %d + 1 where "JOB_TASK_ID" = '%@' "
-(void)updateStatus:(int)status ByTask:(id)key
{
    NSString *sql = [NSString stringWithFormat:UPDATE_JOB_STATUS,status,key];
    [self excute:sql type:0 waitUntilDone:YES];
    
}

#define RESET_JOB_STATUS @"select * from "TABLE_NAME_JOB" where "JOB_TASK_ID" = '%@' AND "JOB_STATUS" != %d"
-(BOOL)resetJobByTask:(id)key
{
    NSString *sql = [NSString stringWithFormat:RESET_JOB_STATUS,key,jobFinished];
    id jobs = [self searchWithSQL:sql type:0 waitUntiDone:YES];
    if(![jobs count])
        return NO;
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[jobs count]];
    int i = 0;
    for(id dic in jobs)
    {
        NSMutableDictionary *job = [NSMutableDictionary dictionaryWithDictionary:dic];
        [job setValue:[NSNumber numberWithInt:jobIsReady - i++] forKey:JOB_STATUS];
        [array addObject:job];
    }
    [self save:array type:kTaskMsgSaveJob waitUntilDone:NO];
    [array release];
    return YES;
}


@end
