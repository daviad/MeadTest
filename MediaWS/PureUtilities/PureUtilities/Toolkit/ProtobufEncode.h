//
//  ProtobufEncode.h
//  QuartzDemo
//
//  Created by jinquan zhang on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef QuartzDemo_ProtobufEncode_h
#define QuartzDemo_ProtobufEncode_h

#import <Foundation/Foundation.h>
#include <stdlib.h>

typedef unsigned char ** ByteStream;

// bs : ByteStream
// b  : byte value
#define Output(bs, b) { **(bs) = (unsigned char)(b); (*(bs))++; }

int32_t computeUInt64Size(int32_t fieldNumber, int64_t value);

int32_t computeUInt32Size(int32_t fieldNumber, int32_t value);

int32_t computeStringSize(int32_t fieldNumber, NSString* value);

void writeUInt64ToStream(ByteStream bs, int fieldNumber, int64_t value);

void writeInt32ToStream(ByteStream bs, int fieldNumber, int32_t value);

void writeStringToStream(ByteStream bs, int fieldNumber, NSString *value);

#endif
