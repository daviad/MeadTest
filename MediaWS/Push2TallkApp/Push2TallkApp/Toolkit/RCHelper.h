//
//  RCHelper.h
//  LoochaUtilities
//
//  Created by jinquan zhang on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define lengthOfArray(arr) (sizeof(arr)/sizeof(arr[0]))


#define RCReleaseSafely(obj) { [obj release]; obj = nil; }

#define RCColorWithRGB(r, g, b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RCColorWithRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RCColorWithValue(v)         [UIColor colorWithRed:(((v) >> 16) & 0xff)/255.0f green:(((v) >> 8) & 0xff)/255.0f blue:((v) & 0xff)/255.0f alpha:1]

#define RCStringOfInt(intValue) [[NSNumber numberWithInt:intValue] stringValue]

#define RCIntPixelEqual(px1, px2) ((int)(px1 + 0.5) == (int)(px2 + 0.5))
#define ScreenStatusBar 20.0f
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height - ScreenStatusBar


#define IS_IOS6_AND_UP ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)

CGPoint RCCenterOfRect(CGRect r);

NSString* genUUID(void);

//根据左侧空间计算当前空间x值
float leftToFrameWithMargin(CGRect rect, float margin);
float leftToFrame(CGRect rect);

float rightToFrameWithMargin(CGRect rect, float margin,float width);
float rightToFrame(CGRect rect, float width);

 
//初始化UIButton
UIButton* allocWithNormalAndHighlightImageName(NSString *image1,NSString *image2);

NSString *md5File(NSString *filePath);

CGPathRef newPathForRoundedRect(CGRect rect ,CGFloat radius);
void drawPathForRoundedRect(CGRect rect ,CGFloat radius,CGContextRef ctx, UIColor *color);


CGFloat getCenterOriginX(CGSize outsz, CGSize innerSz);
NSString *machineName();