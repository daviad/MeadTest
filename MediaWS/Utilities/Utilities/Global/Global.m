//
//  Global.m
//  LoochaUtilities
//
//  Created by xiuwei ding on 12-9-25.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//
#import "BaseViewController.h"
#import "Global.h"
#import "TTGlobalCore.h"
static  MessageHandle *HMessage = nil;
static  NSMutableArray*controllerArr =  nil;


@implementation Global
+(void)addController:(id)controller
{
    if (!controllerArr)
    {
        controllerArr = TTCreateNonRetainingArray();
      
    }
    [controllerArr addObject:controller];
}

+(void)removeController:(id)controller
{
    [controllerArr removeObject:controller];
}

+(BOOL)findController:(Class)controllerClass
{
    int num = [controllerArr count];
    for ( int i = num-1; i>=0; i--)
    {
        BaseViewController *viewController = [controllerArr objectAtIndex:i];
        if ([viewController isKindOfClass:controllerClass])
        {
            return YES;
        }
        
    }
    return NO;
}


+(void)sendMessageToControllers:(int)messageType withResult:(int)result withArg:(id)arg
{
   // RCError(@"xxx %d", messageType);
    int messageTypeTemp = messageType;

     int resultTemp  = result;
     id argTemp = [arg retain];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        int num = [controllerArr count];
        if(num >= 1)
            [[controllerArr objectAtIndex:0] handleMessage:kTaskMsgPreProcess withResult:resultTemp withArg:argTemp];
        for ( int i = num-1; i>=0; i--) 
        {
            BaseViewController *viewController = [controllerArr objectAtIndex:i];
           //  RCError(@"yyy %d  i=%d %@", messageTypeTemp,i,viewController);
           // RCError(@"arr :%@",controllerArr);
            BOOL isDone =  [viewController handleMessage:messageTypeTemp withResult:resultTemp withArg:argTemp];
            if (isDone) 
            {
                break;
            }

        }
        [argTemp release];
    });
    
    
    
}

+(void)registerMessageHandle:(MessageHandle*)handler
{
    HMessage = handler;
}

+(void)sendMessage:(int)messageType withArg:(id)arg
{
//    [HMessage handMessage:messageType withArg:arg];
    if ([[NSThread currentThread] isMainThread]) 
    {
        [HMessage handMessage:messageType withArg:arg];
    }
    else
    {
        //[HMessage performSelectorOnMainThread:@selector(handMessage: withArg:) withObject:nil waitUntilDone:NO];
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSMethodSignature *sig = [HMessage methodSignatureForSelector:@selector(handMessage: withArg:)];
        if (!sig) return;   
        NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:HMessage];
        [invo setSelector:@selector(handMessage: withArg:)];
        [invo setArgument:&messageType atIndex:2];
        [invo setArgument:&arg atIndex:3];
        [invo retainArguments];
        [invo performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:NO];
        [pool drain];
    }
}

+(id)sendMessageSync:(int)messageType withArg:(id)arg
{
    if (![[NSThread currentThread] isMainThread]) 
    {
        RCWarn(@" send message isnot main thread!!!!!");
        return nil;
    }
    return  [HMessage handMessage:messageType withArg:arg];
}
@end
