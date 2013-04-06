//
//  UIColor+Extends.h
//  LooCha
//
//  Created by 熊 财兴 on 11-11-14.
//  Copyright (c) 2011年 真云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// iphone/ipad不支持十六进制的颜色表示，对UIColor进行扩展
@interface UIColor(Extends)

// 将十六进制颜色的字符串转化为复合iphone/ipad的颜色
// 字符串为"FFFFFF"
+ (UIColor *)hexChangeFloat:(NSString *) hexColor;

@end
