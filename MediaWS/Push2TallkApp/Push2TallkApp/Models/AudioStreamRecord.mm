
#import <AVFoundation/AVFoundation.h>
#import "AudioStreamRecord.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation AudioStreamRecord

// Write out current packets
static void HandleInputBuffer (
							   void                                 *aqData,
							   AudioQueueRef                        inAQ,
							   AudioQueueBufferRef                  inBuffer,
							   const AudioTimeStamp                 *inStartTime,
							   UInt32                               inNumPackets,
							   const AudioStreamPacketDescription   *inPacketDesc
                               ) {
    RecordStateEx *pAqData = (RecordStateEx *) aqData;
	
    if (inNumPackets == 0 &&                      
		pAqData->dataFormat.mBytesPerPacket != 0)
		inNumPackets = inBuffer->mAudioDataByteSize / pAqData->dataFormat.mBytesPerPacket;
	
    if (pAqData->recording == 0 || inNumPackets == 0)              
        return;
		
    pAqData->callback(pAqData->obj, (short *)inBuffer->mAudioData, inNumPackets);
    OSStatus status = AudioQueueEnqueueBuffer (                 
								 pAqData->queue,
								 inBuffer,
								 0,
								 NULL
								 );
    if (status != 0) {
		printf("HandleInputBuffer:Could not establish new queue\n");
		return;
	}
}

// Derive the Buffer Size. I punt with the max buffer size.
static void DeriveBufferSize (
					   AudioQueueRef                audioQueue,
					   AudioStreamBasicDescription  ASBDescription,
					   Float64                      seconds,
					   UInt32                       *outBufferSize
                       ) {
    static const int maxBufferSize = 0x50000;   
	
    int maxPacketSize = ASBDescription.mBytesPerPacket; 
    if (maxPacketSize == 0) {                           
        UInt32 maxVBRPacketSize = sizeof(maxPacketSize);
        AudioQueueGetProperty (
							   audioQueue,
							   kAudioConverterPropertyMaximumOutputPacketSize,
							   &maxPacketSize,
							   &maxVBRPacketSize
							   );
    }
	
    Float64 numBytesForTime =
	ASBDescription.mSampleRate * maxPacketSize * seconds;
    *outBufferSize =  (UInt32) ((numBytesForTime < maxBufferSize) ? numBytesForTime : maxBufferSize);                     // 9
}

// Initialize the recorder
- (id) init
{
	self = [super init];
	recordState.recording = NO;	
	return self;
}

- (void)initAudioQueue
{
    OSStatus status;
    status = AudioQueueNewInput(&recordState.dataFormat,
								HandleInputBuffer, 
								&recordState,
								nil,//CFRunLoopGetCurrent(),
								nil,//kCFRunLoopCommonModes,
								0,
								&recordState.queue);
	
	
	if (status != 0) {
		printf("startRecording:Could not establish new queue\n");
		return;
	}
	
	DeriveBufferSize (                               
					  recordState.queue,                
					  recordState.dataFormat,            
					  0.06, //60ms                          
					  &recordState.bufferByteSize
					  );
    
    printf("Buffer size: %lu\n", recordState.bufferByteSize);
	
//    for(int i = 0; i < NUM_BUFFERS; i++)
//	{
//		status = AudioQueueAllocateBuffer(recordState.queue,
//										  recordState.bufferByteSize, 
//										  &recordState.buffers[i]);
//		if (status) {
//			printf("Error allocating buffer %d\n", i);
//			return;
//		}
//	}
}

- (void)destoryAudioQueue
{
    [self stopRecording];	
    //OSStatus status = AudioQueueDispose(recordState.queue, true);
    AudioQueueDispose(recordState.queue, true);
}

// Set up the recording format as low quality mono wav
- (void)setupAudioSample:(Float64)samplerate Channel:(int) channel
{
	recordState.dataFormat.mSampleRate = samplerate;
	recordState.dataFormat.mFormatID = kAudioFormatLinearPCM;
	recordState.dataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked; 
	
	recordState.dataFormat.mChannelsPerFrame = channel; // mono
	recordState.dataFormat.mBitsPerChannel = 16; 
	recordState.dataFormat.mFramesPerPacket = 1;
    recordState.dataFormat.mBytesPerPacket = 2; 
	
	recordState.dataFormat.mBytesPerFrame = 2; // not used, apparently required
	recordState.dataFormat.mReserved = 0; 
    
    [self initAudioQueue];
}

- (void)setupAudioCallback:(HandleRecordBuffer)callback AndObj :(id)obj
{
    recordState.callback = callback;
    recordState.obj = obj;
}

// Begin recording
- (void) startRecording
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:NULL];
    OSStatus status;
    for(int i = 0; i < NUM_BUFFERS; i++)
	{
		status = AudioQueueAllocateBuffer(recordState.queue,
										  recordState.bufferByteSize, 
										  &recordState.buffers[i]);
		if (status) {
			printf("Error allocating buffer %d\n", i);
			return;
		}

		status = AudioQueueEnqueueBuffer(recordState.queue, recordState.buffers[i], 0, NULL);
		if (status) {
			printf("Error enqueuing buffer %d\n", i);
			return;
		}  
	}
	status = AudioQueueStart(recordState.queue, NULL);
	if (status != 0)
	{
		printf("Could not start Audio Queue\n");
		return;
	}
	
	recordState.recording = YES;
	return;
}

// There's generally about a one-second delay before the buffers fully empty
- (void) reallyStopRecording
{
    OSStatus status;
	status = AudioQueueFlush(recordState.queue);
    status = AudioQueueStop(recordState.queue, true);
    recordState.recording = NO;
    for(int i = 0; i < NUM_BUFFERS; i++)
    {
        AudioQueueFreeBuffer(recordState.queue,
							 recordState.buffers[i]);
    }
}

- (void)dealloc
{
    [self destoryAudioQueue];
    [super dealloc];
}

// Stop the recording after waiting just a second
- (void) stopRecording
{
    [self reallyStopRecording];
	//[self performSelector:@selector(reallyStopRecording) withObject:NULL afterDelay:0.2f];
}


- (BOOL) isRecording
{
	return recordState.recording;
}

@end