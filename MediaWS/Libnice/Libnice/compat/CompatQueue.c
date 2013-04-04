/*
 *  CompatQueue.c
 *  libnice-darwin
 *
 *  Created by Vadim Tsyganok on 8/19/10.
 *  Copyright 2010 tsyganok.com. All rights reserved.
 *
 */

#include "CompatQueue.h"
#import <CoreFoundation/CoreFoundation.h>

void compat_queue_push_tail (CompatQueue *queue, void* data)
{
	CompatList* n = malloc(sizeof(CompatList));
	CompatList* old = queue->tail;
	if (old)
	{
		old->next = n;
	}
	n->prev = old;
	n->data = data;
	queue->tail = n;
	if (!queue->head)
	{
		queue->head = n;
	}
	queue->length++;
}

void* compat_queue_pop_head(CompatQueue *queue)
{
	if (!queue->length) return NULL;
	queue->length--;
	CompatList* head = queue->head;
	CompatList* next = head->next;
	if (next)
	{
		queue->head = next;
		next->prev = NULL;
	}
	void* data = head->data;
	free(head);
	if (queue->length == 0)
		queue->tail = NULL;
	return data;
}
void compat_queue_remove(CompatQueue* queue, const void* data)
{
	for (CompatList* el = queue->head;el;el = el->next)
	{
		if (el->data != data) continue;
		CompatList* prev = el->prev;
		CompatList* next = el->next;
		if (next)
			next->prev = prev;
		if (prev)
			prev->next = next;
		free(el);
		// if we removed first element, head is next
		if (el == queue->head) queue->head = next;
		if (el == queue->tail) queue->tail = prev;
		return;
	}

}
void compat_queue_clear(CompatQueue* queue)
{
	CompatList* el = queue->head;
	while(el)
	{
		CompatList* next = el->next;
		free(el);
		el = next;
	}
	queue->length = 0;
	queue->head = NULL;
	queue->tail = NULL;
	
}

void compat_queue_foreach(CompatQueue *queue, CompatFunc func, void* user_data)
{
	for (CompatList* el = queue->head; el; el=el->next)
		func(el->data, user_data);
}
CompatList* compat_queue_peek_head_link(CompatQueue* q)
{
	return q->head;
}