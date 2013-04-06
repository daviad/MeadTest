//
//  ProtoBufEncode.c
//  QuartzDemo
//
//  Created by jinquan zhang on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#include "ProtobufEncode.h"

typedef enum {
    PBWireFormatVarint = 0,
    PBWireFormatFixed64 = 1,
    PBWireFormatLengthDelimited = 2,
    PBWireFormatStartGroup = 3,
    PBWireFormatEndGroup = 4,
    PBWireFormatFixed32 = 5,
    
    PBWireFormatTagTypeBits = 3,
    PBWireFormatTagTypeMask = 7 /* = (1 << PBWireFormatTagTypeBits) - 1*/,
    
    PBWireFormatMessageSetItem = 1,
    PBWireFormatMessageSetTypeId = 2,
    PBWireFormatMessageSetMessage = 3
} PBWireFormat;

int32_t PBWireFormatMakeTag(int32_t fieldNumber, int32_t wireType) {
    return (fieldNumber << PBWireFormatTagTypeBits) | wireType;
}

/**
 * Compute the number of bytes that would be needed to encode a varint.
 * {@code value} is treated as unsigned, so it won't be sign-extended if
 * negative.
 */
int32_t computeRawVarint32Size(int32_t value) {
    if ((value & (0xffffffff <<  7)) == 0) return 1;
    if ((value & (0xffffffff << 14)) == 0) return 2;
    if ((value & (0xffffffff << 21)) == 0) return 3;
    if ((value & (0xffffffff << 28)) == 0) return 4;
    return 5;
}

/** Compute the number of bytes that would be needed to encode a tag. */
int32_t computeTagSize(int32_t fieldNumber) {
    return computeRawVarint32Size(PBWireFormatMakeTag(fieldNumber, 0));
}

/** Compute the number of bytes that would be needed to encode a varint. */
int32_t computeRawVarint64Size(int64_t value) {
    if ((value & (0xffffffffffffffffL <<  7)) == 0) return 1;
    if ((value & (0xffffffffffffffffL << 14)) == 0) return 2;
    if ((value & (0xffffffffffffffffL << 21)) == 0) return 3;
    if ((value & (0xffffffffffffffffL << 28)) == 0) return 4;
    if ((value & (0xffffffffffffffffL << 35)) == 0) return 5;
    if ((value & (0xffffffffffffffffL << 42)) == 0) return 6;
    if ((value & (0xffffffffffffffffL << 49)) == 0) return 7;
    if ((value & (0xffffffffffffffffL << 56)) == 0) return 8;
    if ((value & (0xffffffffffffffffL << 63)) == 0) return 9;
    return 10;
}

/**
 * Compute the number of bytes that would be needed to encode a
 * {@code uint64} field, including tag.
 */
int32_t computeUInt64SizeNoTag(int64_t value) {
    return computeRawVarint64Size(value);
}

/**
 * Compute the number of bytes that would be needed to encode a
 * {@code uint64} field, including tag.
 */
int32_t computeUInt64Size(int32_t fieldNumber, int64_t value) {
    return computeTagSize(fieldNumber) + computeUInt64SizeNoTag(value);
}


/**
 * Compute the number of bytes that would be needed to encode a
 * {@code uint32} field, including tag.
 */
int32_t computeUInt32SizeNoTag(int32_t value) {
    return computeRawVarint32Size(value);
}

/**
 * Compute the number of bytes that would be needed to encode a
 * {@code uint32} field, including tag.
 */
int32_t computeUInt32Size(int32_t fieldNumber, int32_t value) {
    return computeTagSize(fieldNumber) + computeUInt32SizeNoTag(value);
}

/**
 * Compute the number of bytes that would be needed to encode a
 * {@code string} field, including tag.
 */
int32_t computeStringSizeNoTag(NSString* value) {
    NSData* data = [value dataUsingEncoding:NSUTF8StringEncoding];
    return computeRawVarint32Size(data.length) + data.length;
}

/**
 * Compute the number of bytes that would be needed to encode a
 * {@code string} field, including tag.
 */
int32_t computeStringSize(int32_t fieldNumber, NSString* value) {
    return computeTagSize(fieldNumber) + computeStringSizeNoTag(value);
}

void writeUInt64ToStream(ByteStream bs, int fieldNumber, int64_t value)
{
    unsigned int tag = PBWireFormatMakeTag(fieldNumber, 0);
    int tagSize = computeRawVarint32Size(tag);
    int size = computeRawVarint64Size(value);
    
    if (tagSize == 1) {
        Output(bs, tag);
    }
    else {
        for (int i = 0, last = tagSize - 1; i < last; i++, tag >>= 7) {
            Output(bs, (tag & 0x7F) | 0x80);
        }
        Output(bs, tag);
    }
    if (size == 1) {
        Output(bs, value);
    }
    else {
        for (int i = 0, last = size - 1; i < last; i++, value >>= 7) {
            Output(bs, ((int)value & 0x7F) | 0x80);
        }
        Output(bs, value);
    }
}

void writeInt32ToStream(ByteStream bs, int fieldNumber, int32_t value)
{
    unsigned int tag = PBWireFormatMakeTag(fieldNumber, 0);
    int tagSize = computeRawVarint32Size(tag);
    int size = computeRawVarint32Size(value);
    
    if (tagSize == 1) {
        Output(bs, tag);
    }
    else {
        for (int i = 0, last = tagSize - 1; i < last; i++, tag >>= 7) {
            Output(bs, (tag & 0x7F) | 0x80);
        }
        Output(bs, tag);
    }
    if (size == 1) {
        Output(bs, value);
    }
    else {
        for (int i = 0, last = size - 1; i < last; i++, value >>= 7) {
            Output(bs, ((int)value & 0x7F) | 0x80);
        }
        Output(bs, value);
    }
}

void writeStringToStream(ByteStream bs, int fieldNumber, NSString *value)
{
    unsigned int tag = PBWireFormatMakeTag(fieldNumber, PBWireFormatLengthDelimited);
    int tagSize = computeRawVarint32Size(tag);
    if (tagSize == 1) {
        Output(bs, tag);
    }
    else {
        for (int i = 0, last = tagSize - 1; i < last; i++, tag >>= 7) {
            Output(bs, (tag & 0x7F) | 0x80);
        }
        Output(bs, tag);
    }
    NSData* data = [value dataUsingEncoding:NSUTF8StringEncoding];
    int length = data.length;
    int lengthSize = computeRawVarint32Size(length);
    if (lengthSize == 1) {
        Output(bs, length);
    }
    else {
        for (int i = 0, last = lengthSize - 1; i < last; i++, length >>= 7) {
            Output(bs, (length & 0x7F) | 0x80);
        }
        Output(bs, length);
    }
    if (data.length > 0) {
        memcpy(*bs, data.bytes, data.length);
        *bs += data.length;
    }
}
