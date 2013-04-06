//
//  UITextField+Settings.m
//  LooCha
//
//  Created by 熊 财兴 on 11-11-28.
//  Copyright (c) 2011年 真云. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UITextField+Settings.h"

@implementation UITextField(Settings)

- (void)setVariablefield:(float)fontSize
	  placeholderContent:(NSString *)placeholderContent {
	self.font = [UIFont boldSystemFontOfSize:fontSize];
	self.textColor = [UIColor blackColor];
	self.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	self.keyboardType = UIKeyboardTypeDefault;
	self.backgroundColor = [UIColor clearColor];
	self.borderStyle = UITextBorderStyleRoundedRect;
	//  UITextField圆角设置
	self.layer.cornerRadius = 8; 
	self.layer.masksToBounds=YES;
	self.placeholder = placeholderContent;
	self.autocorrectionType = UITextAutocorrectionTypeNo;
	self.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.enablesReturnKeyAutomatically = NO;
}
@end