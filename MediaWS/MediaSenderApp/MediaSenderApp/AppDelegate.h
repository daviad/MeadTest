//
//  AppDelegate.h
//  MediaSenderApp
//
//  Created by ding xiuwei on 13-3-22.
//  Copyright (c) 2013年 ding xiuwei. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureFileOutputRecordingDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>
{
    AVCaptureStillImageOutput *stillImageOutput;
    
    AVCaptureSession *captureSession;
    AVCaptureConnection *audioConnection;
	AVCaptureConnection *videoConnection;
    
    
    NSURL *movieURL;
    AVAssetWriter *assetWriter;
    AVAssetWriterInput *assetWriterAudioIn;
	AVAssetWriterInput *assetWriterVideoIn;
    
    
    // Only accessed on movie writing queue
    BOOL readyToRecordAudio;
    BOOL readyToRecordVideo;
	BOOL recordingWillBeStarted;
	BOOL recordingWillBeStopped;
    
	BOOL recording;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@end
