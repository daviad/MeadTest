//
//  UpLoadResourceConstants.h
//  LoochaUtilities
//
//  Created by hh k on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef LoochaUtilities_UpLoadResourceConstants_h
#define LoochaUtilities_UpLoadResourceConstants_h

#define RESOURCE_TYPE_BASE              0x1000
#define RESOURCE_TYPE_FILE              RESOURCE_TYPE_BASE + 1
#define RESOURCE_TYPE_PESONAL_MESSAGE   RESOURCE_TYPE_BASE + 2
#define RESOURCE_TYPE_SPACE_MESSAGE     RESOURCE_TYPE_BASE + 3




#pragma mark upload module
#define COMMAND_UPLOAD      @"upload"
#define COMMAND_DELETE      @"delete"
#define COMMAND_COPY        @"copy"
#define COMMAND_DOWNLOAD    @"download"


#define METHOD_POST @"POST"
#define METHOD_GET  @"GET"
#define METHOD_PUT  @"PUT"
#define METHOD_DELETE @"DELETE"
#define METHOD_DOWNLOAD     @"DOWNLOAD"


#define MARK_ITEMID         @"[%s]"
#define MARK_FILE_DATA      @"[%fd]"
#define MARK_THUMBNAIL_DATA @"[%td]"

#define UPLOAD_STATUS_BASE 1000
typedef enum {
    uploadNotProcessed = UPLOAD_STATUS_BASE,
    uploadProcessing,
    uploadSuccessed,
    uploadRetry,
    uploadFailed
}UploadStatus;


#define JOB_STATUS_BASE 1500
typedef enum {
    jobIsReady = JOB_STATUS_BASE,
    jobProcessing,
    jobFinished,
    jobCancel,
    jobMax
}JobStatus;

#define INVOKE_UPLOADMODULE     @"InvokeUploadModule"

#define KEY_URL_CALLBACK        @"RcUploadModule_url"
#define KEY_REQUEST_ERROR       @"RcUploadModule_netWorkError"
#define KEY_HTTP_ERROR_CODE     @"RcUploadModule_httpcode"
#define KEY_DESTPATH            @"RcUploadModule_dstpath"



#define KEY_JOB @"key_job"
#define KEY_CALLBACK @"key_callback"
#define KEY_TASK     @"key_task"
#define KEY_CALLBACK_STATUS @"key_callback_status"
#define KEY_CALLBACK_FILEID @"key_callback_fileId"
#define KEY_CALLBACK_URL    @"key_callback_url"
#define KEY_CALLBACK_SUBURL @"key_callback_sub_url"
#define KEY_CALLBACK_FILE_TYPE @"key_callback_file_type"

#define KEY_OUT_SYNCFILE    @"syncfiles"
#define KEY_IN_SYNCFILE     @"syncFiles"
#define KEY_SYNCFILE_ID     @"file_id"
#define KEY_SYNCFILE_URL    @"uri"
#define KEY_SYNCFILE_SUBURL @"sub_uri"
#define KEY_SYNCFILE_TYPE   @"type"


#define SERVER_STATUS               @"status"
#define SERVER_REQUEST_SUCCESS      @"0"
#define SERVER_REQUEST_FAILED       @"-1"


#define HEADER_SINGER   @"application/json"
#define HEADER_MULTI    @"multipart/form-data"


#endif
