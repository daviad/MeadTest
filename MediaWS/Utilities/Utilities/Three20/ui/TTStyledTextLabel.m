//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TTStyledTextLabel.h"
#import "TTStyledAtNode.h"  //add for @
//// UI
//#import "TTNavigator.h"
//#import "TTTableView.h"
#import "UIViewAdditions.h"

// Style
#import "TTGlobalStyle.h"
#import "TTStyledText.h"
#import "TTStyledNode.h"
#import "TTStyleSheet.h"
#import "TTStyledElement.h"
#import "TTStyledLinkNode.h"
#import "TTStyledButtonNode.h"
#import "TTStyledTextNode.h"
#import "TTStyledLayout.h"
#import "UIImageView+WebCache.h"
#import "TTStyledImageNode.h"


// - Styled frames
#import "TTStyledInlineFrame.h"
#import "TTStyledTextFrame.h"

// Core
#import "TTCorePreprocessorMacros.h"
#import "TTDebug.h"

static const CGFloat kCancelHighlightThreshold = 4.0f;






#import "RCHelper.h"



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTStyledTextLabel

@synthesize text                  = _text;
@synthesize textColor             = _textColor;
@synthesize highlightedTextColor  = _highlightedTextColor;
@synthesize font                  = _font;
@synthesize textAlignment         = _textAlignment;
@synthesize contentInset          = _contentInset;
@synthesize highlighted           = _highlighted;
@synthesize highlightedNode       = _highlightedNode;

@synthesize  contentStr;
@synthesize firstLineWith;
@synthesize maxWith;
@synthesize maxnumOfLines;

//need 




- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
    if (self) {
        _textAlignment  = UITextAlignmentLeft;
        _contentInset   = UIEdgeInsetsZero;
        
//        self.font = TTSTYLEVAR(font);
        self.backgroundColor = TTSTYLEVAR(backgroundColor);
        self.backgroundColor = [UIColor whiteColor ];
        self.contentMode = UIViewContentModeRedraw;
        
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setText:(TTStyledText*)text {
    if (text != _text) {
        for(UIView *view in [self subviews])
            if([view isKindOfClass:[UIImageView class]])
                [view removeFromSuperview];
        self.layer.sublayers = nil;
        _text.whichLable = self;
 //      _text.delegate = nil;
        [_text release];
//        TT_RELEASE_SAFELY(_accessibilityElements);
        _text = [text retain];
//        _text.delegate = self;
        _text.whichLable = self;
        _text.font = _font;
        _text.textAlignment = _textAlignment;
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}



- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat newWidth = self.width - (_contentInset.left + _contentInset.right);
    if (newWidth != _text.width) {
        // Remove the highlighted node+frame when resizing the text
//        self.highlightedNode = nil;
    }
    _text.width = newWidth;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)sizeThatFits:(CGSize)size {
    [self layoutIfNeeded];
    if(maxnumOfLines)
        _text.maxnumOfLines = maxnumOfLines;
    return CGSizeMake(_text.width + (_contentInset.left + _contentInset.right),
                      _text.height+ (_contentInset.top + _contentInset.bottom));
}





///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFont:(UIFont*)font {
    if (font != _font) {
        [_font release];
        _font = [font retain];
        _text.font = _font;
        [self setNeedsLayout];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTextAlignment:(UITextAlignment)textAlignment {
    if (textAlignment != _textAlignment) {
        _textAlignment = textAlignment;
        _text.textAlignment = _textAlignment;
        [self setNeedsLayout];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)textColor {
    if (!_textColor) {
        _textColor = [TTSTYLEVAR(textColor) retain];
    }
    return _textColor;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTextColor:(UIColor*)textColor {
    if (textColor != _textColor) {
        [_textColor release];
        _textColor = [textColor retain];
        [self setNeedsDisplay];
    }
}






///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setStyle:(TTStyle*)style forFrame:(TTStyledBoxFrame*)frame {
    if ([frame isKindOfClass:[TTStyledInlineFrame class]]) {
        TTStyledInlineFrame* inlineFrame = (TTStyledInlineFrame*)frame;
        while (inlineFrame.inlinePreviousFrame) {
            inlineFrame = inlineFrame.inlinePreviousFrame;
        }
        while (inlineFrame) {
            inlineFrame.style = style;
            inlineFrame = inlineFrame.inlineNextFrame;
        }
        
    } else {
        frame.style = style;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHighlightedFrame:(TTStyledBoxFrame*)frame{
    if (frame != _highlightedFrame) {
        // TTTableView* tableView = (TTTableView*)[self ancestorOrSelfWithClass:[TTTableView class]];
        
        TTStyledBoxFrame* affectFrame = frame ? frame : _highlightedFrame;
        NSString* className = affectFrame.element.className;
        
        if (className && [className rangeOfString:@":"].location != NSNotFound) {
            if (frame)
            {
                TTStyle* style = [TTSTYLESHEET styleWithSelector:className
                                                        forState:UIControlStateHighlighted];
                [self setStyle:style forFrame:frame];
                
                [_highlightedFrame release];
                _highlightedFrame = [frame retain];
                [_highlightedNode release];
                _highlightedNode = [frame.element retain];
                isTraceEvent = NO;
                // tableView.highlightedLabel = self;
                
            } else {
                TTStyle* style = [TTSTYLESHEET styleWithSelector:className forState:UIControlStateNormal];
                [self setStyle:style forFrame:_highlightedFrame];
                
                TT_RELEASE_SAFELY(_highlightedFrame);
                TT_RELEASE_SAFELY(_highlightedNode);
                //  tableView.highlightedLabel = nil;
            }
            
            [self setNeedsDisplay];
        }
    }
}



//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIResponder

/*
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (BOOL)canBecomeFirstResponder {
 return YES;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (BOOL)becomeFirstResponder {
 BOOL became = [super becomeFirstResponder];
 
 UIMenuController* menu = [UIMenuController sharedMenuController];
 [menu setTargetRect:self.frame inView:self.superview];
 [menu setMenuVisible:YES animated:YES];
 
 self.highlighted = YES;
 return became;
 }
 
 
 ///////////////////////////////////////////////////////////////////////////////////////////////////
 - (BOOL)resignFirstResponder {
 self.highlighted = NO;
 BOOL resigned = [super resignFirstResponder];
 [[UIMenuController sharedMenuController] setMenuVisible:NO];
 return resigned;
 }
 */


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    isTraceEvent = YES;
    
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    point.x -= _contentInset.left;
    point.y -= _contentInset.top;
    
    TTStyledBoxFrame* frame = [_text hitTest:point];
    if (frame) {
        [self setHighlightedFrame:frame];
    }
    
    //[self performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5];
    if (isTraceEvent)
    {
    [super touchesBegan:touches withEvent:event];
    }

}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    if (isTraceEvent)
    {
      [super touchesMoved:touches withEvent:event];
    }
    if (_highlightedNode)
    {
        [self  performSelector:@selector(setHighlightedFrame:) withObject:nil afterDelay:0.1];
    }

}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    //    TTTableView* tableView = (TTTableView*)[self ancestorOrSelfWithClass:[TTTableView class]];
    //    if (!tableView)
    {

        if (_highlightedNode) {
            // This is a dirty hack to decouple the UI from Style. TTOpenURL was originally within
            // the node implementation. One potential fix would be to provide some protocol for these
            // nodes to converse with.
            if ([_highlightedNode isKindOfClass:[TTStyledLinkNode class]]) {
               // TTOpenURL([(TTStyledLinkNode*)_highlightedNode URL]);
                
            } else if ([_highlightedNode isKindOfClass:[TTStyledButtonNode class]])
            {
               // TTOpenURL([(TTStyledButtonNode*)_highlightedNode URL]);
                
            }
            else
            {
                [_highlightedNode performDefaultAction];

            }
            [self  performSelector:@selector(setHighlightedFrame:) withObject:nil afterDelay:0.5];
        }
        
        if (isTraceEvent)
        {
            [super touchesEnded:touches withEvent:event];
        }
    }
    
    // We definitely don't want to call this if the label is inside a TTTableView, because
    // it winds up calling touchesEnded on the table twice, triggering the link twice
   // [super touchesEnded:touches withEvent:event];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
    [super touchesCancelled:touches withEvent:event];
    if (_highlightedNode)
    {
         [self  performSelector:@selector(setHighlightedFrame:) withObject:nil afterDelay:0.1];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////




-(void)refreshPartWithFrame:(TTStyledImageFrame*)tempimgeFrame
{
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:tempimgeFrame.bounds];
        [self addSubview:imageView];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kPicURLPath,tempimgeFrame.imageNode.URL]];
        [imageView setImageWithURL:url];
        [imageView release];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
//    NSLog(@"ttdealloc");
    _text.whichLable = nil;
  _text.delegate = nil;
  TT_RELEASE_SAFELY(_text);
  TT_RELEASE_SAFELY(_font);
  TT_RELEASE_SAFELY(_textColor);
  TT_RELEASE_SAFELY(_highlightedTextColor);
  TT_RELEASE_SAFELY(_highlightedNode);
  TT_RELEASE_SAFELY(_highlightedFrame);
  TT_RELEASE_SAFELY(_accessibilityElements);
  TT_RELEASE_SAFELY(contentStr);
  [super dealloc];
}






//+(CGFloat)getContentViewHeightWithContent:(NSString*)content constraintWidth:(CGFloat)w withFontSize:(CGFloat)font withMaxLines:(int)l
//{
//    
//    CGFloat h = 0;
////    TTStyledTextLabel* label = [[[TTStyledTextLabel alloc] initWithFrame:CGRectMake(0, 0, w, 0)] autorelease];
////    if(l)
////        label.maxnumOfLines = l;
////    else
////        label.maxnumOfLines = 0;
////    label.font = [UIFont systemFontOfSize:font];
////    label.text = [TTStyledText textFromLoochaText:content lineBreaks:YES URLs:NO];
////    [label sizeToFit];
////    
////    h = label.text.height;
////    
////    // RCTrace(@"height:%f",label.text.firstLineWith);
//    
//    return h;
//}

//-(void)parseContentStr:(NSString*)str withMaxnum:(int)n
//{
////    NSString *newStr =str;
////    if (str.length>50) 
////    {
////        newStr  = [str substringToIndex:50];
////    }
////    
//    
//    
////    CGSize sz = [[newStr substringToIndex:3] sizeWithFont:[UIFont systemFontOfSize:TTStyledTextFont] 
////                                        constrainedToSize:CGSizeMake(300, 1000)
////                                            lineBreakMode:UILineBreakModeWordWrap]; // sz.height =20
//    
////    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.width, 20);
////    self.text =[TTStyledText textFromLoochaText:str lineBreaks:YES URLs:NO];
////    self.text.maxnumOfLines =1;
//}


@end
