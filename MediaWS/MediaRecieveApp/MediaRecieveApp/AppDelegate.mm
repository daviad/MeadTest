//
//  AppDelegate.m
//  Mediareceiver
//
//  Created by ding xiuwei on 13-1-22.
//  Copyright (c) 2013年 ding xiuwei. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <string>
#include <iostream>
#include "rtpsession.h"
#include "rtpudpv4transmitter.h"
#include "rtpipv4address.h"
#include "rtpsessionparams.h"
#include "rtperrors.h"
#include "rtppacket.h"


#ifndef WIN32
#include <netinet/in.h>
#include <arpa/inet.h>
#else
#include <winsock2.h>
#endif // WIN32
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#include <malloc/malloc.h>



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




using namespace jrtplib;

@interface AppDelegate()
{
    RTPSession sess;
    
    dispatch_queue_t recieveQueue;
    
    AVCodecContext *pCodecCtx;
    
    
    
    AVCodec            *pCodec;
    AVPacket           packet;

    AVFrame            *pFrame;
    AVPicture          picture;
    struct SwsContext  *img_convert_ctx;
    
    
    UIImageView *imgView;
}

@end

@implementation AppDelegate



#pragma mark - ffmpeg functions

-(void)initFFMPEG
{
    // Register all formats and codecs
    //avcodec_init();
    av_register_all();
    av_init_packet(&packet);
    // Find the decoder for the 264
    pCodec=avcodec_find_decoder(CODEC_ID_H264);
    if(pCodec==NULL)
        goto initError; // Codec not found
    
    pCodecCtx = avcodec_alloc_context3(pCodec);
    // Open codec
    if(avcodec_open2(pCodecCtx, pCodec,NULL) < 0)
        goto initError; // Could not open codec
    // Allocate video frame
    
    pFrame=avcodec_alloc_frame();
    
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

-(void)releaseFFMPEG
{
    // Free scaler
    sws_freeContext(img_convert_ctx);
    
    // Free RGB picture
    avpicture_free(&picture);
    
    // Free the YUV frame
    av_free(pFrame);
    
    // Close the codec
    if (pCodecCtx) avcodec_close(pCodecCtx);
}

-(void)setupScaler {
    
    // Release old picture and scaler
    avpicture_free(&picture);
    sws_freeContext(img_convert_ctx);
    
    // Allocate RGB picture
    avpicture_alloc(&picture, PIX_FMT_RGB24,pCodecCtx->width,pCodecCtx->height);
    
    // Setup scaler
    static int sws_flags =  SWS_FAST_BILINEAR;
    img_convert_ctx = sws_getContext(pCodecCtx->width,
                                     pCodecCtx->height,
                                     pCodecCtx->pix_fmt,
                                     pCodecCtx->width,
                                     pCodecCtx->height,
                                     PIX_FMT_RGB24,
                                     sws_flags, NULL, NULL, NULL);
    
}

-(void)convertFrameToRGB
{    [self setupScaler];
    sws_scale (img_convert_ctx,pFrame->data, pFrame->linesize,
               0, pCodecCtx->height,
               picture.data, picture.linesize);
}

-(void)decodeAndShow : (char*) buf length:(int)len andTimeStamp:(unsigned long)ulTime
{
//    if (m_bPlayStop == YES)
//    {
//        return;
//    }
    //0407 add for ffmpeg decode
    packet.size = len;
    packet.data = (unsigned char *)buf;
    int got_picture_ptr=0;
    int nImageSize;
    nImageSize = avcodec_decode_video2(pCodecCtx,pFrame,&got_picture_ptr,&packet);
    NSLog(@"nImageSize:%d--got_picture_ptr:%d",nImageSize,got_picture_ptr);
    
    if (nImageSize > 0)
    {
        if (pFrame->data[0])
        {
            [self convertFrameToRGB];
          int  nWidth = pCodecCtx->width;
          int  nHeight = pCodecCtx->height;
            CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
            CFDataRef data = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, picture.data[0], nWidth*nHeight*3,kCFAllocatorNull);
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

-(void)updateView:(UIImage*)img
{
    imgView.image = img;
}

// 错误处理函数

void checkerror(int rtperr)
{
	if (rtperr < 0)
	{
		std::cout << "ERROR: " << RTPGetErrorString(rtperr) << std::endl;
		exit(-1);
	}
}

- (void)dealloc
{
    [_window release];
    dispatch_release(recieveQueue);
    [super dealloc];
}



-(void)setUprtpSession
{
    int localport = 6333;
    int status;
    
    
    // 获得用户指定的端口号
    
    //  localport = atoi(argv[1]);
    
    
    // 创建RTP会话
    RTPUDPv4TransmissionParams transparams;
	RTPSessionParams sessparams;
    //  sessparams.SetAcceptOwnPackets(true);
    sessparams.SetOwnTimestampUnit(1.0/2.0);
	transparams.SetPortbase(localport);
    status = sess.Create(sessparams,&transparams);
    
    checkerror(status);
    
    
    
    
    recieveQueue = dispatch_queue_create("recievieQueue", NULL);
}



-(void)getDataFromeOther
{
    while (1)
    {
        sess.BeginDataAccess();
        
        // check incoming packets
        if (sess.GotoFirstSource())
        {
            do
            {
                RTPPacket *pack;
                
                //  static int  n = 0;
                
                while ((pack = sess.GetNextPacket()) != NULL)
                {
                    unsigned char *data = pack->GetPayloadData();
                    // You can examine the data here
                    int length = pack->GetPayloadLength();
                    printf("data is :%d\n",length);
                    NSData *ddd = [NSData dataWithBytes:data length:length];
                    // NSData *ddd = [NSData dataWithBytes:data length:96];
                    NSLog(@"data :%@",ddd);
                    // we don't longer need the packet, soda
                    //                    // we'll delete it
                    //                    UIImage *img = [UIImage imageWithData:ddd];
                    //
                    //                    [UIImageJPEGRepresentation(img,1) writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thumb.jpg"] atomically:YES];
                    //
                    
                    
                    [self decodeAndShow:(char *)data length:length andTimeStamp:1000];
                    
//                    NSArray * paths
//                    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                    NSString *doc = [paths objectAtIndex:0];
//                    static int i = 0;
//                    if (length>100)
//                    {
//                        
//                        //  NSData *data = [NSData dataWithBytes:outbuf length:out_size];
//                        [ddd writeToFile:[doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg",i]] atomically:YES];
//                        i++;
//                        
//                    }
//                    

                    sess.DeletePacket(pack);
                }
            } while (sess.GotoNextSource());
        }
        
        printf("loop!! \n");
        
        usleep(100);
        sess.EndDataAccess();
    }
    
}





-(void)h264_init
{
    AVCodec *pCodec = NULL;
  
   // avcodec_init();
    av_register_all()   ;
    
    pCodec = avcodec_find_decoder(CODEC_ID_H264);
    
    if (NULL != pCodec)
    {
        pCodecCtx = avcodec_alloc_context3(pCodec);
        
        pCodecCtx->time_base.num = 1;
        pCodecCtx->time_base.den = 25;
        pCodecCtx->bit_rate = 0;
        pCodecCtx->frame_number = 1;
        pCodecCtx->codec_type = AVMEDIA_TYPE_VIDEO;
        pCodecCtx->width = 704;
        pCodecCtx ->height = 576;
        
        if (avcodec_open2(pCodecCtx, pCodec, NULL))
        {
            
        }
    }
}

typedef  unsigned char *     PBYTE;

-(void)h264Decode//(const PBYTE pSrcDate,const  dwDataLen, )
{
    int nGot ;
    AVPacket avpkt;
    av_init_packet(&avpkt);
    AVFrame *picFrame = avcodec_alloc_frame();
    avpkt.data = nil;
    avpkt.size = 0;
    
    avcodec_decode_video2(pCodecCtx, picFrame, &nGot, &avpkt);
    
    
//    int *pnWidth , *pnHeight;
//    
//    if (nGot>0)
//    {
//        *pnWidth = pCodecCtx->width;
//        *pnHeight = pCodecCtx->height;
//        
//        
//        for (int i=0,nDataLen = 0; i<3; i++)
//        {
//            int nShift = (i==0)?0:1;
//            PBYTE pYUVData = (PBYTE)
//            
//        }
//    }


//    AVPacket pkt;
//    AVFrame *frame = avcodec_alloc_frame();
//    int got_picture = 0, rc = 0;
//    
//    while (1){
//        av_init_packet(&pkt);
//        rc = av_read_packet(pCodecCtx,&pkt); /* 获取一个包的数据 */
//        if (rc != 0) break;
//        if (pkt.stream_index != found_stream_index)
//            goto free_pkt_continue; /* 不是所关心的视频流的数据，舍去 */
//        if ( avcodec_decode_video2 (videoDecodeCtx, frame, &got_picture, &pkt) < 0) {
//            /* 核心函数：解码。错误处理。 */
//        }
//        
//        if (got_picture) {
//            {  /* 处理获得的图像(存储在AVFrame里) */ }
//            av_free(frame);
//            frame = avcodec_alloc_frame();
//        }
//        
//    free_pkt_continue:
//        av_free_packet(&pkt);
//    }
    
}





- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,30,200,300)];
    imgView.backgroundColor = [UIColor greenColor];
    
    [self.window addSubview:imgView];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
       

    [self setUprtpSession];
    [self initFFMPEG];
    dispatch_async(recieveQueue, ^{
        [self getDataFromeOther];
    });
    
    
    
       
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

#pragma mark Error Handling

- (void)showError:(NSError *)error
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    });
}

@end
