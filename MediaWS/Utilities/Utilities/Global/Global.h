//
//  Global.h
//  LoochaUtilities
//
//  Created by xiuwei ding on 12-9-25.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageHandle.h"

#define MESSAGE_SUCCESS 0
typedef enum
{
    kTaskMsgPreProcess = 500
}TaskMsgUtilitiesType;



@interface Global : NSObject
{
  
}

+(void)addController:(id)controller;
+(void)removeController:(id)controller;
+(BOOL)findController:(Class)controllerClass;

+(void)registerMessageHandle:(MessageHandle*)handler;

+(void)sendMessageToControllers:(int)messageType withResult:(int)result withArg:(id)arg;

+(void)sendMessage:(int)messageType withArg:(id)arg;
+(id)sendMessageSync:(int)messageType withArg:(id)arg;
@end
