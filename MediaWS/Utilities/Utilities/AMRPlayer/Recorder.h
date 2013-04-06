//
//  Recorder.h
//  LooCha
//
//  Created by XiongCaixing on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioFile.h>
#import "PersistentDirectory.h"

#define NUM_BUFFERS 3
#define kAudioConverterPropertyMaximumOutputPacketSize		'xops'
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

typedef struct
{
    AudioFileID                 audioFile;
    AudioStreamBasicDescription dataFormat;
    AudioQueueRef               queue;
    AudioQueueBufferRef         buffers[NUM_BUFFERS];
    UInt32                      bufferByteSize; 
    SInt64                      currentPacket;
    BOOL                        recording;
    void *st;
    void *enstate;
    FILE *fpamr;
} RecordState;

@interface Recorder : NSObject {
	RecordState recordState;
	CFURLRef fileURL;
}

- (BOOL)	isRecording;
- (float) averagePower;
- (float) peakPower;
// Automatically generate a dated file in Documents
- (void) toggleRecording:(NSString*)fileName compleate:(dispatch_block_t) block;

// Manual recording
- (void)	startRecording: (NSString *) filePath;
- (void)	stopRecording;
- (float)   redordDuration:(NSString *)fileName;
@end