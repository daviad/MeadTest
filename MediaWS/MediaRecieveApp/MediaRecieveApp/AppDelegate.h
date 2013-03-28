//
//  AppDelegate.h
//  Mediareceiver
//
//  Created by ding xiuwei on 13-1-22.
//  Copyright (c) 2013年 ding xiuwei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
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


@end
