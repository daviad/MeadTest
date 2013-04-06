//
//  TTStyledAtNode.m
//  LoochaUtilities
//
//  Created by ding xiuwei on 13-1-5.
//
//

#import "TTStyledAtNode.h"
#import "AppConstants.h"
@implementation TTStyledAtNode
@synthesize name;
@synthesize userId;

-(void)performDefaultAction
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",userId,@"userId", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:KATTTNodeNotification object:nil userInfo:dic];
}


-(void)dealloc
{
    [name release];
    [userId release];
    [super dealloc];
}
@end
