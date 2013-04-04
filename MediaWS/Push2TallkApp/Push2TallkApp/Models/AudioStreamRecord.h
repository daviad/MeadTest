#ifndef _AUDIOSTREAMRECORD_H
#define _AUDIOSTREAMRECORD_H

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioQueue.h>

#define NUM_BUFFERS 3
//#define kAudioConverterPropertyMaximumOutputPacketSize		'xops'
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

typedef void (*HandleRecordBuffer)(id o,
                                   short    *Data,
                                   UInt32    length);
typedef void (*HandleStopRecord)(id o);

typedef struct
{
    AudioStreamBasicDescription dataFormat;
    AudioQueueRef               queue;
    UInt32                      bufferByteSize; 
    BOOL                        recording;
    HandleRecordBuffer          callback;
    AudioQueueBufferRef         buffers[NUM_BUFFERS];
    id                          obj;
} RecordStateEx;


@interface AudioStreamRecord : NSObject {
	RecordStateEx recordState;
}

- (BOOL)	isRecording;

// Manual recording
- (void)	startRecording;
- (void)	stopRecording;
- (void)setupAudioSample:(Float64)samplerate Channel:(int) channel;
- (void)setupAudioCallback:(HandleRecordBuffer)callback AndObj :(id)obj;
@end

#endif