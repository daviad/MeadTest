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
#import "UpLoadResource.h"
#import "TTStyledTextParser.h"

// Style
#import "TTStyledElement.h"
#import "TTStyledTextNode.h"
#import "TTStyledInline.h"
#import "TTStyledBlock.h"
#import "TTStyledLineBreakNode.h"
#import "TTStyledBoldNode.h"
#import "TTStyledButtonNode.h"
#import "TTStyledLinkNode.h"
#import "TTStyledItalicNode.h"
#import "TTStyledImageNode.h"
#import "TTStyledAtNode.h"

// Core
#import "TTCorePreprocessorMacros.h"
#import "TTDebug.h"



#define EmojMaxLength 8
#define NewEmojMaxLength 3
#define NameMaxLength 20
#define UserIdMaxLength 20

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTStyledTextParser

@synthesize rootNode        = _rootNode;
@synthesize parseLineBreaks = _parseLineBreaks;
@synthesize parseURLs       = _parseURLs;
@synthesize emojDic;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_rootNode);
    TT_RELEASE_SAFELY(_chars);
    TT_RELEASE_SAFELY(_stack);
    TT_RELEASE_SAFELY(emojDic);
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addNode:(TTStyledNode*)node {
    if (!_rootNode) {
        _rootNode = [node retain];
        _lastNode = node;
        
    } else if (_topElement) {
        [_topElement addChild:node];
        
    } else {
        _lastNode.nextSibling = node;
        _lastNode = node;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)pushNode:(TTStyledElement*)element {
    if (!_stack) {
        _stack = [[NSMutableArray alloc] init];
    }
    
    [self addNode:element];
    [_stack addObject:element];
    _topElement = element;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)popNode {
    TTStyledElement* element = [_stack lastObject];
    if (element) {
        [_stack removeLastObject];
    }
    
    _topElement = [_stack lastObject];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)flushCharacters {
    if (_chars.length) {
        [self parseText:_chars];
    }
    
    TT_RELEASE_SAFELY(_chars);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parseURLs:(NSString*)string {
    NSInteger stringIndex = 0;
    
    while (stringIndex < string.length) {
        NSRange searchRange = NSMakeRange(stringIndex, string.length - stringIndex);
        NSRange httpRange = [string rangeOfString:@"http://" options:NSCaseInsensitiveSearch
                                            range:searchRange];
        NSRange httpsRange = [string rangeOfString:@"https://" options:NSCaseInsensitiveSearch
                                             range:searchRange];
        
        NSRange startRange;
        if (httpRange.location == NSNotFound) {
            startRange = httpsRange;
            
        } else if (httpsRange.location == NSNotFound) {
            startRange = httpRange;
            
        } else {
            startRange = (httpRange.location < httpsRange.location) ? httpRange : httpsRange;
        }
        
        if (startRange.location == NSNotFound) {
            NSString* text = [string substringWithRange:searchRange];
            TTStyledTextNode* node = [[[TTStyledTextNode alloc] initWithText:text] autorelease];
            [self addNode:node];
            break;
            
        } else {
            NSRange beforeRange = NSMakeRange(searchRange.location,
                                              startRange.location - searchRange.location);
            if (beforeRange.length) {
                NSString* text = [string substringWithRange:beforeRange];
                TTStyledTextNode* node = [[[TTStyledTextNode alloc] initWithText:text] autorelease];
                [self addNode:node];
            }
            
            NSRange subSearchRange = NSMakeRange(startRange.location,
                                                 string.length - startRange.location);
            NSRange endRange = [string rangeOfString:@" " options:NSCaseInsensitiveSearch
                                               range:subSearchRange];
            if (endRange.location == NSNotFound) {
                NSString* URL = [string substringWithRange:subSearchRange];
                TTStyledLinkNode* node = [[[TTStyledLinkNode alloc] initWithText:URL] autorelease];
                node.URL = URL;
                [self addNode:node];
                break;
                
            } else {
                NSRange URLRange = NSMakeRange(startRange.location,
                                               endRange.location - startRange.location);
                NSString* URL = [string substringWithRange:URLRange];
                TTStyledLinkNode* node = [[[TTStyledLinkNode alloc] initWithText:URL] autorelease];
                node.URL = URL;
                [self addNode:node];
                stringIndex = endRange.location;
            }
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSXMLParserDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    [self flushCharacters];
    
    NSString* tag = [elementName lowercaseString];
    if ([tag isEqualToString:@"span"]) {
        TTStyledInline* node = [[[TTStyledInline alloc] init] autorelease];
        node.className =  [attributeDict objectForKey:@"class"];
        [self pushNode:node];
        
    } else if ([tag isEqualToString:@"br"]) {
        TTStyledLineBreakNode* node = [[[TTStyledLineBreakNode alloc] init] autorelease];
        node.className =  [attributeDict objectForKey:@"class"];
        [self pushNode:node];
        
    } else if ([tag isEqualToString:@"div"] || [tag isEqualToString:@"p"]) {
        TTStyledBlock* node = [[[TTStyledBlock alloc] init] autorelease];
        node.className =  [attributeDict objectForKey:@"class"];
        [self pushNode:node];
        
    } else if ([tag isEqualToString:@"b"] || [tag isEqualToString:@"strong"]) {
        TTStyledBoldNode* node = [[[TTStyledBoldNode alloc] init] autorelease];
        [self pushNode:node];
        
    } else if ([tag isEqualToString:@"i"] || [tag isEqualToString:@"em"]) {
        TTStyledItalicNode* node = [[[TTStyledItalicNode alloc] init] autorelease];
        [self pushNode:node];
        
    } else if ([tag isEqualToString:@"a"]) {
        TTStyledLinkNode* node = [[[TTStyledLinkNode alloc] init] autorelease];
        node.URL =  [attributeDict objectForKey:@"href"];
        node.className =  [attributeDict objectForKey:@"class"];
        [self pushNode:node];
        
    } else if ([tag isEqualToString:@"button"]) {
        TTStyledButtonNode* node = [[[TTStyledButtonNode alloc] init] autorelease];
        node.URL =  [attributeDict objectForKey:@"href"];
        [self pushNode:node];
        
    } else if ([tag isEqualToString:@"img"]) {
        TTStyledImageNode* node = [[[TTStyledImageNode alloc] init] autorelease];
        node.className =  [attributeDict objectForKey:@"class"];
        node.URL =  [attributeDict objectForKey:@"src"];
        NSString* width = [attributeDict objectForKey:@"width"];
        if (width) {
            node.width = width.floatValue;
        }
        NSString* height = [attributeDict objectForKey:@"height"];
        if (height) {
            node.height = height.floatValue;
        }
        [self pushNode:node];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!_chars) {
        _chars = [string mutableCopy];
        
    } else {
        [_chars appendString:string];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    [self flushCharacters];
    [self popNode];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData *)          parser:(NSXMLParser *)parser
   resolveExternalEntityName:(NSString *)entityName
                    systemID:(NSString *)systemID {
    static NSDictionary* entityTable = nil;
    if (!entityTable) {
        entityTable = [[NSDictionary alloc] initWithObjectsAndKeys:
                       [NSData dataWithBytes:" " length:1], @"nbsp",
                       [NSData dataWithBytes:"&" length:1], @"amp",
                       [NSData dataWithBytes:"\"" length:1], @"quot",
                       [NSData dataWithBytes:"<" length:1], @"lt",
                       [NSData dataWithBytes:">" length:1], @"gt",
                       nil];
    }
    return [entityTable objectForKey:entityName];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parseText:(NSString*)string URLs:(BOOL)shouldParseURLs {
    if (shouldParseURLs) {
        [self parseURLs:string];
    }
    else {
        TTStyledTextNode* node = [[[TTStyledTextNode alloc] initWithText:string] autorelease];
        [self addNode:node];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


//判断每一个片段是不是表情 并进行处理
-(NSInteger)handNodeEmoj:(NSInteger)location nodeStr:(NSString*)nodeStr
{
    
    
    
    int length = 2;
    while (1)
    {
        // 判断这个表情是什么，或不是表情
        NSRange r = NSMakeRange(location,length);
        if (r.location+length > nodeStr.length)
        {
            //确定不是表情
            return -1;
        }
        NSString *emojKey = [nodeStr substringWithRange:r];
        NSString *emojUrl = [emojDic objectForKey:emojKey];
        if (emojUrl) //是表情
        {
            NSString *preStr = [nodeStr substringToIndex:r.location];
            
            //   NSLog(@"%@",preStr);
            [self parseText:preStr];
            
            TTStyledImageNode* node = [[[TTStyledImageNode alloc] init] autorelease];
            node.URL = emojUrl;
            node.width = 20;
            node.height = 20;
            [self addNode:node];
            return length;
            //  return YES;
            // break;
        }
        else   //不是表情
        {
            if (length >EmojMaxLength)
            {
                //确定不是表情
                return -1;
                // return NO;
                //break;
            }
            else
            {
                length++;
            }
            
        }
    }
    
    
}


//判断每一个片段是不是new表情 并进行处理
-(NSInteger)handNodeNewEmoj:(NSInteger)location nodeStr:(NSString*)nodeStr
{
    return 0;
}





-(void)changeStrTohtml:(NSString*)str
{
    

    //    新表情
    NSRange preRange ;
    NSRange nextRange;
    
    NSString *nextStr = str;
    while (nextStr.length >0)
    {
        preRange = [nextStr rangeOfString:@"["];
        nextRange = [nextStr rangeOfString:@"]"];
        
        if (preRange.length == 0 || nextRange.length == 0)
        {//说明 没有表情了
            [self parseText:nextStr];
            return;
        }
        
        if (nextRange.location - preRange.location <=  NewEmojMaxLength)
        {
            NSString *emojKey = [nextStr substringFrom:preRange.location to:nextRange.location+1];
            NSString *emojUrl = [emojDic objectForKey:emojKey];
            
            if (emojUrl) //是表情
            {
                NSString *preStr = [nextStr substringToIndex:preRange.location];
              //  NSLog(@"%@",preStr);
                [self parseText:preStr];
                
                TTStyledImageNode* node = [[[TTStyledImageNode alloc] init] autorelease];
                node.URL = emojUrl;
                node.width = 25;
                node.height = 25;
                [self addNode:node];
                
            }
            else
            {
                NSString *preStr = [nextStr substringToIndex:nextRange.location+1];
             //   NSLog(@"%@",preStr);
                [self parseText:preStr];
                
            }
            
            
        }
        else
        {
            NSString *preStr = [nextStr substringToIndex:nextRange.location +1];
          //  NSLog(@"%@",preStr);
            [self parseText:preStr];
        }
        
        
        nextStr = [nextStr substringFromIndex:nextRange.location+1];
    }
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parseXHTML:(NSString*)html
{
    if (!html || [html isEqualToString:@""])
    {
        return;
    }
    NSString* document = [NSString stringWithFormat:@"<x>%@</x>", html];
    NSData* data = [document dataUsingEncoding:html.fastestEncoding];
    NSXMLParser* parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
    parser.delegate = self;
    [parser parse];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parseText:(NSString*)string {
    
    
    
    if (_parseLineBreaks) {
        NSCharacterSet* newLines = [NSCharacterSet newlineCharacterSet];
        NSInteger stringIndex = 0;
        NSInteger length = string.length;
        
        while (1) {
            NSRange searchRange = NSMakeRange(stringIndex, length - stringIndex);
            NSRange range = [string rangeOfCharacterFromSet:newLines options:0 range:searchRange];
            if (range.location != NSNotFound) {
                // Find all text before the line break and parse it
                NSRange textRange = NSMakeRange(stringIndex, range.location - stringIndex);
                NSString* substr = [string substringWithRange:textRange];
                [self parseText:substr URLs:_parseURLs];
                
                // Add a line break node after the text
                TTStyledLineBreakNode* br = [[[TTStyledLineBreakNode alloc] init] autorelease];
                [self addNode:br];
                stringIndex = stringIndex + substr.length + 1;
                
            }
            else {
                // Find all text until the end of hte string and parse it
                NSString* substr = [string substringFromIndex:stringIndex];
                [self parseText:substr URLs:_parseURLs];
                break;
            }
        }
        
    }
    else {
        [self parseText:string URLs:_parseURLs];
    }
}




@end
