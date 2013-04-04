
#include "Stunwapper.h"
#import <Foundation/NSThread.h>

# ifdef __cplusplus
extern "C" {
# endif
    
#include <stun/stunagent.h>
#include <agent/agent.h>
#include <agent/candidate.h>
#include <stun/stunmessage.h>
#include <pthread.h>
    
# ifdef __cplusplus
}
# endif

static NiceAgent *g_agent = NULL;

static CompatCallback g_callback;
static pthread_mutex_t g_stun_mutex;

static void cb_nice_agent_recv_func (NiceAgent *agent, guint stream_id, guint component_id, guint len,
                              gchar *buf, gpointer user_data)
{    
    printf("cb_nice_agent_recv_func %s \n", buf);
}

static void agent_lock(NiceAgent *agent, void* context)
{
    pthread_mutex_lock(&g_stun_mutex);
}

static void agent_unlock(NiceAgent *agent, void* context)
{
    pthread_mutex_unlock(&g_stun_mutex);
}

const char * SDP_FORMAT = "v=0\r\no=libnice 0 0 IN IP4 %s\r\ns=-\r\nc=IN IP4 %s\r\nt=0 0\r\na=ice-pwd:%s\r\na=ice-ufrag:%s\r\nm=audio %d RTP/AVP 0\r\n";
const char * CANDIDATE = "a=candidate:%s %d udp %lu %s %d typ host\r\n";
const char * CANDIDATE_SRFLX = "a=candidate:%s %d udp %lu %s %d typ srflx raddr %s rport %d\r\n";

static void cb_candidate_gathering_done(NiceAgent *agent, void* context, guint stream_id)
{
    printf("cb_candidate_gathering_done\n\n");
    
    char *icesdp = NULL;
    gchar *ufrag; 
    gchar *pwd;
    nice_agent_get_local_credentials(agent, stream_id, &ufrag, &pwd);
    printf("ice-ufrag:%s\n", ufrag);
    printf("ice-pwd:%s\n", pwd);
    
    int sdplen = 0;
    int candidatesnum = 0;
    GSList * candidates = nice_agent_get_local_candidates(agent, stream_id, NICE_COMPONENT_TYPE_RTP);
    int candidatecount = g_slist_length(candidates);
    char **candidatesbuffer = (char **)malloc(candidatecount);
    for (GSList *i = candidates; i; i = i->next)
    {
        char candidatebuffer[200];
        NiceCandidate *candidate = (NiceCandidate *)i->data;
        gchar tmpbuf[INET6_ADDRSTRLEN];
        nice_address_to_string (&candidate->addr, tmpbuf);
        int port = nice_address_get_port (&candidate->addr);
        nice_agent_add_local_address (agent, &candidate->addr);

        printf("ADDR : %lu %s:%d  ", candidate->priority, tmpbuf, port);
        if (nice_address_equal(&candidate->addr, &candidate->base_addr))
        {
            sprintf(candidatebuffer, CANDIDATE, candidate->foundation, NICE_COMPONENT_TYPE_RTP, candidate->priority, tmpbuf, port);
            int len = strlen(candidatebuffer);
            sdplen += len;
            candidatesbuffer[candidatesnum] = (char *)malloc(len+1);
            memcpy(candidatesbuffer[candidatesnum], candidatebuffer, len);
            candidatesbuffer[candidatesnum++][len] = 0;
        }
        else 
        {
            gchar tmpBasebuf[INET6_ADDRSTRLEN];
            nice_address_to_string (&candidate->base_addr, tmpBasebuf);
            int base_port = nice_address_get_port (&candidate->base_addr);
            printf("BaseADDR : %s:%d", tmpBasebuf, base_port);
            sprintf(candidatebuffer, CANDIDATE_SRFLX, candidate->foundation, NICE_COMPONENT_TYPE_RTP, candidate->priority, tmpbuf, port, tmpBasebuf, base_port);
            int len = strlen(candidatebuffer);
            sdplen += len;
            candidatesbuffer[candidatesnum] = (char *)malloc(len+1);
            memcpy(candidatesbuffer[candidatesnum], candidatebuffer, len);
            candidatesbuffer[candidatesnum++][len] = 0;
        }
        printf("\n");
        
        if (i->next == NULL)
        {
            char strsdp[200];
            sprintf(strsdp, SDP_FORMAT, tmpbuf, tmpbuf, pwd, ufrag, nice_address_get_port (&candidate->addr));
            int len = strlen(strsdp);
            sdplen += len;
            icesdp = (char *)malloc(sdplen+1);
            icesdp[sdplen] = 0;
            strcpy(icesdp, strsdp);
            for (int j=0; j<candidatesnum; j++)
            {
                strcat(icesdp, candidatesbuffer[j]);
                free(candidatesbuffer[j]);
            }
        }
        nice_candidate_free ((NiceCandidate *) i->data);
    }
    g_slist_free (candidates);
    free(candidatesbuffer);
    free(ufrag);
    free(pwd);
        
    if (icesdp != NULL)
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        NSMethodSignature *sig = [[(id)context class] instanceMethodSignatureForSelector:@selector(handleStunAddr: Stream:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setTarget:(id)context];
        [invocation setSelector:@selector(handleStunAddr: Stream:)];
        NSString *sdp = [NSString stringWithCString:icesdp encoding:NSUTF8StringEncoding];
        [invocation setArgument:&sdp atIndex:2];
        [invocation setArgument:&stream_id atIndex:3];
        [invocation retainArguments];
        [invocation invoke];
        
        [pool drain];
        
        free(icesdp);
    }
    
//    nice_agent_remove_stream(agent, stream_id);
}

static void cb_component_state_changed(NiceAgent *agent, void* context, guint stream_id, guint component_id, guint state)
{
//    printf("cb_component_state_changed %d \n", state);
//    if (state == NICE_COMPONENT_STATE_READY)
//    {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//        
//        NSMethodSignature *sig = [[(id)g_callback.context class] instanceMethodSignatureForSelector:@selector(handleSelectPair:remotePort:localPort:)];
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
//        [invocation setTarget:(id)g_callback.context];
//        [invocation setSelector:@selector(handleSelectPair:remotePort:localPort:)];
//        NSString *remoteIP = [NSString stringWithUTF8String:g_rtmpbuf];
//        [invocation setArgument:&remoteIP atIndex:2];
//        [invocation setArgument:&g_rport atIndex:3];
//        [invocation setArgument:&g_lport atIndex:4];
//        [invocation retainArguments];
//        
//        [invocation invoke];
//        [pool drain];
//    } 

    
//    NICE_COMPONENT_STATE_CONNECTED
}

static void cb_initial_binding_request_received(NiceAgent *agent, void* context, guint stream_id)
{
    printf("cb_initial_binding_request_received\n");
}

static void cb_new_selected_pair(NiceAgent *agent, void* context, guint stream_id, guint component_id, gchar *lfoundation, gchar* rfoundation)
{
    printf("cb_new_selected_pair\n");
    static gchar rip[INET6_ADDRSTRLEN] = {0};
    static int rport = 0;
    static int lport = 0;
    
    GSList * rcandidates = nice_agent_get_remote_candidates(agent, stream_id, NICE_COMPONENT_TYPE_RTP);

    for (GSList *i = rcandidates; i; i = i->next)
    {
        NiceCandidate * c = (NiceCandidate *) i->data;
        if (strcmp(c->foundation, rfoundation) == 0)
        {
            nice_address_to_string (&c->addr, rip);
            rport = nice_address_get_port (&c->addr);
            printf("pair rip: %s:%d ", rip, rport);
        }
            
        nice_candidate_free (c);
    }
    g_slist_free (rcandidates);
    
    GSList * lcandidates = nice_agent_get_local_candidates(agent, stream_id, NICE_COMPONENT_TYPE_RTP);
    for (GSList *i = lcandidates; i; i = i->next)
    {
        NiceCandidate * c = (NiceCandidate *) i->data;
        if (strcmp(c->foundation, lfoundation) == 0)
        {
            gchar lip[INET6_ADDRSTRLEN];
            nice_address_to_string (&c->addr, lip);
            lport = nice_address_get_port (&c->addr);
            printf(" lip: %s:%d\n", lip, lport);
        }
            
        nice_candidate_free (c);
    }
    g_slist_free (lcandidates);
    
    if (rport!=0 && lport!=0 && strlen(rip)!=0)
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        NSMethodSignature *sig = [[(id)g_callback.context class] instanceMethodSignatureForSelector:@selector(handleSelectPair:remotePort:localPort:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setTarget:(id)g_callback.context];
        [invocation setSelector:@selector(handleSelectPair:remotePort:localPort:)];
        NSString *remoteIP = [NSString stringWithUTF8String:rip];
        [invocation setArgument:&remoteIP atIndex:2];
        [invocation setArgument:&rport atIndex:3];
        [invocation setArgument:&lport atIndex:4];
        [invocation retainArguments];
        
        [invocation invoke];
        [pool drain];
    }
}

static void cb_new_candidate(NiceAgent *agent, void* context, guint stream_id, guint component_id, gchar *foundation)
{
    printf("cb_new_candidate\n");
}

static void cb_new_remote_candidate(NiceAgent *agent, void* context, guint stream_id, guint component_id, gchar *foundation)
{
    printf("cb_new_remote_candidate\n");
}

static void cb_reliable_transport_writable(NiceAgent *agent, void* context, guint stream_id, guint component_id)
{
    printf("cb_reliable_transport_writable\n");
}
 
int StunCreate(id target, const char *ip, int port, int control)
{
    pthread_mutexattr_t mta;
    pthread_mutexattr_init(&mta);
    pthread_mutexattr_settype(&mta, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&g_stun_mutex, &mta);
    pthread_mutexattr_destroy(&mta);
    agent_lock(g_agent, NULL);

    g_callback.context = target;
    g_callback.cb_candidate_gathering_done = cb_candidate_gathering_done;
    g_callback.cb_component_state_changed = cb_component_state_changed;
    g_callback.cb_new_selected_pair = cb_new_selected_pair;
    g_callback.cb_new_candidate = cb_new_candidate;
    g_callback.cb_initial_binding_request_received = cb_initial_binding_request_received;
    g_callback.cb_new_remote_candidate = cb_new_remote_candidate;
    g_callback.cb_reliable_transport_writable = cb_reliable_transport_writable;
    g_callback.lock = agent_lock;
    g_callback.unlock = agent_unlock;
    gboolean ret = 0;
    guint stream_id = 0;
    
    CFRunLoopRef rl = CFRunLoopGetCurrent();
    if (g_agent != NULL)
    {
        nice_agent_dispose(g_agent);
    }
    g_agent = nice_agent_new (rl, NICE_COMPATIBILITY_RFC5245, control);

    ret = nice_agent_set_stun(g_agent, ip, port/*"61.147.75.250", 3478*/);
    if (ret)
    {
        nice_agent_set_signals(g_agent, &g_callback);
        
        stream_id = nice_agent_add_stream (g_agent, 1);
        
        ret = nice_agent_gather_candidates (g_agent, stream_id);
        if (!ret) 
        {
            nice_agent_remove_stream(g_agent, stream_id);
        }
        
        ret = nice_agent_attach_recv (g_agent, stream_id, NICE_COMPONENT_TYPE_RTP, rl, cb_nice_agent_recv_func, NULL);
        if (!ret) 
        {
            nice_agent_remove_stream(g_agent, stream_id);
        }
    }
    agent_unlock(g_agent, NULL);
    return stream_id;
}

void StunClose(unsigned int stream_id, void *rlt, void *rl)
{
    if (stream_id == 0 || rlt == NULL)
        return;
    
    NSThread *rlthrd = (NSThread *)rlt;
    CFRunLoopRef runloop = (CFRunLoopRef)rl;
    agent_lock(g_agent, NULL);
    if (g_agent)
    {
//        nice_agent_remove_stream(g_agent, stream_id);
        nice_agent_dispose(g_agent);
        g_agent = NULL;
    }
        
    if (rlthrd)
    {
        if (runloop && ![rlthrd isFinished])
            CFRunLoopStop(runloop);

        while (![rlthrd isCancelled]) {
            [rlthrd cancel];
        }
        [rlthrd release];
    }

    pthread_mutex_destroy(&g_stun_mutex);
}

const int CANDIDATE_FOUNDATION = 0;
const int CANDIDATE_COMPONENT = 1;
const int CANDIDATE_PRIORITY = 3;
const int CANDIDATE_ADDR_IP = 4;
const int CANDIDATE_ADDR_PORT = 5;
const int CANDIDATE_TYPE = 7;
const int CANDIDATE_BASEADDR_IP = 9;
const int CANDIDATE_BASEADDR_PORT = 11;

static bool ParseSDPSessionCandidate(const char *session_dec, NiceCandidate * candidate)
{
    int len = strlen(session_dec);
    char *buf = (char *)malloc(len+1);
    int vcount = 0;
    int pos = 0;
    int i = 0;
    bool ret = true;
    
    while (pos < len)
    {
        buf[i] = session_dec[pos++];
        if (buf[i] == ' ')
        {
            buf[i] = '\0';
            if (vcount == CANDIDATE_FOUNDATION) //foundation
            {
                if (i>0 && i<sizeof(candidate->foundation))
                {
                    strcpy(candidate->foundation, buf);
                }
                else 
                {
                    ret = false;
                    break;
                }
            }
            else if (vcount == CANDIDATE_COMPONENT) //component
            {
                candidate->component_id = atoi(buf);
            }
            else if (vcount == CANDIDATE_PRIORITY) //priority
            {
                candidate->priority = atoi(buf);
            }
            else if (vcount == CANDIDATE_ADDR_IP) //ip
            {
                if (i>0 && i<INET6_ADDRSTRLEN)
                {
                    nice_address_init(&candidate->addr);
                    nice_address_set_from_string (&candidate->addr, buf);
//                    nice_address_init(&candidate->base_addr);
//                    nice_address_set_from_string (&candidate->base_addr, buf);
                }
                else 
                {
                    ret = false;
                    break;
                }
            }
            else if (vcount == CANDIDATE_ADDR_PORT) //port
            {
                nice_address_set_port(&candidate->addr, atoi(buf));
//                nice_address_set_port(&candidate->base_addr, atoi(buf));
            }
            else if (vcount == CANDIDATE_TYPE) //type
            {
                if (strcmp(buf, "host") == 0)
                {
                    candidate->type = NICE_CANDIDATE_TYPE_HOST;
                }
                else if (strcmp(buf, "srflx") == 0)
                {
                    candidate->type = NICE_CANDIDATE_TYPE_SERVER_REFLEXIVE;
                }
                else if (strcmp(buf, "prflx") == 0)
                {
                    candidate->type = NICE_CANDIDATE_TYPE_PEER_REFLEXIVE;
                }
                else if (strcmp(buf, "relay") == 0)
                {
                    candidate->type = NICE_CANDIDATE_TYPE_RELAYED;
                }
            }
            else if (vcount == CANDIDATE_BASEADDR_IP) //base ip
            {
                if (i>0 && i<INET6_ADDRSTRLEN)
                {
                    nice_address_init(&candidate->base_addr);
                    nice_address_set_from_string (&candidate->base_addr, buf);
                }
                else 
                {
                    ret = false;
                    break;
                }
            }
            else if (vcount == CANDIDATE_BASEADDR_PORT) //base port
            {
                nice_address_set_port(&candidate->base_addr, atoi(buf));
            }
            vcount++;
            i = 0;
        }
        else 
        {
            i++;
        }
    }
    
    free(buf);
    return ret;
}

const char *SDP_ICE_PWD = "a=ice-pwd:";
const char *SDP_ICE_UFRAG = "a=ice-ufrag:";
const char *SDP_CANDIDATE = "a=candidate:";

void GetSDPDec(void* context, unsigned int stream_id, const char *icesdp)
{
    if (g_agent == NULL)
    {
        return;
    }
    int len = strlen(icesdp);
    int ice_pwd_len = strlen(SDP_ICE_PWD);
    int ice_uflag_len = strlen(SDP_ICE_UFRAG);
    int ice_candidate_len = strlen(SDP_CANDIDATE);
    GSList *candidates = NULL;
    printf("rsdp : %s\n", icesdp);
    
    char *session_dec = (char *)malloc(len+1);
    char *ice_pwd = NULL;
    char *ice_ufrag = NULL;
    int sdppos = 0;
    int sessionpos = 0;
    while (sdppos < len)
    {
        session_dec[sessionpos] = icesdp[sdppos++];
        if (session_dec[sessionpos] == '\n')
        {
            if ((sessionpos>1)
                && (session_dec[0]=='a' || session_dec[0]=='m')
                && (session_dec[1]=='='))
            {
                session_dec[++sessionpos] = '\0';
                if (strncmp(session_dec, SDP_ICE_PWD, ice_pwd_len) == 0)
                {
                    ice_pwd = (char *)malloc(sessionpos-ice_pwd_len-1);
                    strncpy(ice_pwd, &session_dec[ice_pwd_len], sessionpos-ice_pwd_len-2);
                    ice_pwd[sessionpos-ice_pwd_len-2] = '\0';
                    printf("rice-pwd:%s\n", ice_pwd);
                    if (ice_pwd && ice_ufrag)
                    {
                        nice_agent_set_remote_credentials(g_agent, stream_id, ice_ufrag, ice_pwd);
                    }
                } 
                else if (strncmp(session_dec, SDP_ICE_UFRAG, ice_uflag_len) == 0)
                {
                    ice_ufrag = (char *)malloc(sessionpos-ice_uflag_len-1);
                    strncpy(ice_ufrag, &session_dec[ice_uflag_len], sessionpos-ice_uflag_len-2);
                    ice_ufrag[sessionpos-ice_uflag_len-2] = '\0';
                    printf("rice-ufrag:%s\n", ice_ufrag);
                    if (ice_pwd && ice_ufrag)
                    {
                        nice_agent_set_remote_credentials(g_agent, stream_id, ice_ufrag, ice_pwd);
                    }
                }
                else if (strncmp(session_dec, SDP_CANDIDATE, ice_candidate_len) == 0)
                {
                    NiceCandidate *candidate = nice_candidate_new(NICE_CANDIDATE_TYPE_HOST);
                    candidate->transport = NICE_CANDIDATE_TRANSPORT_UDP;
                    candidate->stream_id = stream_id;

                    if (ParseSDPSessionCandidate(&session_dec[ice_uflag_len], candidate))
                    {
                        candidates = g_slist_append(candidates, (void *)candidate);
                    }
                    else 
                    {
                        nice_candidate_free(candidate);
                    }
                }
            }
            sessionpos = 0;
        }
        else
        {
            sessionpos++;
        }
    }
    
    nice_agent_set_remote_candidates(g_agent, stream_id, NICE_COMPONENT_TYPE_RTP, candidates);

    if (ice_pwd) free(ice_pwd);
    if (ice_ufrag) free(ice_ufrag);
    for (GSList *i = candidates; i; i = i->next)
    {
        NiceCandidate * c = (NiceCandidate *) i->data;        
        nice_candidate_free (c);
    }
    g_slist_free(candidates);
    free(session_dec);
}
