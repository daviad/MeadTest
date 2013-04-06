//
//  TaskEntity.h
//  LoochaCampus
//
//  Created by hh k on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskEntity : NSObject

@property (nonatomic , copy) NSString *taskId;
@property (nonatomic , retain) NSNumber *type;
@property (nonatomic , retain) NSNumber *status;
@property (nonatomic , copy) NSString *tableName;
@property (nonatomic , copy) NSString *userId;

+(NSDictionary *)generateTaskDic:(TaskEntity *)task;
@end
