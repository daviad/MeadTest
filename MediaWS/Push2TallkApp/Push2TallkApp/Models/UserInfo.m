//
//  UserInfo.m
//  LoochaCampus
//
//  Created by jinquan zhang on 12-10-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize user_id;
@synthesize name;
@synthesize avatar;
@synthesize img;
@synthesize smsStatus;
//@synthesize mobile;

- (id)init
{
    if(self = [super init])
    {
        self.user_id = nil;
        self.name = nil;
        self.avatar = nil;
        self.img = nil;
        self.smsStatus = nil;
       // self.mobile = nil;
    }
    
    return  self;
}

+ (UserInfo *)userInfoWithUserID:(NSString *)userID name:(NSString *)name avatar:(NSString *)avatar
{
    UserInfo *userInfo = [[[UserInfo alloc] init] autorelease];
    userInfo.user_id = userID;
    userInfo.name = name;
    userInfo.avatar = avatar;
    return userInfo;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:user_id forKey:@"user_id"];
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:avatar forKey:@"avatar"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
    }
    return self;
}

- (void)convertFromDictionary:(NSDictionary *)userDic
{
    self.user_id = [userDic valueForKey:@"id"];
    self.name = [userDic valueForKey:@"name"];
    self.avatar = [userDic valueForKey:@"avatar"];
}

- (void)dealloc
{
    self.user_id = nil;
    self.name = nil;
    self.avatar = nil;
    self.img = nil;
    self.smsStatus = nil;
    [super dealloc];
}

@end
