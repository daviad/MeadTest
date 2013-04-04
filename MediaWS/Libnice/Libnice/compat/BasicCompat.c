/*
 *  BasicCompat.c
 *  libnice-darwin
 *
 *  Created by Vadim Tsyganok on 8/19/10.
 *  Copyright 2010 tsyganok.com. All rights reserved.
 *
 */


#include "BasicCompat.h"
char* compat_strdup(const char* src)
{
	if (!src) return NULL;
	return strdup(src);
}
void* compat_memdup(const void* src, unsigned int byte_size)
{
	if (!src) return NULL;
	void* dst = malloc(byte_size);
	memcpy(dst, src, byte_size);
	return dst;
}

char* compat_strndup(const char* str, size_t n)
{
	char* out = malloc(n+1);
	size_t counter;
	for (counter = 0; counter < n; counter++)
	{
		char c = str[counter];
		if (!c) break;
		out[counter]=c;
	}
	for (;counter<=n;counter++)
		out[counter] = 0;
	return out;
	
}
#define MICROSECONDS_IN_SECOND 1000000
void compat_time_val_add(struct timeval* v, long microseconds)
{
	v->tv_usec = v->tv_usec + microseconds;
	while (v->tv_usec >= MICROSECONDS_IN_SECOND)
	{
		v->tv_usec -= MICROSECONDS_IN_SECOND;
		v->tv_sec++;
	}
	// If we subtracted time:
	while (v->tv_usec < 0)
	{
		v->tv_usec += MICROSECONDS_IN_SECOND;
		v->tv_sec--;
	}
}