/*
 *  DarwinCompat.c
 *  libnice-darwin
 *
 *  Created by Vadim Tsyganok on 8/21/10.
 *  Copyright 2010 tsyganok.com. All rights reserved.
 *
 */

#include "DarwinCompat.h"

typedef enum 
{
	DarwinSourceTypeTimer,
	DarwinSourceTypeGeneric
} DarwinSourceType;

typedef struct __DarwinCompatSource
{
	DarwinSourceType type;
	void* source;
	CFRunLoopRef runLoop;
    void* priv;
} DarwinCompatSource;

typedef struct 
{
	void* data;
	DarwinSourceFunc f;
	CFAllocatorReleaseCallBack release;
} DarwinCallBackWrapper;

DarwinCallBackWrapper* create_darwin_context_wrappper(DarwinSourceFunc f, void* contextData, CFAllocatorReleaseCallBack release)
{
	DarwinCallBackWrapper* w = malloc(sizeof(DarwinCallBackWrapper));
	w->f = f;
	w->data  = contextData;
	w->release = release;
	return w;
}

void darwin_release_context_wrapper(const void* context)
{
	DarwinCallBackWrapper* w = (DarwinCallBackWrapper*)context;
	if (w->release && w->data)
		w->release(w->data);
	free(w);
}

DarwinCompatSourceRef create_darwin_source_ref(DarwinSourceType type, void* source, CFRunLoopRef runLoop, void *priv)
{
	DarwinCompatSourceRef ref = malloc(sizeof(DarwinCompatSource));
	ref->type = type;
	ref->source = source;
	ref->runLoop = runLoop;
    ref->priv = priv;
	return ref;
}

void darwin_timer_callback(CFRunLoopTimerRef timer, void *info)
{
	DarwinCallBackWrapper* wrapper = (DarwinCallBackWrapper*)info;
	cbool keep = wrapper->f(wrapper->data);
	if (keep) return;
	if (CFRunLoopTimerIsValid(timer))
	{
		CFRunLoopTimerInvalidate(timer);
		CFRelease(timer);
		free(wrapper);
	}
}


DarwinCompatSourceRef darwin_timeout(int interval, CFRunLoopRef runLoop, DarwinSourceFunc f, void* contextData)
{
	CFTimeInterval cfint = interval / 1000.0;
	CFAbsoluteTime firstFire = CFAbsoluteTimeGetCurrent() + cfint;
	CFRunLoopTimerCallBack cb = darwin_timer_callback;
	CFRunLoopTimerContext ctx;

	ctx.info = create_darwin_context_wrappper(f, contextData, NULL);
	ctx.retain = NULL; ctx.copyDescription = NULL;
	ctx.release = darwin_release_context_wrapper; 
	ctx.version = 0;

	CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, firstFire, cfint, 0, 0, cb, &ctx);
	
	CFRunLoopAddTimer(runLoop, timer, kCFRunLoopCommonModes);
	
	DarwinCompatSourceRef ref = create_darwin_source_ref(DarwinSourceTypeTimer, timer, runLoop, NULL);
	return ref;
}
typedef cbool(*DarwinCompatSocketFunc)(DarwinCompatSourceRef,int,CFSocketCallBackType,void* data);
//void darwin_socket_callback (
//				 CFSocketRef s,
//				 CFSocketCallBackType callbackType,
//				 CFDataRef address,
//				 const void *data,
//				 void *info
//				 )
//{
//	
//	// Here is signature of what we have to invoke:
//	/*
//	f (
//							GIOChannelRef io,
//							G_GNUC_UNUSED
//							GIOCondition condition,
//							gpointer data)
//	 */
//	// CFSocketCallBackType   is GIOCondition
//	// note: first parameter (IO) is not used in the code with nice comment:
//	//	/* note: dear compiler, these are for you: */
//	//	(void)io;
//
//	DarwinCallBackWrapper* wrapper = (DarwinCallBackWrapper*)info;
//	DarwinCompatSocketFunc callback = (DarwinCompatSocketFunc)wrapper->f;
//	callback(NULL, 0, callbackType, wrapper->data);
//}


CFSocketRef darwin_socket(CFSocketNativeHandle handle, CFOptionFlags callBackOptions, CFSocketCallBack f, void* contextData, CFAllocatorReleaseCallBack destroy)
{
	CFSocketContext ctx;
	ctx.version = 0;
	ctx.info = contextData;
	ctx.retain = NULL; 
	ctx.release = destroy;
    ctx.copyDescription = NULL;

	
	
	CFSocketRef socketRef = CFSocketCreateWithNative(kCFAllocatorDefault, handle, callBackOptions, f, &ctx);
	
	return socketRef;
}
DarwinCompatSourceRef darwin_add_run_loop_socket_source(CFSocketRef socket, CFRunLoopRef runLoop)
{
	CFRunLoopSourceRef srcRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, socket, 0);
	CFRunLoopAddSource(runLoop, srcRef, kCFRunLoopDefaultMode);
	DarwinCompatSourceRef ref = create_darwin_source_ref(DarwinSourceTypeGeneric, srcRef, runLoop, socket);
	return ref;
}
// Removes source from run-loop.
void darwin_compat_source_destroy(DarwinCompatSourceRef source)
{
	switch (source->type)
	{
		case DarwinSourceTypeTimer:
		{
			CFRunLoopTimerRef timer = (CFRunLoopTimerRef)source->source;
			CFRunLoopTimerInvalidate(timer);
			break;
		}
		case DarwinSourceTypeGeneric:
		{
			CFRunLoopSourceRef ref = (CFRunLoopSourceRef)source->source;
			CFRunLoopRef runLoop = source->runLoop;
            CFSocketInvalidate((CFSocketRef)(source->priv));
			CFRunLoopRemoveSource(runLoop, ref, kCFRunLoopDefaultMode);
			break;
		}
	}
}

void darwin_compat_unref(DarwinCompatSourceRef source)
{
	CFRelease(source->source);
	// As we did not implement ref, we can free memory now:
	free(source);
}

void darwin_socket_unref(CFSocketRef socket)
{
	CFRelease(socket);
}
