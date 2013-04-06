//
//  FrameQueue.h
//  HelloWorld
//
//  Created by 耀占 司 on 11-12-30.
//  Copyright (c) 2011年 南京真云计算科技有限公司. All rights reserved.
//

#import <pthread.h>
#define mutex_init		pthread_mutex_init
#define mutex_lock		pthread_mutex_lock
#define mutex_unlock	pthread_mutex_unlock
#define mutex_destroy	pthread_mutex_destroy

typedef struct FrameData {
    void* pData;
    int size;
    struct FrameData * next;
} FrameData;


class FrameQueue 
{
    int m_iDataSize;
    int mQueueCapacity;
    const static int DEFAULT_SIZE = 20;
    pthread_mutex_t mMutex;
    FrameData *m_pHead;
    FrameData *m_pReader, *m_pWriter;
    int mQueueSize;
public:
    FrameQueue();
    ~FrameQueue();
    
    void InitQueue(int capacity, int size);
    void EnQueue(void *frame, int size);
    void* DeQueue();
    void ReleaseQueue();

};