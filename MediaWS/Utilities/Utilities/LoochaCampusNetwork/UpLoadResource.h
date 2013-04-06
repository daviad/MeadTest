//
//  UpLoad.h
//  LooCha
//
//  Created by hh k on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#ifndef _UPLOADRESOURCE__H
#define _UPLOADRESOURCE__H
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import "UpLoadResourceConstants.h"
#import "TaskDAO.h"
#import "JobDAO.h"



#define SCHEDULE_QUEUE "uploadScheduleQueue"
#define EXCUTE_QUEUE "uploadExcuteQueue"
#define REQUEST_QUEUE "requestQueue"
#define DOWNLOAD_QUEUE "downloadScheduleQueue"
#define CANCEL_QUEUE   "cancelRequestQueue"




@interface UpLoadResource : NSObject
{
    dispatch_queue_t atachmentQueue;            //upload file one by one
    dispatch_queue_t mainJobQueue;              //upload main job
    dispatch_queue_t executeQueue;              //upload in multi thread
    dispatch_queue_t downloadQueue;             //donwload file one by one
    dispatch_queue_t cancelQueue;               //cancel request queue
    NSMutableDictionary *requestDic;
    NSMutableDictionary *requestCancelDic;      //用于取消请求
    TaskDAO *taskDao;
    JobDAO *jobDao;
    
    
    NSLock *finishLock;
}


@property (nonatomic,retain)NSString *login;
@property (nonatomic,retain)NSString *password; 
@property (nonatomic,retain) NSDictionary * emoDic;
@property (atomic,assign) NSDictionary *currentUploadJob;
@property (atomic,assign) NSDictionary *currentDownloadJob;
@property (atomic,assign) ASIHTTPRequest *currentUploadRequest;
@property (atomic,assign) ASIHTTPRequest *currentDownloadReuqest;

- (void)sendRequest:(NSURL *)url withType:(int)type;
- (void)postRequest:(NSURL *)url withType:(int)type;
- (void)putRequest:(NSURL *)url withType:(int)type;

- (void)cancelRequest:(NSString *)url;
- (void)cancelDownloadJob:(NSString *)job;
- (void)cancelUploadJob:(NSString *)job;
- (void)cancelDownloadJobWithTaskId:(NSString *)job;

- (void)resendTaskByTaskId:(NSString *)taskId withRefreshType:(int)refreshType;
- (void)cancelAllJob;

+ (UpLoadResource*)sharedInstance;
+ (void)releaseInstance;


@end
#endif