//
//  OPUSwrapper.h
//  LooCha
//
//  Created by 熊 财兴 on 11-11-17.
//  Copyright (c) 2011年 真云. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "OPUSwrapper.h"

OpusEncoder *g_enc;
OpusDecoder *g_dec;

static int g_complexity = -1;

int initCodec(OpusEncoder *enc, int sampling_rate, int channels)
{
	int ret = 0;
	if (NULL != enc)
	{
		ret = opus_encoder_ctl(enc, OPUS_SET_SIGNAL(OPUS_SIGNAL_VOICE));
		/*	
         opus_encoder_ctl(enc, OPUS_SET_INBAND_FEC(1));
         opus_encoder_ctl(enc, OPUS_SET_VBR_FLAG(1));
         opus_encoder_ctl(enc, OPUS_SET_DTX_FLAG(0));
         opus_encoder_ctl(enc, OPUS_SET_PACKET_LOSS_PERC(0));
         opus_encoder_ctl(enc, OPUS_SET_BANDWIDTH(OPUS_BANDWIDTH_NARROWBAND));
         opus_encoder_ctl(enc, OPUS_SET_COMPLEXITY(10));
         */
		ret |= opus_encoder_ctl(enc, OPUS_SET_BANDWIDTH(OPUS_BANDWIDTH_NARROWBAND));
		ret |= opus_encoder_ctl(enc, OPUS_SET_FORCE_MODE(MODE_HYBRID));
	}
    
	return ret;
}

#if 0

int opusOpen (int sampling_rate, int channels) 
{
	int error = OPUS_OK;	
	if (codec_open++ != 0) 
	{
		error = opus_encoder_init(g_enc, sampling_rate, channels, OPUS_APPLICATION_VOIP);
		error |= opus_decoder_init(g_dec, sampling_rate, channels);
	}
	else
	{
		g_enc = opus_encoder_create(sampling_rate, channels, OPUS_APPLICATION_VOIP, &error);		
		g_dec = opus_decoder_create(sampling_rate, channels, &error);
	}
	
	error |= initCodec(g_enc, sampling_rate, channels);
    
	return error;
}

#endif

int opusSetEncodeBitrate(int bitrate) 
{
	if (!g_enc)
		return -1;
	
	return opus_encoder_ctl(g_enc, OPUS_SET_BITRATE(bitrate));
}

int opusEncodeInit(int sampling_rate, int channels) 
{
	if (!g_enc)
		return -1;
	
	int ret = opus_encoder_init(g_enc, sampling_rate, channels, OPUS_APPLICATION_VOIP);
	ret |= initCodec(g_enc, sampling_rate, channels);
    
	return ret;
}

int opusDecodeInit (int sampling_rate, int channels) 
{
	if (!g_dec)
		return -1;
	
	return opus_decoder_init(g_dec, sampling_rate, channels);
}


int opusEncode(const short *in, unsigned char *enc_payload, int frame_size) 
{
	if (!g_enc)
		return 0;
    
	if (g_complexity != 10) 
	{
		g_complexity = 10;
		opus_encoder_ctl(g_enc, OPUS_SET_COMPLEXITY(g_complexity));
	}
	
	return opus_encode(g_enc,
                          (const short *)in,
                          frame_size,
                          (unsigned char *)enc_payload, 
                          MAX_PACKET);
}

int opusDecode(const unsigned char *buffer, short *output_buffer, int size, int frame_size) 
{
	if (!g_dec)
		return 0;
	
	return opus_decode(g_dec, buffer, size, output_buffer, frame_size, 0);
}

#if 0

void opusClose() {
    if (--codec_open != 0)
		return;
    
    opus_encoder_destroy(g_enc);
    opus_decoder_destroy(g_dec);
}

#endif

int opusEncodeOpen(int sampling_rate, int channels)
{
    if (g_enc) {
        return 0;
    }
    int error = OPUS_OK;
    g_enc = opus_encoder_create(sampling_rate, channels, OPUS_APPLICATION_VOIP, &error);
    error |= initCodec(g_enc, sampling_rate, channels);
    return error;
}

int opusDecodeOpen(int sampling_rate, int channels)
{
    if (g_dec) {
        return 0;
    }
    int error = OPUS_OK;
    g_dec = opus_decoder_create(sampling_rate, channels, &error);
    return error;
}

int opusEncodeClose()
{
    if (g_enc) {
        opus_encoder_destroy(g_enc);
        g_enc = NULL;
    }
    return 0;
}

int opusDecodeClose()
{
    if (g_dec) {
        opus_decoder_destroy(g_dec);
        g_dec = NULL;
    }
    return 0;
}