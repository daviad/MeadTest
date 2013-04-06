//
//  UpLoad.m
//  LooCha
//
//  Created by hh k on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UpLoadResource.h"
#import "CJSONSerializer.h"
#import "Global.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"
#import "NSStringAdditions.h"
#import "RCHelper.h"
#import "PersistentDirectory.h"
@interface UpLoadResource(private)

@end

@implementation UpLoadResource
@synthesize login;
@synthesize password;
@synthesize emoDic;
@synthesize currentUploadJob,currentDownloadJob;
@synthesize currentDownloadReuqest,currentUploadRequest;
static UpLoadResource *sharedInstance;

#define INVALID_MARK  @"/(null)"
#define Version_MARK  [NSString stringWithFormat:@"1=iphone_%d_%@",kVersionNumberLocal,machineName()]
- (id)init 
{
    self = [super init];
    if(self)
    {
        executeQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        atachmentQueue = dispatch_queue_create(SCHEDULE_QUEUE, NULL);
        mainJobQueue = dispatch_queue_create(REQUEST_QUEUE, NULL);
        downloadQueue = dispatch_queue_create(DOWNLOAD_QUEUE, NULL);
        cancelQueue = dispatch_queue_create(CANCEL_QUEUE, NULL);
        requestDic = [[NSMutableDictionary alloc] init];
        requestCancelDic = [[NSMutableDictionary alloc] init];
        jobDao = [[JobDAO alloc] init];
        taskDao = [[TaskDAO alloc] init];
        emoDic = [[NSDictionary alloc] init];
        currentUploadJob = nil;
        currentDownloadJob = nil;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invoke:) name:INVOKE_UPLOADMODULE object:nil];
        
    }
    return self;
    
}

+ (UpLoadResource*)sharedInstance
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UpLoadResource alloc] init];
    });
	return sharedInstance;
}

+ (void)releaseInstance
{
    [sharedInstance release];
}


- (void)dealloc
{
    dispatch_release(atachmentQueue);
    dispatch_release(mainJobQueue);
    dispatch_release(downloadQueue);
    dispatch_release(cancelQueue);
    atachmentQueue = nil;
    mainJobQueue = nil;
    downloadQueue = nil;
    [requestDic release];
    [requestCancelDic release];
    [jobDao release];
    [taskDao release];
    [emoDic release];
    [currentUploadJob release];
    [currentDownloadJob release];
    [super dealloc];
}

#pragma mark cancel job methods
-(void)cancelAllJob
{
    @synchronized (requestCancelDic)
    {
        for(NSString *url in requestCancelDic)
        {
            RCDebug(@"cancel request %@",url);
            ASIFormDataRequest *theRequest = [[requestCancelDic valueForKey:url] retain];
            [theRequest clearDelegatesAndCancel];
            [theRequest release];
        }
        RCTrace(@"cancel request Dic:%@",requestCancelDic);
        [requestCancelDic removeAllObjects];
    }
    @synchronized (requestDic)
    {
        [requestDic removeAllObjects];
    }
}

-(void)cancelRequest:(NSString *)url
{
    dispatch_async(cancelQueue, ^{
        RCDebug(@"cancel request %@",url);
        @synchronized (requestCancelDic)
        {
            ASIFormDataRequest *theRequest = [[requestCancelDic valueForKey:url] retain];
            [requestCancelDic removeObjectForKey:url];
            [theRequest clearDelegatesAndCancel];
            [theRequest release];
        }
        @synchronized (requestDic)
        {
            [requestDic removeObjectForKey:url];
        }
    });
}

-(void)cancelDownloadJob:(NSString *)url
{
    
    url = [NSString stringWithFormat:@"%@%@",kPicURLPath,url];
    id result = [jobDao searchRunningJobByURL:url];
    for (id dic in result)
    {
        NSString *job = [dic valueForKey:JOB_TASK_ID];
        [self cancelJob:job withCurrentJob:currentDownloadJob withCurrentRequest:currentDownloadReuqest];
    }
}

- (void)cancelDownloadJobWithTaskId:(NSString *)job
{
    [self cancelJob:job withCurrentJob:currentDownloadJob withCurrentRequest:currentDownloadReuqest];
}


-(void)cancelUploadJob:(NSString *)job
{
    [self cancelJob:job withCurrentJob:currentUploadJob withCurrentRequest:currentUploadRequest];
}

-(void)cancelJob:(NSString *)taskId withCurrentJob:(NSDictionary *)job withCurrentRequest:(ASIHTTPRequest *)request
{
    
    dispatch_async(cancelQueue, ^{
        if([[job valueForKey:JOB_TASK_ID] isEqualToString:taskId])
            [request clearDelegatesAndCancel];
        [jobDao updateStatus:jobCancel ByTask:taskId];
        RCDebug(@"cancel job %@",taskId);
    });
}


#pragma mark preprocess job
-(void)invoke:(NSNotification *)notification
{
    NSArray *tasks;
    @synchronized(self)
    {
        tasks = [taskDao searchTaskByStatusAndSetStatus:[NSString stringWithFormat:@"%@",[[notification userInfo] valueForKey:TASK_STATUS]]];
    }
    for(NSDictionary *task in tasks)
    {
        NSArray *jobs = [jobDao searchJobByTaskId:[task objectForKey:TASK_ID]];
        for (NSDictionary *job in jobs) 
        {
            //process every job in the task
            id filePath = [job valueForKey:JOB_FILE_PATH];
            BOOL isAttachementJob = NO;
            BOOL isDownLoad = NO;
            id parseData = nil;
            
            if([[job valueForKey:JOB_COMMAND] isEqualToString:METHOD_DOWNLOAD])
            {
                isDownLoad = YES;
            }
            else
            {
                //get the json
                if(filePath && ![filePath isKindOfClass:[NSNull class]])
                {
                    parseData = [self parseFileData:[job valueForKey:JOB_JSON] withFilePath:filePath];
                    isAttachementJob = YES;
                }
                else
                {
                    id json = [job valueForKey:JOB_JSON];
                    if( json && ![json isKindOfClass:[NSNull class]])
                        parseData = [json JSONValue];
                    isAttachementJob = NO;
                }
            }
            //dic for job call back
            NSDictionary *jobStatus = [[NSDictionary alloc ] initWithObjectsAndKeys:
                                       [job valueForKey:JOB_ID],JOB_ID,
                                       [job valueForKey:JOB_TASK_ID],JOB_TASK_ID,
                                       [job valueForKey:JOB_IS_MAIN],JOB_IS_MAIN,
                                       [job valueForKey:JOB_FILE_PATH],JOB_FILE_PATH,nil];
            __block NSMutableDictionary *callBack = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *jobDic = [[NSMutableDictionary alloc ] initWithObjectsAndKeys:
                                                                jobStatus,  KEY_JOB,
                                                                callBack,   KEY_CALLBACK,
                                                                task,       KEY_TASK, nil];

            
            
            
            
            //define the process block
            dispatch_block_t block = ^{
                    [self loadDataWithRequestMethod:[job valueForKey:JOB_COMMAND] withData:parseData
                                            withURL:[NSURL URLWithString:[job valueForKey:JOB_URL]] withJob:jobDic
                                         withHeader:[job valueForKey:JOB_HEADER]];
            };
            
            //process the job by job type
            if(isDownLoad)
            {
                dispatch_async(downloadQueue, ^{
                    self.currentDownloadJob = jobStatus;
                    [self downloadWithURL:[NSURL URLWithString:[job valueForKey:JOB_URL]]
                                  dstPath:[job valueForKey:JOB_FILE_PATH]
                             withCallBack:jobDic];
                    dispatch_sync(cancelQueue, ^{
                        self.currentDownloadJob = nil;
                        self.currentDownloadReuqest = nil;
                    });
                    [callBack release];
                    [jobStatus release];
                    [jobDic release];
                });
            }
            else if(isAttachementJob)
                dispatch_async(atachmentQueue, ^{
                    self.currentUploadJob = jobStatus;
                    block();
                    dispatch_sync(cancelQueue, ^{
                        self.currentUploadJob = nil;
                        self.currentUploadRequest = nil;
                    });
                    [self uploadAttachmentComplete:jobDic];
                    [callBack release];
                    [jobStatus release];
                    [jobDic release];
                });
            else
                dispatch_async(mainJobQueue, ^{
                    block();
                    [self mainJobComplete:jobDic];
                    [callBack release];
                    [jobStatus release];
                    [jobDic release];
                });
            
        }
    }
}

- (id)parseFileData:(NSString *)json withFilePath:(NSString*)filePath
{
    NSMutableDictionary *fileJson = [NSMutableDictionary dictionaryWithDictionary:[json JSONValue]] ;
    NSData *file = [NSData dataWithContentsOfFile:filePath];
    NSData *thumb = [NSData dataWithContentsOfFile:[filePath stringByAppendingString:@"_thumbnail"]];
    for(NSString *key in [fileJson allKeys])
    {
        id value = [fileJson valueForKey:key];
        if([value isKindOfClass:[NSString class]] && [value isEqualToString:MARK_FILE_DATA])
        {
            if(file)
                [fileJson setValue:file forKey:key];
            else 
                [fileJson removeObjectForKey:key];
        }
        else if([value isKindOfClass:[NSString class]] && [value isEqualToString:MARK_THUMBNAIL_DATA])
        {
            if(thumb)
                [fileJson setValue:thumb forKey:key];
            else 
                [fileJson removeObjectForKey:key];
        }
    }
    return fileJson;
    
}


- (BOOL)HasRequest:(NSURL *)url type:(int)type
{
    __block BOOL result = false;
    @synchronized (requestDic)
    {
        for(NSString *urlkey in [requestDic allKeys])
        {
            
            if([urlkey isEqualToString:[url absoluteString]])
                result = true;
        }
        if(!result)
        {
            RCDebug(@"add request %@",url);
            [requestDic setValue:[NSNumber numberWithInt:type] forKey:[url absoluteString]];
        }
    }
    return result;
}



#pragma mark get/post/put request
- (void)sendRequest:(NSURL *)url withType:(int)type
{
    //if url is nil return failed
    if(!url)
    {
        [Global sendMessageToControllers:type withResult:[SERVER_REQUEST_FAILED intValue] withArg:nil];
        return;
    }
    if([self HasRequest:url type:type])
        return;
    dispatch_async(executeQueue, ^{
        [self loadData:url];
    });

}

- (void)postRequest:(NSURL *)url withType:(int)type
{
    if([self HasRequest:url type:type])
        return;
    dispatch_async(executeQueue, ^{
        [self loadData:url withCommond:METHOD_POST];
    });
}

- (void)putRequest:(NSURL *)url withType:(int)type
{
    if([self HasRequest:url type:type])
        return;
    dispatch_async(executeQueue, ^{
        [self loadData:url withCommond:METHOD_PUT];
    });
}

#pragma mark Network jobs
- (void)loadData:(NSURL *)theURL withCommond:(NSString *)method
{
	// Send the request
    if (![[theURL absoluteString] containsString:INVALID_MARK])
    {
        ASIFormDataRequest *theRequest = [self authenticatedRequestForURL:theURL];
        if([theURL absoluteString])
        {
            @synchronized (requestCancelDic)
            {
                [requestCancelDic setValue:theRequest forKey:[theURL absoluteString]];
            }
        }
        [theRequest setRequestMethod:method];
        [theRequest setDelegate:self];
        [theRequest setDidFinishSelector:@selector(loadingFinished:)];
        [theRequest setDidFailSelector:@selector(loadingFailed:)];
        [theRequest startSynchronous];
    }
}

- (void)loadData:(NSURL *)theURL
{
    [self loadData:theURL withCommond:METHOD_GET];
}

- (void)loadDataWithRequestMethod:(NSString *)theMethod withData:(id)objectData withURL:(NSURL *)theURL withJob:(id)job withHeader:(id)header
{
    [self loadDataWithRequestMethod:theMethod withData:objectData withURL:theURL progress:nil withJob:job withHeader:header];
}

#define JSONKEY_JSON        @"json"
#define JSONKEY_JSON2       @"json2"
#define JSONKEY_FILE        @"file"
#define JSONKEY_THUMBNAIL   @"thumb"
#define JSONKEY_COVER       @"cover"
- (void)loadDataWithRequestMethod:(NSString *)theMethod withData:(id)objectData withURL:(NSURL *)theURL progress:(id)progress withJob:(id)job withHeader:(id)header
{
    // Send the request
    ASIFormDataRequest *theRequest = [self authenticatedRequestForURL:theURL];
    __block int status;
    if([job valueForKey:KEY_JOB] == self.currentUploadJob)
    {
        //获取当前job状态 如果不为read状态则不做此任务
        dispatch_sync(cancelQueue, ^{
            status = [[[[jobDao search:[job valueForKey:KEY_JOB] type:0 waitUntiDone:YES] lastObject] valueForKey:JOB_STATUS] intValue];
            if(status == jobIsReady || status == jobProcessing)
                self.currentUploadRequest = theRequest;
            else
            {
                self.currentUploadRequest = nil;
                self.currentUploadJob = nil;
            }
        });
        if(status == jobCancel || status == jobFinished)
            return;
        if([[theURL absoluteString] containsString:INVALID_MARK])
        {
            [theRequest setJob:job];
            [self updateTask:[job valueForKey:KEY_JOB] Status:uploadFailed];
            [self loadingFailedCallback:theRequest];
            return;
        }
        
    }
    [theRequest setRequestMethod:theMethod];
    [theRequest setUploadProgressDelegate:progress];
    [theRequest setDelegate:self];
    [theRequest setDidFinishSelector:@selector(loadingFinished:)];
    [theRequest setDidFailSelector:@selector(loadingFailed:)];
    [theRequest setJob:job];
    theRequest.showAccurateProgress = YES;
    if (!header || ([header isKindOfClass:[NSString class]] && [header isEqualToString:@""])) header = HEADER_SINGER;
    [theRequest addRequestHeader:@"Content-Type" value:header];
    if ([objectData isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dic = (NSDictionary *)objectData;
        NSString *contentType = nil;
        BOOL flag = NO;
        //process mulit json
        for (NSString *key in [dic allKeys])
        {
            contentType = nil;
            if([key isEqualToString:JSONKEY_JSON] || [key isEqualToString:JSONKEY_JSON2])
            {
                contentType = @"application/json";
                flag = YES;
            }
            else if([key isEqualToString:JSONKEY_FILE] || [key isEqualToString:JSONKEY_THUMBNAIL] || [key isEqualToString:JSONKEY_COVER])
            {
                contentType = @"application/x-www-form-urlencoded";
                if([[dic objectForKey:key] isKindOfClass:[NSString class]])
                {
                    [dic setValue:[NSData dataWithBase64EncodedString:[dic valueForKey:key]] forKey:key];
                }
                flag = YES;
            }
            if(contentType)
            {
                NSData *value = [[dic objectForKey:key] isKindOfClass:[NSData class]] ?
                [dic objectForKey:key] :
                [[[dic objectForKey:key] JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
                [theRequest setData:value withFileName:nil andContentType:contentType forKey:key];
            }
        }
        //process single json
        if(!flag) [theRequest appendPostData:[[objectData JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [theRequest startSynchronous];
}



- (ASIFormDataRequest *)authenticatedRequestForURL:(NSURL *)url
{
	ASIFormDataRequest *theRequest = [ASIFormDataRequest requestWithURL:[self addVersionToURL:url]];
    [theRequest setAuthenticationScheme:(NSString *)kCFHTTPAuthenticationSchemeBasic];
	[theRequest setUsername:login];
	[theRequest setPassword:password];
    
    RCDebug(@"userid:%@  password:%@",login,password);
    [theRequest setValidatesSecureCertificate:NO];
    
	return theRequest;
}


#pragma mark add version to url
-(NSURL *)addVersionToURL:(NSURL *)url
{
    NSString *urlStr = [url absoluteString];
    if([urlStr containsString:@"?"])
        urlStr = [urlStr stringByAppendingFormat:@"&%@",Version_MARK];
    else
        urlStr = [urlStr stringByAppendingFormat:@"?%@",Version_MARK];
    return [NSURL URLWithString:urlStr];
}

-(NSString *)removeVersionFromURL:(ASIHTTPRequest *)theRequest
{
    NSString *url = [theRequest.url absoluteString];
    if([url containsString:Version_MARK])
        url = [url substringToIndex:[url length] - [Version_MARK length] - 1];
    return url;
}

#pragma mark resend
- (void)resendTaskByTaskId:(NSString *)taskId withRefreshType:(int)refreshType
{
#define UPDATE_STATUS @"update %@ set %@_status = %d where %@ = '%@'"
    id task = [taskDao search:[NSDictionary dictionaryWithObject:taskId forKey:TASK_ID] type:0 waitUntiDone:YES];
    NSString *tableName = [[task lastObject] valueForKey:TASK_TABLENAME];
    [taskDao update:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:uploadNotProcessed] forKey:TASK_STATUS] ByPrimeKeyValue:taskId type:kTaskMsgSaveTask waitUntilDone:NO];
    if([jobDao resetJobByTask:taskId])
    {
        NSString *sql = [NSString stringWithFormat:UPDATE_STATUS,tableName,tableName,RESOURCE_STATUS_UPLOADING,[BaseDAO getColumByTableName:tableName byId:0],taskId];
        [taskDao excute:sql type:refreshType waitUntilDone:NO];
    }
}




- (void)downloadWithURL:(NSURL *)url dstPath:(NSString *)dstPath withCallBack:(id)callback
{
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    __block int status = 0;
    if([callback valueForKey:KEY_JOB] == self.currentDownloadJob)
    {
        //获取当前job状态 如果不为read状态则不做此任务
        dispatch_sync(cancelQueue, ^{
            id job  = [[jobDao search:[callback valueForKey:KEY_JOB] type:0 waitUntiDone:YES] lastObject];
            status = [[job valueForKey:JOB_STATUS] intValue];
            if(status == jobIsReady || status == jobProcessing)
                self.currentDownloadReuqest = request;
            else
            {
                self.currentDownloadReuqest = nil;
                self.currentDownloadJob = nil;
            }
        });
        if(status == jobCancel || status == jobFinished)
        {
            [request release];
            return;
        }
    }
    NSString *filename = [[url absoluteString] md5Hash];
    filename = [[PersistentDirectory createTmpFilePath] stringByAppendingPathComponent:filename];
    request.delegate = self;
    request.downloadProgressDelegate = self;
    request.timeOutSeconds = 30;
    request.allowResumeForFileDownloads = YES;
    request.didFinishSelector = @selector(downloadFinished:);
    request.didFailSelector = @selector(downloadFailed:);
    request.downloadDestinationPath = dstPath;
    request.temporaryFileDownloadPath = filename;
    request.job = callback;
    [request startSynchronous];
    [request release];
}



#pragma mark ASIHTTPRequestDelegate methods
#define HTTP_CODE_SUCCESS       200
-(void)loadingFinished:(ASIHTTPRequest *)theRequest
{
    NSString *url = [self removeVersionFromURL:theRequest];
    [requestCancelDic removeObjectForKey:url];
    RCTrace(@"Loading %@ finished: %@ httpcode: %d", url, [theRequest responseString],[theRequest responseStatusCode]);
    if (HTTP_CODE_SUCCESS == theRequest.responseStatusCode) 
        [self parseData:[theRequest responseData] withURL:url withJob:[theRequest job]];
    else
    {
        [self updateTask:[[theRequest job] valueForKey:KEY_JOB] Status:uploadFailed];
        [self loadingFailedCallback:theRequest];
    }
    @synchronized (requestDic)
    {
        [requestDic removeObjectForKey:url];
    }
    
}


-(void)loadingFailed:(ASIHTTPRequest *)theRequest
{
    [requestCancelDic removeObjectForKey:[self removeVersionFromURL:theRequest]];
    RCDebug(@"requsetHandler %@ loading failed theRequest error:%@ httpcode: %d",self, theRequest.error, theRequest.responseStatusCode);
    [self updateTask:[[theRequest job] valueForKey:KEY_JOB] Status:uploadRetry];
    [self loadingFailedCallback:theRequest];
    @synchronized (requestDic)
    {
        [requestDic removeObjectForKey:[self removeVersionFromURL:theRequest]];
    }
}



-(void)downloadFinished:(ASIHTTPRequest *)theRequest
{
    RCDebug(@"download file successed!");
    [self updateTask:[[theRequest job] valueForKey:KEY_JOB] Status:uploadSuccessed];
    NSDictionary *task = [[theRequest job] valueForKey:KEY_TASK];
    NSDictionary *callback = [NSDictionary dictionaryWithObjectsAndKeys:task,KEY_TASK,
                                                        [self removeVersionFromURL:theRequest] ,KEY_URL_CALLBACK,
                                                        [theRequest downloadDestinationPath], KEY_DESTPATH ,nil];
    [Global sendMessageToControllers:[self getTaskType:task withUrl:[self removeVersionFromURL:theRequest]] withResult:0 withArg:callback];
}



-(void)downloadFailed:(ASIHTTPRequest *)theRequest
{
    RCDebug(@"download file failed!");
    NSDictionary *job = theRequest.job;
    NSDictionary *task = [job valueForKey:KEY_TASK];
    [self updateTask:[[theRequest job] valueForKey:KEY_JOB] Status:uploadRetry];
    [Global sendMessageToControllers:[self getTaskType:task withUrl:[self removeVersionFromURL:theRequest]] withResult:-1 withArg:job];
}




-(void)loadingFailedCallback:(ASIHTTPRequest *)theRequest
{
    NSDictionary *task = [[theRequest job] objectForKey:KEY_TASK];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:[self removeVersionFromURL:theRequest] forKey:KEY_URL_CALLBACK];
    [result setValue:theRequest.error forKey:KEY_REQUEST_ERROR];
    [result setValue:[NSNumber numberWithInt:theRequest.responseStatusCode] forKey:KEY_HTTP_ERROR_CODE];
    [result setValue:task forKey:KEY_TASK];
    [Global sendMessageToControllers:[self getTaskType:task withUrl:[self removeVersionFromURL:theRequest]] withResult:[SERVER_REQUEST_FAILED intValue] withArg:result];
}


- (void)parseData:(NSData *)theData withURL:(NSString*) url withJob:(id)job
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSError *parseError = nil;
    id jsonToObject = [[CJSONDeserializer deserializer] deserialize:theData error:&parseError];
    id res = parseError ? (id)parseError : (id)jsonToObject;
    [self parsingFinished:res withURL:url withJob:job];
    [pool release];
}



- (void)parsingFinished:(id)theResult  withURL:(NSString*) url withJob:(id)job
{    
    RCDebug(@"theResult:%@ URL:%@",theResult,url);
    int status = -1;
    if ([theResult isKindOfClass:[NSError class]]) 
        RCDebug(@"JSON parsing failed: %@", theResult);
    else
    {
        if ([theResult isKindOfClass:[NSDictionary class]])
        {
            NSString *statusTemp = [theResult objectForKey:SERVER_STATUS];
            if(statusTemp && ![statusTemp isEqualToString:@""])
                status = [statusTemp intValue];
            if (![statusTemp isEqualToString:SERVER_REQUEST_SUCCESS ]) 
                [self updateTask:[job valueForKey:KEY_JOB] Status:uploadFailed];
            else
            {
                id callback = [job valueForKey:KEY_CALLBACK];
                //get file id from result
                //#define KEY_CALLBACK_URL    @"key_callback_url"
                //#define KEY_CALLBACK_SUBURL @"key_callback_sub_url"
                NSString *fileId  = [[[[theResult valueForKey:KEY_OUT_SYNCFILE] valueForKey:KEY_IN_SYNCFILE] lastObject] valueForKey:KEY_SYNCFILE_ID];
                NSString *url = [[[[theResult valueForKey:KEY_OUT_SYNCFILE] valueForKey:KEY_IN_SYNCFILE] lastObject] valueForKey:KEY_SYNCFILE_URL];
                NSString *subUrl = [[[[theResult valueForKey:KEY_OUT_SYNCFILE] valueForKey:KEY_IN_SYNCFILE] lastObject] valueForKey:KEY_SYNCFILE_SUBURL];
                NSString *type = [[[[theResult valueForKey:KEY_OUT_SYNCFILE] valueForKey:KEY_IN_SYNCFILE] lastObject] valueForKey:KEY_SYNCFILE_TYPE];
                [callback setValue:fileId forKey:KEY_CALLBACK_FILEID];
                [callback setValue:SERVER_REQUEST_SUCCESS forKey:KEY_CALLBACK_STATUS];
                [callback setValue:url forKey:KEY_CALLBACK_URL];
                [callback setValue:subUrl forKey:KEY_CALLBACK_SUBURL];
                [callback setValue:type forKey:KEY_CALLBACK_FILE_TYPE];
                
            }
        }
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:theResult];
        NSDictionary *task = [job objectForKey:KEY_TASK];
        [result setValue:task forKey:KEY_TASK];
        [result setValue:url forKey:KEY_URL_CALLBACK];
        if(status != 0 || [[[job valueForKey:KEY_JOB] valueForKey:JOB_IS_MAIN] boolValue] || !job)
            [Global sendMessageToControllers:[self getTaskType:task withUrl:url] withResult:status withArg:result];
    }
    
}

- (int)getTaskType:(NSDictionary *)task withUrl:(NSString*)url
{
    int messagetype = -1;
    id type = [task valueForKeyPath:TASK_TYPE];
    if([type isKindOfClass:[NSNumber class]])
        messagetype = [type intValue];
    else
    {
        @synchronized (requestDic)
        {
            messagetype = [[requestDic valueForKey:url] intValue];
        }
    }
    return messagetype;
}

- (void)updateTask:(NSDictionary *)job Status:(int)type
{
    if(!job || ![job count]) return;
    [taskDao updateType:type byId:[job valueForKey:JOB_TASK_ID]];
    if(type == uploadRetry)
        [jobDao updateStatus:jobIsReady byId:[[job valueForKey:JOB_ID] intValue]];
}


-(void)uploadAttachmentComplete:(id)jobDic
{
    NSDictionary *callBack = [jobDic valueForKey:KEY_CALLBACK];
    if([[callBack valueForKey:KEY_CALLBACK_STATUS] isEqualToString:SERVER_REQUEST_SUCCESS])
    {
        NSString *fileId = [callBack valueForKey:KEY_CALLBACK_FILEID];
        NSString *taskId = [[jobDic valueForKey:KEY_JOB] valueForKey:JOB_TASK_ID];
        if(!fileId || [fileId isEqualToString:@""])
            return;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [Global sendMessageSync:kTaskMsgCreateFileLink withArg:jobDic];
        });
        [jobDao updateMainJobJson:fileId withTaskId:taskId];
        [jobDao updateJobDependency:taskId];
        NSNotification *notify = [NSNotification notificationWithName:INVOKE_UPLOADMODULE object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:uploadProcessing],TASK_STATUS,nil]];
        [self invoke:notify];
    }
}

-(void)mainJobComplete:(id)jobDic
{
    NSDictionary *callBack = [jobDic valueForKey:KEY_CALLBACK];
    if([[callBack valueForKey:KEY_CALLBACK_STATUS] isEqualToString:SERVER_REQUEST_SUCCESS])
    {
        [self updateTask:[jobDic valueForKey:KEY_JOB] Status:uploadSuccessed];
    }

}




@end
