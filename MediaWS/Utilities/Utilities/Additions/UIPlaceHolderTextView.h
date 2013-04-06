//
//  UIPlaceHolderTextView.h
//  LoochaUtilities
//
//  Created by xiuwei ding on 12-11-2.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kDefaultNormalBolderColorValue      0x7bcade
#define kDefaultHighlightedBolderColorValue 0xeec454

@protocol UIPlaceHolderTextViewDelegate <NSObject>

@optional
-(void)refrsehSelfHight:(CGFloat)h;
-(void)wordsCount:(int)count;
-(void)beginEditing:(id)sender;
@end


@interface UIPlaceHolderTextView : UITextView
{
    
    id<UIPlaceHolderTextViewDelegate>customDelegate;
    
    NSString *placeholder;
    UIColor *placeholderColor;
    UIColor *_normalBolderColor;
    UIColor *_highlightedBolderColor;
     CGFloat cornerRadius;
@private
    UILabel *placeHolderLabel;

  @public
    int maxLength;
    
   
       
}
    
   

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;
@property (nonatomic, retain) UIColor *normalBolderColor;
@property (nonatomic, retain) UIColor *highlightedBolderColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign)  id<UIPlaceHolderTextViewDelegate>customDelegate;
-(void)textChanged:(NSNotification*)notification;

@end
