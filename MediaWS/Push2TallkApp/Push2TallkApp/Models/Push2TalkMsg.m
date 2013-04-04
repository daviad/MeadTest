//
//  Push2TalkMsg.m
//  LoochaData
//
//  Created by jinquan zhang on 12-8-16.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import "Push2TalkMsg.h"

@implementation Push2TalkMsg

@synthesize otherUserId;
@synthesize connectivity;
@synthesize request;
@synthesize content;
@synthesize samplerate;
@synthesize streamtype;
@synthesize version;

- (id)initFromDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self parseFromDictionary:dic];
    }
    return self;
}

- (void)dealloc
{
    self.otherUserId = nil;
    self.connectivity = nil;
    self.request = nil;
    [super dealloc];
}

- (void)parseFromDictionary:(NSDictionary *)dic 
{
	self.otherUserId = [dic objectForKey:@"from"];
    self.connectivity = [dic objectForKey:@"connectivity"];
    self.request = [dic objectForKey:@"request"];
    self.content = [[dic objectForKey:@"content"] intValue];
    self.samplerate = [[dic objectForKey:@"samplerate"] intValue];
    self.streamtype = [[dic objectForKey:@"streamtype"] intValue];
    self.version = [[dic objectForKey:@"version"] intValue];
}

@end
