//
//  MessageHandle.m
//  LoochaUtilities
//
//  Created by xiuwei ding on 12-9-26.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import "MessageHandle.h"
#import "Global.h"
@implementation MessageHandle

-(id)init
{
    if (self = [super init])
    {
        [Global registerMessageHandle:self];
    }
    return self;
}
-(id)handMessage:(int)messageType withArg:(id)arg
{
    return nil;
}

-(void)sendMessageToControllers:(int)messageType withResult:(int)result withArg:(id)arg
{
    [Global sendMessageToControllers:messageType withResult:result withArg:arg];
}

@end
