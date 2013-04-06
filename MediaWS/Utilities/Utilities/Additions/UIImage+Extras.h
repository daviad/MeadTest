//
//  UIImage+Extras.h
//  LooCha
//
//  Created by XiongCaixing on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>




@interface UIImage(Extras)

//crop 
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageScale:(CGSize)asize;
//.自动缩放到指定大小
- (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;
//3.
+(UIImage *)addImage:(UIImage *)imageIner toImage:(UIImage *)imageBg withEdgeInsets:(UIEdgeInsets)e;



-(UIImage *)convertImgOrientation;
- (UIImage *)clipImageby:(CGSize)asize;
@end
