//
//  TalkRecver.m
//  LoochaEnterprise
//
//  Created by jinquan zhang on 12-8-23.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import "TalkRecver.h"
#import "OPUSwrapper.h"

@interface TalkRecver ()

@property (readwrite) BOOL listening;

@end

@implementation TalkRecver

@synthesize listening;

- (id)initWithSampleRate:(NSInteger)samplerate
{
    self = [super init];
    if (self) {
        opusDecodeOpen(samplerate, 1);
        
        player = [[AudioStreamPlayer alloc] init];
        [player setupSampleRate:samplerate channel:1];
        
        frameSize = samplerate * 60/1000;
        playBufferSize = [player queueBufferByteSize]/2;
        
        pkgBufferSize = playBufferSize + frameSize * 2;
        pkgBufferEnd = 0;
        pkgBuffer = malloc(pkgBufferSize * sizeof(short));
    }
    return self;
}

- (void)dealloc
{
    opusDecodeClose();
    [player release];
    free(pkgBuffer);
    [super dealloc];
}

- (void)start
{
    RCTrace(@"before start playing");
    self.listening = YES;
    if (![player isPlaying]) {
        [player startPlaying];
    }
    RCTrace(@"after start playing");
}

- (void)stop
{
    RCTrace(@"before stop playing");
    if ([player isPlaying]) {
        [player stopPlaying];
    }
    RCTrace(@"after stop playing");
    self.listening = NO;
}

#pragma mark - TalkManagerDataDelegate

- (void)talkManager:(TalkManager *)talkManager responsedWithData:(unsigned char *)data length:(int)length
{
    if (![player isPlaying]) {
        RCError(@"data arrived, but the player is not playing");
        return;
    }
    int pkgBufferBegin = 0;
    int delen = opusDecode(data, pkgBuffer + pkgBufferEnd, length, frameSize);
    pkgBufferEnd += delen;
    
    while (pkgBufferEnd - pkgBufferBegin >= playBufferSize) {
        AudioQueueBufferRef queueBuffer = [player getEmptyQueueBuffer];
        if (queueBuffer)
        {
            memcpy(queueBuffer->mAudioData, pkgBuffer + pkgBufferBegin, playBufferSize * sizeof(short));
            queueBuffer->mPacketDescriptionCount = playBufferSize;
            queueBuffer->mAudioDataByteSize = playBufferSize * 2;
            
            [player putQueueBuffer:queueBuffer];
            
            pkgBufferBegin += playBufferSize;
        }
    }
    if (pkgBufferEnd > pkgBufferBegin) {
        memcpy(pkgBuffer + pkgBufferBegin, pkgBuffer + pkgBufferEnd, (pkgBufferEnd - pkgBufferBegin) * sizeof(short));
    }
    pkgBufferEnd -= pkgBufferBegin;
}

@end
