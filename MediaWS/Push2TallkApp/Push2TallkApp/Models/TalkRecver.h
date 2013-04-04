//
//  TalkRecver.h
//  LoochaEnterprise
//
//  Created by jinquan zhang on 12-8-23.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkManager.h"
#import "AudioStreamPlayer.h"

@interface TalkRecver : NSObject <TalkManagerDataDelegate>
{
    BOOL listening;
    
    AudioStreamPlayer *player;
    
    int frameSize;
    int playBufferSize;
    short *pkgBuffer;
    int pkgBufferSize;
    int pkgBufferEnd;
}

- (id)initWithSampleRate:(NSInteger)samplerate;

- (void)start;

- (void)stop;

@end
