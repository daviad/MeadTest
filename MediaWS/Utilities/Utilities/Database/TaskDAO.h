//
//  TaskDAO.h
//  LoochaUtilities
//
//  Created by hh k on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseDAO.h"
#import "TaskEntity.h"
#import "JobInfoEntity.h"

@interface TaskDAO : BaseDAO


-(NSArray *)searchTaskByStatusAndSetStatus:(NSString *)status;
-(void)updateType:(int)type byId:(NSString *)Id;
@end
