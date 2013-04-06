//
//  UIImage+Extras.m
//  LooCha
//
//  Created by XiongCaixing on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Extras.h"
#import <objc/runtime.h>

static inline CGRect ScaleRect(CGRect rect, float n) {return CGRectMake((rect.size.width - rect.size.width * n)/ 2, (rect.size.height - rect.size.height * n) / 2, rect.size.width * n, rect.size.height * n);}


@implementation UIImage(Extras)


- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize{
    
    UIImage *sourceImage = self;  
    UIImage *newImage = nil;          
    CGSize imageSize = sourceImage.size;  
    CGFloat width = imageSize.width;  
    CGFloat height = imageSize.height;  
    CGFloat targetWidth = targetSize.width;  
    CGFloat targetHeight = targetSize.height;  
    CGFloat scaleFactor = 0.0;  
    CGFloat scaledWidth = targetWidth;  
    CGFloat scaledHeight = targetHeight;  
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);  
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)   
    {  
        CGFloat widthFactor = targetWidth / width;  
        CGFloat heightFactor = targetHeight / height;  
        if (widthFactor > heightFactor)   
            scaleFactor = widthFactor; // scale to fit height  
        else  
            scaleFactor = heightFactor; // scale to fit width  
        scaledWidth  = width * scaleFactor;  
        scaledHeight = height * scaleFactor;  
        // center the image  
        if (widthFactor > heightFactor)  
        {  
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;   
        }  
        else   
            if (widthFactor < heightFactor)  
            {  
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;  
            }  
    }         
    UIGraphicsBeginImageContext(targetSize); // this will crop  
    CGRect thumbnailRect = CGRectZero;  
    thumbnailRect.origin = thumbnailPoint;  
    thumbnailRect.size.width  = scaledWidth;  
    thumbnailRect.size.height = scaledHeight;  
    [sourceImage drawInRect:thumbnailRect];  
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();  
    return newImage;  
}  

//.自动缩放到指定大小
- (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    UIGraphicsBeginImageContext(asize);
    [self drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
    newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
    
}
//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageScale:(CGSize)asize

{
    
    UIImage *newimage;
    CGSize oldsize = self.size;
    CGRect rect;
    
    if (asize.width/asize.height > oldsize.width/oldsize.height) 
    {
        
        rect.size.width = asize.height*oldsize.width/oldsize.height;
        rect.size.height = asize.height;
        rect.origin.x = 0;
        rect.origin.y = 0;
        
    }
    
    else
    {
        
        rect.size.width = asize.width;
        rect.size.height = asize.width*oldsize.height/oldsize.width;
        rect.origin.x = 0;
        rect.origin.y = 0;
        
    }
    
    //newimage = [UIImage imageWithCGImage:self.CGImage scale:self.size.width/rect.size.width orientation:self.imageOrientation];
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(0.0, rect.size.height));
    CGContextConcatCTM(context, CGAffineTransformMakeScale(1.0, -1.0));
    CGContextDrawImage(context, rect, self.CGImage);
    newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    

//    UIGraphicsBeginImageContext(asize);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//
//    UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
//    [self drawInRect:rect];
//    newimage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
    
    return newimage;
    
}

- (UIImage *)clipImageby:(CGSize)asize

{
    
    CGRect rect = CGRectZero;
    rect.size.width = self.size.width;
    rect.size.height = asize.height * self.size.width / asize.width;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
    
}


+(UIImage *)addImage:(UIImage *)imageIner toImage:(UIImage *)imageBg withEdgeInsets:(UIEdgeInsets)e
{
    UIGraphicsBeginImageContext(imageBg.size);
    [imageBg drawInRect:CGRectMake(0, 0, imageBg.size.width, imageBg.size.height)];
    //[imageIner drawInRect:CGRectMake(imageBg.size.width/2 - imageIner.size.width/2 , imageBg.size.height/2 - imageIner.size.height/2, imageIner.size.width, imageIner.size.height)];
    [imageIner drawInRect:CGRectMake(e.left , e.top, imageIner.size.width, imageIner.size.height)];

    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}




-(UIImage *)convertImgOrientation
{
    
    if(UIImageOrientationLeft == self.imageOrientation)
    {
        
        UIImageView *v = [[UIImageView alloc] initWithImage:self];
        v.frame = CGRectMake(0, 0, self.size.width, self.size.height);
        v.transform = CGAffineTransformMakeRotation(M_1_PI/2);
        
        CGSize  r = CGSizeMake(self.size.width, self.size.height);
        CGRect rect = CGRectMake(0, 0, r.width, r.height);
        UIGraphicsBeginImageContext(r);
        [self drawInRect:rect];
        UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [v release];
        return newimage;
    }

    else if(UIImageOrientationRight == self.imageOrientation)
    {
  
        UIImageView *v = [[UIImageView alloc] initWithImage:self];
        v.frame = CGRectMake(0, 0, self.size.width, self.size.height);
        v.transform = CGAffineTransformMakeRotation(-M_1_PI/2);
        
        CGSize  r = CGSizeMake(self.size.width, self.size.height);
        CGRect rect = CGRectMake(0, 0, r.width, r.height);
        UIGraphicsBeginImageContext(r);
        [self drawInRect:rect];
        UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [v release];
        return newimage;
    }
    else if(UIImageOrientationDown == self.imageOrientation)
    {
        
        CGRect rect = CGRectMake(0, 0, self.size.width,self.size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, rect, self.CGImage);
        UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newimage;
    }
    else if (UIImageOrientationUp == self.imageOrientation)
    {
        return self;
    }
  return nil;
}
@end
