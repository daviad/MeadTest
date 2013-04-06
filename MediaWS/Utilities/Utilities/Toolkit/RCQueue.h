//
//  RCQueue.h
//  LoochaData
//
//  Created by jinquan zhang on 12-8-20.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCQueue : NSObject
{
    void * privQueueRef;
}

- (void)push:(id)obj;

- (void)poll;

- (id)peek;

- (NSUInteger)length;

- (void)clear;

@end
