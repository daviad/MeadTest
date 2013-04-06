//
//  TaskDAO.m
//  LoochaUtilities
//
//  Created by hh k on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TaskDAO.h"
#import "UpLoadResourceConstants.h"
#import "DatabaseConstants.h"

@implementation TaskDAO
-(id)init
{
    self = [super init];
    if(self)
    {
        self.tableName = TABLE_NAME_TASK;
    }
    return self;
}


-(NSArray *)searchTaskByStatusAndSetStatus:(NSString *)status
{
    if(!status || [status isEqualToString:@""]) return nil;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:status,TASK_STATUS ,nil];
    NSArray *result = [self search:dic type:0 waitUntiDone:YES];
    for(NSDictionary *dic in result)
        [self updateType:uploadProcessing  byId:[dic valueForKey:TASK_ID]];
    return result;
}

-(void)updateType:(int)type byId:(NSString *)Id
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",type],TASK_STATUS, nil];
    NSString *sql = [self generateUpdateSQL:dic withPrimeKey:Id];
    sql = [sql stringByAppendingFormat:@" AND %@ < %d ",TASK_STATUS ,type];
    [self update:sql parameter:dic type:0 waitUntilDone:YES];
}
@end
