//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender;
@end 

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) id <NIDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;
@property(nonatomic, retain) UITableView *table;
@property(nonatomic, retain) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@property (nonatomic,assign) BOOL isShow;
- (id)initDropDown:(UIButton *)b height:(CGFloat )height array:(NSArray *)arr direction:(NSString *)direction;
- (void)clickView;
@end
