//
//  BaseViewController.m
//  LoochaUtilities
//
//  Created by xiuwei ding on 12-9-25.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import "BaseViewController.h"

@implementation NavigationBarStyle

@synthesize hidden;
@synthesize barStyle;
@synthesize translucent;
@synthesize tintColor;

- (id)initWithNavigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self) {
        if (navigationController) {
            self.hidden = navigationController.navigationBarHidden;
            UINavigationBar *bar = navigationController.navigationBar;
            if (bar) {
                self.translucent = bar.translucent;
                self.tintColor = bar.tintColor;
                self.barStyle = bar.barStyle;
            }
        }
    }
    return self;
}

- (void)configNavigationController:(UINavigationController *)navigationController animated:(BOOL)animated
{
    if (navigationController) {
        if (self.hidden != navigationController.navigationBarHidden) {
            [navigationController setNavigationBarHidden:self.hidden animated:animated];
        }
        UINavigationBar *bar = navigationController.navigationBar;
        if (bar) {
            bar.translucent = self.translucent;
            bar.tintColor = self.tintColor;
            bar.barStyle = self.barStyle;
        }
    }
}

- (void)dealloc
{
    self.tintColor = nil;
    [super dealloc];
}

@end

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize navigationBarStyle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [Global addController:self];
        self.navigationBarStyle.hidden = YES;

    }
    return self;
}

-(void)dealloc
{
    [Global removeController:self];
    
    [navigationBarStyle release];
    [super dealloc];
}

- (NavigationBarStyle *)navigationBarStyle
{
    if (navigationBarStyle == nil) {
        navigationBarStyle = [[NavigationBarStyle alloc] initWithNavigationController:self.navigationController];
    }
    return navigationBarStyle;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	self.trackedViewName = [[self class] description];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configNavigationBarStyleAnimated:animated];
}

-(BOOL)handleMessage:(int)messageType withResult:(int)result withArg:(id)arg
{
    return NO;
}

-(void)sendMessage:(int)messageType withArg:(id)arg
{
    [Global sendMessage:messageType withArg:arg];
}

-(id)sendMessageSync:(int)messageType withArg:(id)arg
{
  return [Global sendMessageSync:messageType withArg:arg];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)changeOrientation
{
    [self shouldAutorotateToInterfaceOrientation:UIDeviceOrientationPortraitUpsideDown];
    
}


- (void)configNavigationBarStyleAnimated:(BOOL)animated
{
    if (self.navigationController && navigationBarStyle) {
        [navigationBarStyle configNavigationController:self.navigationController animated:animated];
    }
}

@end
