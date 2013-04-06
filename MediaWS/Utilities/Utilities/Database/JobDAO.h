//
//  JobDAO.h
//  LoochaUtilities
//
//  Created by hh k on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseDAO.h"
#import "TaskEntity.h"
#import "JobInfoEntity.h"

@interface JobDAO : BaseDAO
-(NSArray *)searchJobByTaskId:(NSString *)taskId;
-(void)updateJobDependency:(NSString *)taskId;
-(void)updateMainJobJson:(NSString *)atachmentId withTaskId:(NSString*)taskId;
-(void)updateStatus:(int)status byId:(int)Id;
-(void)updateStatus:(int)status ByTask:(id)key;
-(NSArray *)searchRunningJobByURL:(NSString *)url;
-(BOOL)resetJobByTask:(id)key;
@end
