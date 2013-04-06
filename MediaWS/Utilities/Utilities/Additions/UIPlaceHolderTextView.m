//
//  UIPlaceHolderTextView.m
//  LoochaUtilities
//
//  Created by xiuwei ding on 12-11-2.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIPlaceHolderTextView.h"
#import "RCHelper.h"
@implementation UIPlaceHolderTextView

@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;
@synthesize normalBolderColor;
@synthesize highlightedBolderColor;
@synthesize customDelegate;
@synthesize cornerRadius;

- (void)dealloc
{
    customDelegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [placeHolderLabel release]; placeHolderLabel = nil;
    [placeholderColor release]; placeholderColor = nil;
    [placeholder release]; placeholder = nil;
    self.normalBolderColor = nil;
    self.highlightedBolderColor = nil;
    [super dealloc];
}




-(void)customInit
{
    maxLength = GID_MAX;
    cornerRadius = 12;
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    
    
    self.normalBolderColor = RCColorWithValue(kDefaultNormalBolderColorValue);
    self.highlightedBolderColor = RCColorWithValue(kDefaultHighlightedBolderColorValue);
    
    [self setViewHighlighted:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewdidBeginEditing:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewdidEndEditing:)
                                                 name:UITextViewTextDidEndEditingNotification                                              object:self];
}


- (void)awakeFromNib
{
 
    [super awakeFromNib];
    [self customInit];

}




- (void)textViewdidBeginEditing:(NSNotification *)notification
{
    if ([notification object] == self)
    {
        [self setViewHighlighted:YES];
         [customDelegate beginEditing:self];
    }
    
   
}

- (void)textViewdidEndEditing:(NSNotification *)notification
{
    if ([notification object] == self) 
    {
        [self setViewHighlighted:NO];
    }
}



- (id)initWithFrame:(CGRect)frame
{
  
    if( (self = [super initWithFrame:frame]) )
    {
        [self customInit];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if ([notification object] == self  && self.text.length>maxLength)
    {
         self.text = [self.text substringToIndex:maxLength];
    }
    
    
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
    
    
    [customDelegate refrsehSelfHight: self.contentSize.height];
    [customDelegate wordsCount:self.text.length];
   
}

- (void)setText:(NSString *)text
{
   
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    
    self.layer.cornerRadius = cornerRadius;
	self.layer.masksToBounds=YES;
    self.layer.borderColor = self.normalBolderColor.CGColor;
    
    if( [[self placeholder] length] > 0 )
    {
        if ( placeHolderLabel == nil )
        {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            placeHolderLabel.lineBreakMode = UILineBreakModeWordWrap;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            [self addSubview:placeHolderLabel];
        }
        
        placeHolderLabel.text = self.placeholder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    
}


- (void)setViewHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = self.highlightedBolderColor.CGColor;
    }
    else {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = self.normalBolderColor.CGColor;
    }
}

@end
