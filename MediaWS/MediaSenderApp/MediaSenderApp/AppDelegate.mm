//
//  AppDelegate.m
//  MediaSenderApp
//
//  Created by ding xiuwei on 13-3-22.
//  Copyright (c) 2013年 ding xiuwei. All rights reserved.
//

#import "AppDelegate.h"

#ifdef __cplusplus
extern "C"
{
#endif
#import "libavformat/avformat.h"
#import "libavcodec/avcodec.h"
#import "libavutil/avutil.h"
#import "libswscale/swscale.h"
#ifdef __cplusplus
}
#endif



#include "rtpsession.h"
#include "rtpudpv4transmitter.h"
#include "rtpipv4address.h"
#include "rtpsessionparams.h"
#include "rtperrors.h"
#ifndef WIN32
#include <netinet/in.h>
#include <arpa/inet.h>
#else
#include <winsock2.h>
#endif // WIN32
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <string>

//


#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMedia/CoreMedia.h>
#include <malloc/malloc.h>

using namespace std;
using namespace jrtplib;





@interface AppDelegate()
{
    RTPSession sess;
    
    
    AVCodecContext *codecContext;
    
    dispatch_queue_t  sendQueue;
    
    
     AVCodecContext     *pCodecCtx;
    
    
    AVCodec            *pCodecRec;
    AVPacket           packetRec;
    AVCodecContext     *pCodecCtxRec;
    AVFrame            *pFrameRec;
    AVPicture          pictureRec;
    struct SwsContext  *img_convert_ctxRec;
    
     UIImageView *imgView;
}

@end

@implementation AppDelegate
@synthesize captureSession;




-(void)updateView:(UIImage*)img
{
    imgView.image = img;
}




#pragma mark - ffmpeg functions


-(void)initRecvFFMPEG
{
    // Register all formats and codecs
    //avcodec_init();
    av_register_all();
    av_init_packet(&packetRec);
    // Find the decoder for the 264
    pCodecRec=avcodec_find_decoder(CODEC_ID_H264);
    if(pCodecRec==NULL)
        goto initError; // Codec not found
    
    pCodecCtxRec = avcodec_alloc_context3(pCodecRec);
    // Open codec
    if(avcodec_open2(pCodecCtxRec, pCodecRec,NULL) < 0)
        goto initError; // Could not open codec
    // Allocate video frame
    
    pFrameRec=avcodec_alloc_frame();
    
    //    pCodecCtx->width = 640;
    //    pCodecCtx->height = 480;
    //    pCodecCtx->pix_fmt = PIX_FMT_YUV420P;
    NSLog(@"init success");
    return;
    
initError:
    //error action
    NSLog(@"init failed");
    return ;
}

-(void)releaseRecvFFMPEG
{
    // Free scaler
    sws_freeContext(img_convert_ctxRec);
    
    // Free RGB picture
    avpicture_free(&pictureRec);
    
    // Free the YUV frame
    av_free(pFrameRec);
    
    // Close the codec
    if (pCodecCtxRec) avcodec_close(pCodecCtxRec);
}

-(void)setupRecvScaler {
    
    // Release old picture and scaler
    avpicture_free(&pictureRec);
    sws_freeContext(img_convert_ctxRec);
    
    // Allocate RGB picture
    avpicture_alloc(&pictureRec, PIX_FMT_RGB24,pCodecCtxRec->width,pCodecCtxRec->height);
    
    // Setup scaler
    static int sws_flags =  SWS_FAST_BILINEAR;
    img_convert_ctxRec = sws_getContext(pCodecCtxRec->width,
                                     pCodecCtxRec->height,
                                     pCodecCtxRec->pix_fmt,
                                     pCodecCtxRec->width,
                                     pCodecCtxRec->height,
                                     PIX_FMT_RGB24,
                                     sws_flags, NULL, NULL, NULL);
    
}

-(void)convertFrameToRGB
{    [self setupRecvScaler];
    sws_scale (img_convert_ctxRec,pFrameRec->data, pFrameRec->linesize,
               0, pCodecCtxRec->height,
               pictureRec.data, pictureRec.linesize);
}

-(void)decodeAndShow : (char*) buf length:(int)len andTimeStamp:(unsigned long)ulTime
{
    //    if (m_bPlayStop == YES)
    //    {
    //        return;
    //    }
    //0407 add for ffmpeg decode
    packetRec.size = len;
    packetRec.data = (unsigned char *)buf;
    int got_picture_ptr=0;
    int nImageSize;
    nImageSize = avcodec_decode_video2(pCodecCtxRec,pFrameRec,&got_picture_ptr,&packetRec);
    NSLog(@"nImageSize:%d--got_picture_ptr:%d",nImageSize,got_picture_ptr);
    
    if (nImageSize > 0)
    {
        if (pFrameRec->data[0])
        {
            [self convertFrameToRGB];
            int  nWidth = pCodecCtxRec->width;
            int  nHeight = pCodecCtxRec->height;
            CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
            CFDataRef data = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, pictureRec.data[0], nWidth*nHeight*3,kCFAllocatorNull);
            CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            
            CGImageRef cgImage = CGImageCreate(nWidth,
                                               nHeight,
                                               8,
                                               24,
                                               nWidth*3,
                                               colorSpace,
                                               bitmapInfo,
                                               provider,
                                               NULL,
                                               YES,
                                               kCGRenderingIntentDefault);
            CGColorSpaceRelease(colorSpace);
            //UIImage *image = [UIImage imageWithCGImage:cgImage];
            UIImage* image = [[UIImage alloc]initWithCGImage:cgImage];   //crespo modify 20111020
            CGImageRelease(cgImage);
            CGDataProviderRelease(provider);
            CFRelease(data);
            //  [self timeIntervalControl:ulTime]; //add 0228
            [self performSelectorOnMainThread:@selector(updateView:) withObject:image waitUntilDone:YES];
            [image release];
        }
    }
    // m_decodeFinish = YES;
    return;
}



-(void)xx
{
    AVCodec  *pCodec;
    AVFormatContext *pFormaterCtx;
    AVCodecContext *pCodecCtx;
    AVFrame *pFrame;
    int videoStream;
    
    NSString *moviePath = @"http://livecdn.cdbs.com.cn/fmvideo.flv";
    
    pFormaterCtx = avformat_alloc_context();
    
    avcodec_register_all();
    av_register_all();
    
    
    avformat_network_init();
    
    
    //open video file
    if (avformat_open_input(&pFormaterCtx, [moviePath cStringUsingEncoding:NSASCIIStringEncoding], NULL, NULL)) {
        av_log(NULL, AV_LOG_ERROR, "Could not open file \n");
        
    }
    
    
    
    //Retrieve stream information
    if (avformat_find_stream_info(pFormaterCtx, NULL)<0) {
        av_log(NULL, AV_LOG_ERROR, "could find a video information \n");
    }
    
    
    
    //fine the best video stream
    if ((videoStream = av_find_best_stream(pFormaterCtx, AVMEDIA_TYPE_VIDEO, -1, -1, &pCodec, 0)<0))
    {
        av_log(NULL, AV_LOG_ERROR, "Cannot find a video stream in the input file\n");
        
    }
    
//    检查视频流的信息，通过调用av_find_stream_info（pFormatCtx）函数，pFormatCtx-》streams 就填充了正确的视频流信息，pFormatCtx 类型是AVFormatContext.
//    
//    （4） 得到编解码器上下文，pCodecCtx= pFormatCtx -》 streams［videoStream］-》codec，pCodecCtx 指针指向了流中所使用的关于编解码器的所有信息。

    //get a pointer to the codec contenxt for the video stream
    pCodecCtx = pFormaterCtx ->streams[videoStream] ->codec;
    
    
    
    //find the decoder for the video stream
    pCodec = avcodec_find_decoder(pCodecCtx ->codec_id);
    if (pCodec == NULL) {
        av_log(NULL, AV_LOG_ERROR, "Unsupported codec!\n");
        
    }
    
    
    printf("%s",pCodec->name);
    
    
    //open codec
    if (avcodec_open2(pCodecCtx, pCodec, NULL)<0) {
        av_log(NULL, AV_LOG_ERROR, "Cannot open video decoder\n");
        
    }
    
    
    printf("%s",pCodec->name);
    
    //allocate video frame
    pFrame = avcodec_alloc_frame();
    
    
    
    /* find the mpeg video encoder */
    AVCodec *codec =avcodec_find_encoder(CODEC_ID_H264);//avcodec_find_encoder_by_name("libx264"); //avcodec_find_encoder(CODEC_ID_H264);//CODEC_ID_H264);
    NSLog(@"codec = %i",codec);
    if (!codec) {
        fprintf(stderr, "codec not found\n");
        exit(1);
    }
    
    
}




void checkerror(int err)

{  if (err < 0)
    
{
    
    
    cout << "ERROR: " << RTPGetErrorString(err) << std::endl;
    
    
    exit(-1);
    
}
    
}




- (void)dealloc
{
    
    avcodec_close(codecContext);
    av_free(codecContext);
    dispatch_release(sendQueue);
    [_window release];
    [super dealloc];
}


-(void)startSeeion
{
    [self.captureSession startRunning];
    NSLog(@"startSeeion");
}
-(void)stopSeeion
{
    
    
    [self.captureSession stopRunning];
    NSLog(@"stop seeion");
    
    
    [assetWriter finishWriting];
    
    
}

-(void)setUpSession
{
    self.captureSession = [[[AVCaptureSession alloc] init] autorelease];
    if([captureSession canSetSessionPreset:AVCaptureSessionPresetMedium])
    {
        //  captureSession.sessionPreset =  AVCaptureSessionPresetMedium;
    }
    //     session.sessionPreset = AVCaptureSessionPreset640x480;
    
    
}

-(void)setUpPreviewLayer
{
    //宣告一個AVCaptureVideoPreviewLayer的指標，用來存放session要輸出的東西（Camera中的畫面）
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    
    //設定輸出畫面的邊界大小
    previewLayer.frame = CGRectMake(10, 100, 300, 372);
    previewLayer.backgroundColor = [UIColor cyanColor].CGColor;
    //將輸出的東西透過preview秀出來，preview為UIImageView型態
    [self.window.layer addSublayer:previewLayer];
}
-(void)setUpVideoInput
{
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (captureDeviceInput)
    {
        if ([captureSession canAddInput:captureDeviceInput])
        {
            [captureSession addInput:captureDeviceInput];
        }
        else
        {
            //TODO:
            NSLog(@"not compatible");
        }
        
        
        
    }
    else
    {
        NSLog(@"%@",error);
    }
    
}

-(void)setUpAudioInput
{
    NSError *error;
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput * audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    if (audioDevice)
    {
        if ([captureSession canAddInput:audioInput])
        {
            [captureSession addInput:audioInput];
        }
        else
        {
            //TODO:
            NSLog(@"not compatible");
        }
        
        
        
    }
    else
    {
        NSLog(@"%@",error);
    }
    
    
    
    
}


-(void)setAudioSessionCategory:(NSString *)category
{
    NSError *setCategoryError = nil;
    category =AVAudioSessionCategoryPlayAndRecord;
    [[AVAudioSession sharedInstance] setCategory: category error: &setCategoryError];
    
    if (setCategoryError)
    { NSLog(@"%@",[setCategoryError description]); }
    
    OSStatus propertySetError = 0;
    UInt32 allowMixing = true;
    propertySetError = AudioSessionSetProperty ( kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (allowMixing), &allowMixing);
    
    if (setCategoryError)
    { NSLog(@"%@",[setCategoryError description]); }
}





-(void)setUpFileOutput
{
    AVCaptureMovieFileOutput *aMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([captureSession canAddOutput:aMovieFileOutput])
    {
        [captureSession addOutput:aMovieFileOutput];
    }
    else
    {
        // Handle the failure.
    }
    
    //    CMTime maxDuration = <#Create a CMTime to represent the maximum duration#>;
    //    aMovieFileOutput.maxRecordedDuration = maxDuration;
    //    aMovieFileOutput.minFreeDiskSpaceLimit = <#An appropriate minimum given the quality of the movie format and the duration#>;
    //
    
    //    aMovieFileOutput. =
    //    @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    //    aMovieFileOutput.minFrameDuration = CMTimeMake(1, 15);
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"xx.mov"];
    
    
    
    NSURL *fileURL1 =[[NSURL alloc] initWithString:path];// <#A file URL that identifies the output location#>;
    NSLog(@"file1:%@",fileURL1);
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:path];
    NSLog(@"file:%@",fileURL);
    
    
    
    
    
    [self startSeeion];
    
    [aMovieFileOutput startRecordingToOutputFileURL:fileURL recordingDelegate:self];
    
    
}



//Processing Frames of Video
-(void)setUpFrameDataOutput
{
    
    //video
    AVCaptureVideoDataOutput *videoOut = [[AVCaptureVideoDataOutput alloc]
                                          init];
    videoOut.alwaysDiscardsLateVideoFrames = YES;
    
  
    sendQueue = dispatch_queue_create("frameDataOutputQueue", NULL);
    [videoOut setSampleBufferDelegate:self queue:sendQueue];
    
    
    
    [self.captureSession addOutput:videoOut];
	videoConnection = [videoOut connectionWithMediaType:AVMediaTypeVideo];
    [videoOut release];
    
    
}












-(void)setUpAVcodecContext
{
    av_register_all();
    
    
    //avcodec_init();
    //avdevice_register_all();
    
    
    AVCodec *codec =NULL;
    AVCodecContext *c= NULL;
    
    
    printf("config video codec context \n");
    
    /* find the mpeg video encoder */
    codec =avcodec_find_encoder(CODEC_ID_H264);//avcodec_find_encoder_by_name("libx264"); //avcodec_find_encoder(CODEC_ID_H264);//CODEC_ID_H264);
    NSLog(@"codec = %i",codec);
    if (!codec) {
        fprintf(stderr, "codec not found\n");
        exit(1);
    }
    
    c = avcodec_alloc_context3(codec);
    
    /* put sample parameters */
    c->bit_rate = 400000;
    c->bit_rate_tolerance = 10;
    c->me_method = 8;//2;
    /* resolution must be a multiple of two */
    c->width = 352;//width;//352;
    c->height = 288;//height;//288;
    /* frames per second */
    c->time_base= (AVRational){1,25};
    c->gop_size = 10;//25; /* emit one intra frame every ten frames */
    c->max_b_frames=1;
    c->pix_fmt = PIX_FMT_YUV420P;
    
    c ->me_range = 16;
    c ->max_qdiff = 4;
    c ->qmin = 10;
    c ->qmax = 51;
    c ->qcompress = 0.6f;
    
    /* open it */
    // avcodec_open(c, codec)
    if ( avcodec_open2(c, codec, NULL) < 0) {
        fprintf(stderr, "could not open codec\n");
        exit(1);
    }
    
    codecContext = c;
    
    
    
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    
    if(codecContext == NULL)
    {
        NSLog(@"codecContext is NULL retun");
        return;
    }
    
    //  UIImage* image = [UIImage imageNamed:@"DownAccessory"];
    //    imageToBuffer(sampleBuffer);
    //        NSData  *imageData =[@"123" dataUsingEncoding:NSUTF8StringEncoding];  // UIImagePNGRepresentation(image);
    //        NSData *data = imageData;
    //        sess.SendPacket([data bytes], data.length);
    //        NSLog(@"sender data:%d",data.length); //336
    
    
    
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    
    NSLog(@"data from cameral:%@",sampleBuffer);
    
    
    // access the data
    int width = CVPixelBufferGetWidth(pixelBuffer);
    int height = CVPixelBufferGetHeight(pixelBuffer);
    unsigned char *rawPixelBase = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
    
    AVFrame *pFrame;
    pFrame = avcodec_alloc_frame();
    pFrame->quality = 0;
    
    NSLog(@"pFrame = avcodec_alloc_frame(); ");
    
    
    int avpicture_fillNum = avpicture_fill((AVPicture*)pFrame, rawPixelBase, PIX_FMT_RGB24, width, height);//PIX_FMT_RGB32//PIX_FMT_RGB8
    NSLog(@"rawPixelBase = %i , rawPixelBase -s = %s",rawPixelBase, rawPixelBase);
    NSLog(@"avpicture_fill = %i",avpicture_fillNum);
    NSLog(@"width = %i,height = %i",width, height);
    
    
    
    // Do something with the raw pixels here
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    
    
    int  out_size, size, outbuf_size;
    
    uint8_t *outbuf;
    
    printf("Video encoding  per frame \n");
    
    /* alloc image and output buffer */
    outbuf_size = 100000;
    outbuf = (uint8_t *) malloc(outbuf_size);
    
    size = codecContext->width * codecContext->height;
    
    AVFrame* outpic = avcodec_alloc_frame();
    int nbytes = avpicture_get_size(PIX_FMT_YUV420P, codecContext->width, codecContext->height);
    
    //create buffer for the output image
    uint8_t* outbuffer = (uint8_t*)av_malloc(nbytes);
    
#pragma mark -
    
    fflush(stdout);
    
    
    avpicture_fill((AVPicture*)outpic, outbuffer, PIX_FMT_YUV420P, codecContext->width, codecContext->height);
    
    struct SwsContext* fooContext = sws_getContext(codecContext->width, codecContext->height,
                                                   PIX_FMT_RGB8,
                                                   codecContext->width, codecContext->height,
                                                   PIX_FMT_YUV420P,
                                                   SWS_FAST_BILINEAR, NULL, NULL, NULL);
    
    //perform the conversion
    sws_scale(fooContext, pFrame->data, pFrame->linesize, 0, codecContext->height, outpic->data, outpic->linesize);
    // Here is where I try to convert to YUV
    
    /* encode the image */
    
   // out_size = avcodec_encode_video(codecContext, outbuf, outbuf_size, outpic);
    out_size = avcodec_encode_video(codecContext, outbuf, outbuf_size, pFrame);

    printf("encoding frame (size=%5d)\n", out_size);
    printf("encoding frame %s\n", outbuf);
    
 //   NSArray * paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   // NSString *doc = [paths objectAtIndex:0];
//    static int i = 0;
    if (out_size>800)
    {
      sess.SendPacket(outbuf, out_size);
       
        
//        NSData *data = [NSData dataWithBytes:outbuf length:out_size];
//        [data writeToFile:[doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg",i]] atomically:YES];
//        i++;
        
        
        [self decodeAndShow:(char*)outbuf length:out_size andTimeStamp:111111];
        
    }
    
   // free(outbuf);
    
    
    av_free(pFrame);
    printf("\n");
    
}
















//Here is code to get at the buffer. This code assumes a flat image (e.g. BGRA).
NSData* imageToBuffer( CMSampleBufferRef source)
{
    
    
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(source);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    // access the data
    int width = CVPixelBufferGetWidth(pixelBuffer);
    int height = CVPixelBufferGetHeight(pixelBuffer);
    unsigned char *rawPixelBase = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
    
    AVFrame *pFrame;
    pFrame = avcodec_alloc_frame();
    pFrame->quality = 0;
    
    NSLog(@"pFrame = avcodec_alloc_frame(); ");
    
    
    int avpicture_fillNum = avpicture_fill((AVPicture*)pFrame, rawPixelBase, PIX_FMT_RGB32, width, height);//PIX_FMT_RGB32//PIX_FMT_RGB8
    NSLog(@"rawPixelBase = %i , rawPixelBase -s = %s",rawPixelBase, rawPixelBase);
    NSLog(@"avpicture_fill = %i",avpicture_fillNum);
    NSLog(@"width = %i,height = %i",width, height);
    
    
    
    // Do something with the raw pixels here
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    //avcodec_init();
    //avdevice_register_all();
    av_register_all();
    
    
    
    
    
    AVCodec *codec;
    AVCodecContext *c= NULL;
    int  out_size, size, outbuf_size;
    //FILE *f;
    uint8_t *outbuf;
    
    printf("Video encoding\n");
    
    /* find the mpeg video encoder */
    codec =avcodec_find_encoder(CODEC_ID_H264);//avcodec_find_encoder_by_name("libx264"); //avcodec_find_encoder(CODEC_ID_H264);//CODEC_ID_H264);
    NSLog(@"codec = %i",codec);
    if (!codec) {
        fprintf(stderr, "codec not found\n");
        // exit(1);
    }
    
    c = avcodec_alloc_context3(codec);
    //  c= avcodec_alloc_context();      ?
    
    /* put sample parameters */
    c->bit_rate = 400000;
    c->bit_rate_tolerance = 10;
    c->me_method = 2;
    /* resolution must be a multiple of two */
    c->width = 300;//width;//352;
    c->height = 288;//height;//288;
    /* frames per second */
    c->time_base= (AVRational){1,25};
    c->gop_size = 10;//25; /* emit one intra frame every ten frames */
    //c->max_b_frames=1;
    c->pix_fmt = PIX_FMT_YUV420P;
    
    c ->me_range = 16;
    c ->max_qdiff = 4;
    c ->qmin = 10;
    c ->qmax = 51;
    c ->qcompress = 0.6f;
    
    /* open it */
    // avcodec_open(c, codec)
    if ( avcodec_open2(c, codec, NULL) < 0) {
        fprintf(stderr, "could not open codec\n");
        exit(1);
    }
    
    
    /* alloc image and output buffer */
    outbuf_size = 100000;
    outbuf = (uint8_t *) malloc(outbuf_size);
    
    size = c->width * c->height;
    
    AVFrame* outpic = avcodec_alloc_frame();
    int nbytes = avpicture_get_size(PIX_FMT_YUV420P, c->width, c->height);
    
    //create buffer for the output image
    uint8_t* outbuffer = (uint8_t*)av_malloc(nbytes);
    
#pragma mark -
    
    fflush(stdout);
    
    //         int numBytes = avpicture_get_size(PIX_FMT_YUV420P, c->width, c->height);
    //          uint8_t *buffer = (uint8_t *)av_malloc(numBytes*sizeof(uint8_t));
    //
    //          //UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"10%d", i]];
    //          CGImageRef newCgImage = [self imageFromSampleBuffer:sampleBuffer];//[image CGImage];
    //
    //          CGDataProviderRef dataProvider = CGImageGetDataProvider(newCgImage);
    //          CFDataRef bitmapData = CGDataProviderCopyData(dataProvider);
    //          buffer = (uint8_t *)CFDataGetBytePtr(bitmapData);
    //
    //          avpicture_fill((AVPicture*)pFrame, buffer, PIX_FMT_RGB8, c->width, c->height);
    avpicture_fill((AVPicture*)outpic, outbuffer, PIX_FMT_YUV420P, c->width, c->height);
    
    struct SwsContext* fooContext = sws_getContext(c->width, c->height,
                                                   PIX_FMT_RGB8,
                                                   c->width, c->height,
                                                   PIX_FMT_YUV420P,
                                                   SWS_FAST_BILINEAR, NULL, NULL, NULL);
    
    //perform the conversion
    sws_scale(fooContext, pFrame->data, pFrame->linesize, 0, c->height, outpic->data, outpic->linesize);
    // Here is where I try to convert to YUV
    
    /* encode the image */
    
    out_size = avcodec_encode_video(c, outbuf, outbuf_size, outpic);
    
    if(out_size> 100)
    {
        
    }
    printf("encoding frame (size=%5d)\n", out_size);
    
    printf("encoding frame %d\n", outbuf);
    
    //fwrite(outbuf, 1, out_size, f);
    
    //              free(buffer);
    //              buffer = NULL;
    
    
    
    /* add sequence end code to have a real mpeg file */
    //          outbuf[0] = 0x00;
    //          outbuf[1] = 0x00;
    //          outbuf[2] = 0x01;
    //          outbuf[3] = 0xb7;
    //fwrite(outbuf, 1, 4, f);
    //fclose(f);
    free(outbuf);
    
    avcodec_close(c);
    av_free(c);
    av_free(pFrame);
    printf("\n");
    
    
    
}
//A more efficient approach would be to use a NSMutableData or a buffer pool.
//Sending a 480x360 image every second will require a 4.1Mbps connection assuming 3 color channels.


#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    BOOL recordedSuccessfully = YES;
    NSLog(@"%@",error);
    if ([error code] != noErr)
    {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value) {
            recordedSuccessfully = [value boolValue];
        }
        
        
        // The disk is full—AVErrorDiskFull.
        //The recording device was disconnected (for example, the microphone was removed from an iPod touch)—AVErrorDeviceWasDisconnected.
        // The session was interrupted (for example, a phone call was received)—AVErrorSessionWasInterrupted.
    }
    
    
    // //Adding Metadata to a File
    //    NSArray *existingMetadataArray = ((AVCaptureMovieFileOutput*)captureOutput).metadata;
    //    NSMutableArray *newMetadataArray = nil;
    //    if (existingMetadataArray)
    //    {
    //        newMetadataArray = [existingMetadataArray mutableCopy];
    //    }
    //    else
    //    {
    //        newMetadataArray = [[NSMutableArray alloc] init];
    //    }
    //
    //    AVMutableMetadataItem *item = [[AVMutableMetadataItem alloc] init];
    //    item.keySpace = AVMetadataKeySpaceCommon;
    //    item.key = AVMetadataCommonKeyLocation;
    //
    //    CLLocation *location=nil;// - <#The location to set#>;
    //    item.value = [NSString stringWithFormat:@"%+08.4lf%+09.4lf/"
    //                  location.coordinate.latitude, location.coordinate.longitude];
    //
    //    [newMetadataArray addObject:item];
    //
    //    aMovieFileOutput.metadata = newMetadataArray;
    
}





-(void)setUprtpSession
{
    uint16_t portbase = 6001;
    uint16_t destport = 6333;
	uint32_t destip;
	std::string ipstr = "192.168.0.183";
    
	int status;;
    
    
    
    // 获得接收端的IP地址和端口号
    destip = inet_addr(ipstr.c_str());
    if (destip == INADDR_NONE)
        
    {    printf("Bad IP address specified.//n");
        
        return ;
        
    }
    
    destip = ntohl(destip);
    //destport = atoi(destport);
    
    
    // 创建RTP会话
    RTPUDPv4TransmissionParams transparams;
	RTPSessionParams sessparams;
	
	// IMPORTANT: The local timestamp unit MUST be set, otherwise
	//            RTCP Sender Report info will be calculated wrong
	// In this case, we'll be sending 10 samples each second, so we'll
	// put the timestamp unit to (1.0/10.0)
	sessparams.SetOwnTimestampUnit(1.0/2.0);
	
	sessparams.SetAcceptOwnPackets(true);
	transparams.SetPortbase(portbase);
	status = sess.Create(sessparams,&transparams);
    checkerror(status);
    
    
    // 指定RTP数据接收端
    RTPIPv4Address addr(destip,destport);
    status = sess.AddDestination(addr);
    checkerror(status);
    
    // 设置RTP会话默认参数
    sess.SetDefaultPayloadType(0);
    sess.SetDefaultMark(false);
    sess.SetDefaultTimestampIncrement(2);
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    
    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0,0,100,90);
    btn.backgroundColor = [UIColor redColor];
    [self.window addSubview:btn];
    [btn addTarget:self action:@selector(startSeeion) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn1 = [[UIButton alloc] init];
    btn1.frame = CGRectMake(250,0,100,90);
    btn1.backgroundColor = [UIColor greenColor];
    [self.window addSubview:btn1];
    [btn1 addTarget:self action:@selector(stopSeeion) forControlEvents:UIControlEventTouchUpInside];
    
    
    

    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    
    //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    //  [fileManager createFileAtPath:@"xx.mov" contents:nil attributes:nil];
    
    //删除待删除的文件
    [fileManager removeItemAtPath:@"xx.mov" error:nil];
    
    
    // [self setUpWriter];
    [self setUpSession];
    [self setUpPreviewLayer];
    
    [self setUpVideoInput];
    [self setUpFrameDataOutput];
    [self startSeeion];
    [self setUprtpSession];
    
    
    
    [self setUpAVcodecContext];
    [self initRecvFFMPEG];
    
    
    
    
    
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,30,300,280)];
    imgView.backgroundColor = [UIColor greenColor];
    [self.window addSubview:imgView];
    
    
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
