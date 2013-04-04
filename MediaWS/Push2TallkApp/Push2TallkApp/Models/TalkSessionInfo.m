//
//  TalkSessionInfo.m
//  LoochaEnterprise
//
//  Created by jinquan zhang on 12-8-21.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import "TalkSessionInfo.h"

@implementation TalkSessionInfo

@synthesize userType;
@synthesize remoteIP;
@synthesize remotePort;
@synthesize localPort;
@synthesize remoteSampleRate;
@synthesize localSampleRate;
@synthesize connected;
@synthesize remoteUserInfo;

- (id)init
{
    self = [super init];
    if (self) {
        localSampleRate = vDefaultLocalSampleRate;
    }
    return self;
}

- (NSString *)description
{
    NSDictionary *dic = [self dictionaryWithValuesForKeys:
                         [NSArray arrayWithObjects:@"userType", @"remoteIP", @"remotePort", @"localPort", @"remoteSampleRate", @"remoteUserInfo", nil]];
    return [dic description];
}

- (void)dealloc
{
    self.remoteIP = nil;
    self.remoteUserInfo = nil;    
    [super dealloc];
}

@end
