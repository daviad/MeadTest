//
//  FrameQueue.mm
//  HelloWorld
//
//  Created by 耀占 司 on 11-12-30.
//  Copyright (c) 2011年 南京真云计算科技有限公司. All rights reserved.
//

#include "FrameQueue.h"

FrameQueue::FrameQueue()
{
    m_pHead = NULL;
    m_pReader = NULL;
    m_pWriter = NULL;
    mQueueSize = 0;
}

FrameQueue::~FrameQueue()
{
    
}

void FrameQueue::InitQueue(int capacity, int size)
{
    m_iDataSize = size;
    if(capacity < DEFAULT_SIZE)
    {
        capacity = DEFAULT_SIZE;
    }
    
    m_pHead = new FrameData();
    m_pHead->next = m_pHead;
    m_pHead->pData = NULL;
    m_pHead->size = 0;
        
    for (int i = 0; i < capacity - 1; i++) {
        FrameData *p = new FrameData();
        p->pData = new Byte[m_iDataSize];
        p->size = 0;
        p->next = m_pHead->next;
        m_pHead->next = p;
    }
    mQueueCapacity = capacity;
    mQueueSize = 0;
    m_pReader = m_pHead;
    m_pWriter = m_pReader->next;
    mutex_init(&mMutex, NULL);
}

void FrameQueue::EnQueue(void *Frame, int size)
{
    if(Frame != NULL)
    {
        mutex_lock(&mMutex);
        
        if(m_pWriter == m_pReader)//out of memory
        {
            FrameData *p = new FrameData();
            p->pData = NULL;
            p->size = 0;
            p->next = m_pWriter->next;
            m_pWriter->next = p;
            m_pReader = p;
            
            mQueueSize++;
        }
        NSLog(@"EnQueue Size=%d", size);
        //m_pWriter->pData = new short[size];
        m_pWriter->size = size;
        memcpy(m_pWriter->pData, Frame, size);
        //m_pWriter->pData = Frame;
        m_pWriter = m_pWriter->next;
        mQueueSize++;
        mutex_unlock(&mMutex);
    }
}

void* FrameQueue::DeQueue()
{
    mutex_lock(&mMutex);
    if(m_pReader->next == m_pWriter)
    {
        mutex_unlock(&mMutex);
        return NULL;
    }
    
    FrameData *p = m_pReader->next;
    m_pReader = m_pReader->next;
    mQueueSize--;
    mutex_unlock(&mMutex);
    return p->pData;
}

void FrameQueue::ReleaseQueue()
{
    if(m_pHead == NULL)
    {
        return;
    }
    FrameData *p = m_pHead->next, *pp = NULL;
    while (p != NULL && p != m_pHead)
    {
        pp = p->next;
        delete p->pData;
        p->pData = NULL;
        delete p;
        p = NULL;
        p = pp;
        pp = pp->next;
    }
    if(m_pHead != NULL)
    {
        delete m_pHead->pData;
        m_pHead->pData = NULL;
        delete m_pHead;
        m_pHead = NULL;
    }
    return;
}