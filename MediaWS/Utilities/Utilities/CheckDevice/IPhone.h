//
//  IPhone.h
//  LoochaUtils
//
//  Created by xiuwei ding on 12-7-23.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#ifndef LoochaUtils_IPhone_h
#define LoochaUtils_IPhone_h

#import <UIKit/UIKit.h>

// 判断是否是iphone4设备
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)


// 判断是否是iphone模拟器
#define isSimulator ([[UIDevice currentDevice].model isEqualToString:@"iPhone Simulator"])

#endif
