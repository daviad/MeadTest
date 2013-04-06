//
//  BaseViewController.h
//  LoochaUtilities
//
//  Created by xiuwei ding on 12-9-25.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Global.h"
#import "GAI.h"
@interface NavigationBarStyle : NSObject

@property(nonatomic,assign) BOOL hidden;
@property(nonatomic,assign) UIBarStyle barStyle;
@property(nonatomic,assign) BOOL translucent;
@property(nonatomic,retain) UIColor *tintColor;

@end

@interface BaseViewController : GAITrackedViewController
{
    NavigationBarStyle *navigationBarStyle;
}

@property(nonatomic,readonly,retain) NavigationBarStyle *navigationBarStyle;

-(BOOL)handleMessage:(int)messageType withResult:(int)result withArg:(id)arg;
-(void)sendMessage:(int)messageType withArg:(id)arg;
-(id)sendMessageSync:(int)messageType withArg:(id)arg;
@end
