//
//  MessageHandle.h
//  LoochaUtilities
//
//  Created by xiuwei ding on 12-9-26.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageHandle : NSObject

-(void)sendMessageToControllers:(int)messageType withResult:(int)result withArg:(id)arg;
-(id)handMessage:(int)messageType withArg:(id)arg;
@end
