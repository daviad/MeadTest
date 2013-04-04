#ifndef _STUNWRAPPER__H__H
#define _STUNWRAPPER__H__H

int StunCreate(id target, const char *ip, int port, int control);

void GetSDPDec(void* context, unsigned int stream_id, const char *icesdp);

void StunClose(unsigned int stream_id, void *rlt, void *rl);
#endif
