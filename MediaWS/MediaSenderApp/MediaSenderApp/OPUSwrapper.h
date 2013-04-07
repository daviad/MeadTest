//
//  OPUSwrapper.h
//  LooCha
//
//  Created by 熊 财兴 on 11-11-17.
//  Copyright (c) 2011年 真云. All rights reserved.
//
#ifndef _OPUSWRAPPER__H
#define _OPUSWRAPPER__H

#include <opus.h>
#include <opus_private.h>

//(48000*60/1000)
#define MAX_FRAME 2880 
#define MAX_PACKET 1500

#ifdef __cplusplus
extern "C" {
#endif

int opusEncodeOpen(int sampling_rate, int channels);
    
int opusDecodeOpen(int sampling_rate, int channels);
    
int opusEncodeClose();

int opusDecodeClose();

int opusSetEncodeBitrate(int bitrate);

int opusEncodeInit(int sampling_rate, int channels);

int opusDecodeInit (int sampling_rate, int channels);

int opusEncode(const short *in, unsigned char *enc_payload, int frame_size);

int opusDecode(const unsigned char *buffer, short *output_buffer, int size, int frame_size);

#ifdef __cplusplus
}
#endif

#endif
