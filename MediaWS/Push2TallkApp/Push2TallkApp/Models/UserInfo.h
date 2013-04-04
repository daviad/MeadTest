//
//  UserInfo.h
//  LoochaCampus
//
//  Created by jinquan zhang on 12-10-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject <NSCoding>
{
    NSString *user_id;
    NSString *name;
    NSString *avatar;
    NSString *smsStatus;
  //  NSString *mobile;
}

@property (nonatomic, retain) NSString *user_id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, retain) UIImage *img;
@property (nonatomic, retain) NSString *smsStatus;
//@property (nonatomic, retain) NSString *mobile;

+ (UserInfo *)userInfoWithUserID:(NSString *)userID name:(NSString *)name avatar:(NSString *)avatar;

- (void)convertFromDictionary:(NSDictionary *)userDic;

@end
