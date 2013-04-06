/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import <objc/runtime.h>

static const void *key_extraContentMode = &key_extraContentMode;
@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    if(self.extraContentMode == UIViewContentModeScaleAspectFromTop)
    {
        placeholder = [placeholder clipImageby:self.frame.size];
    }
    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    
    if(self.extraContentMode == UIViewContentModeScaleAspectFromTop)
    {
        placeholder = [placeholder clipImageby:self.frame.size];
    }
    self.image = placeholder;
    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
    }
}
#endif

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
    self.image = image;
    [self setNeedsLayout];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    
    if(self.extraContentMode == UIViewContentModeScaleAspectFromTop)
    {
        image = [image clipImageby:self.frame.size];
    }
    self.image = image;
    [self setNeedsLayout];
}



- (int)extraContentMode
{
    id value = objc_getAssociatedObject(self, key_extraContentMode);
    if (value && [value isKindOfClass:[NSNumber class]]) {
        return [value intValue];
    }
    return NO;
}

- (void)setExtraContentMode:(int)contentmode
{
    objc_setAssociatedObject(self, key_extraContentMode, [NSNumber numberWithInt:contentmode], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
