//
//  RCQueue.m
//  LoochaData
//
//  Created by jinquan zhang on 12-8-20.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import "RCQueue.h"

#include <queue>

using namespace std;

@implementation RCQueue

#define queueRef (static_cast<queue<id> *>(privQueueRef))

- (id)init
{
    self = [super init];
    if (self) {
        queue<id> *q = new queue<id>;
        privQueueRef = q;
    }
    return self;
}

- (void)dealloc
{
    [self clear];
    delete queueRef;
    [super dealloc];
}

- (void)push:(id)obj
{
    if (obj) {
        [obj retain];
        queueRef->push(obj);
    }
}

- (void)poll
{
    if (!queueRef->empty()) {
        id obj = queueRef->front();
        queueRef->pop();
        [obj release];
    }
}

- (id)peek
{
    if (!queueRef->empty()) {
        return queueRef->front();
    }
    return nil;
}

- (NSUInteger)length
{
    return queueRef->size();
}

- (void)clear
{
    while (!queueRef->empty()) {
        id obj = queueRef->front();
        queueRef->pop();
        [obj release];
    }
}

@end
