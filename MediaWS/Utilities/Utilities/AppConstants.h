//
//  AppConstants.h
//  LoochaUtilities
//
//  Created by hh k on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef LoochaUtilities_AppConstants_h
#define LoochaUtilities_AppConstants_h

extern unsigned short kLocalProxyPort;
#define kProxyURLPrefix @"/loocha_server"

#define kAssetsLibraryScheme @"assets-library://"
#define kFileScheme          @"file://"
#define kLocalFileScheme     @"file://localhost/"
#define kHTTPScheme          @"http://"

#define kLoochaDefaultEnterpriseId  @"1"


#define kVersionNumberLocal  5
#define kCampusDatabaseVersion      @"5"
#define kDatabaseDefault            @"kDatabaseDefault"
#define kHasGetFlowKey                 @"hasGetFlowKey"

//Net work module type
typedef enum {
    kTaskMsgSaveTask = 50,
    kTaskMsgSaveJob,
    kTaskMsgCreateFileLink,
    kTaskMsgResendTask,
    kTaskMsgNone
}netWorkMessageType;

#pragma mark URL
/////---------------------start URL constant  -----------------
#define kLoginFormat @"%@/login?version=Iphone_campuscloud_1.3.1"  // 登录 GET
#define kGetProvinceURL @"%@/%@/campus/school/province"
#define kGetCollegeURL @"%@/%@/campus/school/%@/college"
#define kGetCityURL    @"%@/%@/campus/school/%@/city"
#define kGetDepartmentURL @"%@/%@/campus/school/%@"
#define kGetStudentProfileURL @"%@/%@/campus/student"
#define kGetStudentInfoURL  @"%@/%@/campus/student/%@"
//-----------------------end URL constant -------------------

#pragma mark server config
//-----------------------start server config -------------------

#define PRODUCT_TEST  1

#if PRODUCT_TEST

#define kSchemeURLPath            @"https://61.147.75.239:8443"
#define kPicURLPath               @"http://61.147.75.239:8080"
#define kXMPPServerAddress        @"61.147.75.239"

#else

#define kSchemeURLPath            @"https://www.loocha.com.cn:8443"
#define kPicURLPath               @"http://download.loocha.com.cn"
#define kXMPPServerAddress        @"www.loocha.com.cn"    

#endif

#define kStunAddress             @"61.147.75.250"
#define kStunPort                3478

//-----------------------end server config -------------------

#define kWallPageURL             @""kPicURLPath"/com.realcloud.loochadroid.campuscloud/cover/%@"

//清理全局资源的 通知
#define kCleanupAppGlobalResource         @"CleanupAppGlobalResource"
#define kShoudlCleanUp                    @"kShoudlCleanUp"
#define kFriendStatusChangeKey            @"FriendStatusChangeKey"
#define kCleanBlackboardTimer             @"CleanBlackboardTimer"

#pragma mark requestURL

// /{user_id}/campus/myspace/homepage/{type}/{message_cid}/{message_id}
// 为在首页点击的消息来自information还是spacemessage，如果是information则type=1，其它设为0即可；
// message_cid： 如果首页点击的消息来自information，则设为对应的message_cid，否则可设为0； message_id： 首页点击的消息Id
#define Request_homePageHotPost       @""kSchemeURLPath"/%@/campus/myspace/homepage/%d/%d/%@?index=%d&limit=%d"
#define Requset_registerSMS           @""kSchemeURLPath"/user/mobile?id=%@&code=%@"
#define Request_NewsPerType           @""kSchemeURLPath"/%@/information/homepage"
#define Request_PhotoWall             @""kSchemeURLPath"/%@/campus/myspace/photo_wall?after=1&limit=%d"
#define Request_PhotoWall_Before      @""kSchemeURLPath"/%@/campus/myspace/photo_wall?before=%@&limit=%d"

#define Request_PhotoWall_BySchool             @""kSchemeURLPath"/%@/campus/myspace/%@/photo_wall?after=1&limit=%d"
#define Request_PhotoWall_BySchool_Before      @""kSchemeURLPath"/%@/campus/myspace/%@/photo_wall?before=%@&limit=%d"

#define Request_mySpace               @""kSchemeURLPath"/%@/myspace/%@/myspace?after=1&limit=30"
#define Request_mySpaceCredits        @""kSchemeURLPath"/%@/myspace/user/message/credit"
#define Request_mySpace_before        @""kSchemeURLPath"/%@/myspace/%@/myspace?before=%@&limit=30"
#define Request_Campus_Space          @""kSchemeURLPath"/%@/campus/myspace/%@/%d?after=1&limit=30"
#define Request_Campus_Space_before   @""kSchemeURLPath"/%@/campus/myspace/%@/%d?before=%@&limit=30"
#define Request_Concerned_Schools     @""kSchemeURLPath"/%@/campus/myspace/school/visit"
#define Request_ProfilePhotoWall      @""kSchemeURLPath"/%@/campus/myspace/%@/%@/personal/%d?after=1&limit=20"
#define Request_Profile               @""kSchemeURLPath"/%@/campus/student/%@"
#define Request_Profile_recomment     @""kSchemeURLPath"/%@/campus/student/%@/realtime"
#define Request_MySpace_Comments            @""kSchemeURLPath"/%@/myspace/%@/comment?after=1&limit=20"
#define Request_MySpace_Comments_before     @""kSchemeURLPath"/%@/myspace/%@/comment?before=%@&limit=20"
#define Request_OtherSpace_Comments         @""kSchemeURLPath"/%@/myspace/%@/myspace/%@/comment?limit=20&after=1"
#define Request_OtherSpace_Comments_before  @""kSchemeURLPath"/%@/myspace/%@/myspace/%@/comment?limit=20&before=%@"

#define Request_MyGroup_after               @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group?limit=50&after=1"
#define Request_MyGroup_before              @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group?limit=50&before=%@"
#define Request_MyGroup_count               @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/count"
#define Request_MyGroup_chat_after          @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/%@/spacemessage/%d?limit=100&after=%@"
#define Request_MyGroup_Space               @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/%@/spacemessage/%d?after=1&limit=15"
#define Request_MyGroup_Space_before        @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/%@/spacemessage/%d?before=%@&limit=15"
#define Request_exit_MyGroup_chat           @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/%@/spacemessage/%d?limit=1&after=1"

#define Request_Syncfile_after              @""kSchemeURLPath"/%@/file?after=%@&limit=500"
#define Request_Syncfile_before             @""kSchemeURLPath"/%@/file?before=%@&limit=500"
#define Request_PartTimeJob                 @""kSchemeURLPath"/%@/information?type=35&tag=%@&from=0&limit=20&version=1"
#define Request_PartTimeJob_more            @""kSchemeURLPath"/%@/information?type=35&tag=%@&from=%@&to=%@&limit=20&version=1"



#define Request_CampusSpace_Comments        @""kSchemeURLPath"/%@/campus/myspace/%@/%@/comment?after=1&limit=20"
#define Request_CampusSpace_Comments_before @""kSchemeURLPath"/%@/campus/myspace/%@/%@/comment?before=%@&limit=20"
#define Request_PM                          @""kSchemeURLPath"/%@/pm/type?after=%@&limit=150&message_type=0"
#define Request_PM_SMS                      @""kSchemeURLPath"/%@/sms?after=%@&limit=150"
#define Request_Friend                      @""kSchemeURLPath"/%@/friend?after=1"
//    发送SMS消息请求给好友
//    Request:
//    POST: /{user_id}/sms/{friend_record_id}/{friend_id}
#define Request_SMS_Invite                      @""kSchemeURLPath"/%@/sms/%@/%@"
#define SMSStatus_Update                      @""kSchemeURLPath"/%@/sms/0/%@"
#define PMFeedBackURL                       @""kSchemeURLPath"/%@/pm/%@/feedback"                // PUT: /{user_id}/pm/{pm_id}/feedback


#define Request_RelationList        @""kSchemeURLPath"/%@/campus/relation"
#define Request_Passive_RelationList        @""kSchemeURLPath"/%@/campus/relation/%@"
#define Add_RelationList        @""kSchemeURLPath"/%@/campus/relation/%@"
#define Delete_RelationList        @""kSchemeURLPath"/%@/campus/relation/%@"
//#define Request_UnlockRelation     @""kSchemeURLPath"/%@/campus/relation/unlock?credit=%@"

#define Request_Recommond_Friend    @""kSchemeURLPath"/%@/campus/student/friend/recommend_new?index=%d&limit=5"

#define Request_Concerned_Activity  @""kSchemeURLPath"/%@/campus/activity/school/visit"

#define Request_Space_Visitors             @""kSchemeURLPath"/%@/campus/search/visitor?limit=%d"
#define Request_Space_Visitors_before      @""kSchemeURLPath"/%@/campus/search/visitor?index=%d&limit=%d"
#define Request_Praisers                   @""kSchemeURLPath"/%@/campus/myspace/praise/user?limit=%d"
#define Request_Praisers_before            @""kSchemeURLPath"/%@/campus/myspace/praise/user?index=%d&limit=%d"

#define Request_Notice                     @""kSchemeURLPath"/%@/notice?type=1&limit=20"    //空间提醒 type为1
#define Request_Notice_before              @""kSchemeURLPath"/%@/notice?type=1&before=%@&limit=20"
#define Send_Notice_Read                   @""kSchemeURLPath"/%@/notice"


#define Request_Group_Notice               @""kSchemeURLPath"/%@/notice?type=2&limit=20"    //小组提醒 type为2
#define Request_Group_Notice_before        @""kSchemeURLPath"/%@/notice?type=2&before=%@&limit=20"

#define Request_Group_before               @""kSchemeURLPath"/%@/myspace/%@/myspace/%@/comment?before=%@&limit=20"
#define Request_Group_member               @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/%@?after=1&limit=1000"
#define Request_Single_Group               @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/%@/info/%@"



#define Request_CreditsAction              @""kSchemeURLPath"/%@/credit?after=1&limit=500"
#define Request_CreditsInfo                @""kSchemeURLPath"/%@/credit/enter"
#define Request_CreditsHelpInfo            @""kPicURLPath"/rules/grade.html"


#pragma mark send URL
#define create_newUser              @""kSchemeURLPath"/new_user/random/%@"
#define Send_mySpace                @""kSchemeURLPath"/%@/myspace"
#define Send_showMainPage           @""kSchemeURLPath"/%@/myspace/page"   //PST: /{user_id}/myspace/page
#define Send_campusSpace            @""kSchemeURLPath"/%@/campus/myspace/%@"
#define Send_photoWall              @""kSchemeURLPath"/%@/campus/myspace/%@"
#define Send_PraisePerson           @""kSchemeURLPath"/%@/campus/myspace/praise/space/%@?version=1"
#define Send_PraiseSpaceMessage     @""kSchemeURLPath"/%@/campus/myspace/praise/space_message/%@?version=1"
#define Send_PersonalSpaceComment   @""kSchemeURLPath"/%@/myspace/%@/%@/comment"
#define Send_NewsComment            @""kSchemeURLPath"/%@/information/%@/comment"
#define Send_CampusSpaceComment     @""kSchemeURLPath"/%@/campus/myspace/%@/%@"
#define Send_GroupSpaceComment      @""kSchemeURLPath"/%@/enterprise/%d/group/%@/spacemessage/%@/comment"
#define Send_PKComment              @""kSchemeURLPath"/%@/pk/%@/comment"
#define Send_PKCommentReply         @""kSchemeURLPath"/%@/pk/%@/comment/reply"
#define Send_CreateActivity         @""kSchemeURLPath"/%@/campus/activity/%@"
#define Send_DeleteActivity         @""kSchemeURLPath"/%@/campus/activity/%@/%@"
#define Send_EnterActivity          @""kSchemeURLPath"/%@/campus/activity/%@/%@"
#define Send_QuitActivity           @""kSchemeURLPath"/%@/campus/activity/%@/%@/quit"
#define copy_syncfile               @""kSchemeURLPath"/%@/file/copy/to/%@"
#define send_syncfile               @""kSchemeURLPath"/%@/file"
#define delete_syncfile             @""kSchemeURLPath"/%@/file/delete"
#define Send_updateFriend           @""kSchemeURLPath"/%@/friend/%@"
#define delete_pm                   @""kSchemeURLPath"/%@/pm/%@"
#define update_pm                   @""kSchemeURLPath"/%@/pm"
#define delete_pmByOtherUser        @""kSchemeURLPath"/%@/pm/%@/delete"
#define delete_friend               @""kSchemeURLPath"/%@/friend/%@"
#define delete_Space                @""kSchemeURLPath"/%@/myspace/%@"
#define delete_SpaceComment         @""kSchemeURLPath"/%@/myspace/%@/%@"
#define delete_newsComment          @""kSchemeURLPath"/%@/information/%@/%@"
#define delete_relation             @""kSchemeURLPath"/%@/campus/relation/%@"
#define delete_group                @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/%@"
#define quilt_group                 @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/%@/quit"
#define quilt_group_member          @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/%@/kick_members"
#define invite_group_member         @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/%@"
#define enter_normal_group          @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/%@/entergroup"
#define request_enter_group         @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/%@/request"

// /{user_id}/myspace/message/{message_id}/dig
#define Send_DigSpaceMessage        @""kSchemeURLPath"/%@/myspace/message/%@/dig?limit=%d"
// /{user_id}/information/news/{message_id}/{message_cid}/dig
#define Send_DigNews                @""kSchemeURLPath"/%@/information/news/%@/%d/dig?limit=%d"
#define Send_WallPage               @""kSchemeURLPath"/%@/campus/student/cover"
#define Send_Group_chat             @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/%@/spacemessage"
#define Send_Create_Group           @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group"
#define Send_Modify_Group           @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/%@/info"

#define Search_All_Group            @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/active?index=%d&limit=%d"
#define Search_Group_Name           @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/search?index=%d&pageSize=%d&q=%@"
#define Search_Group_Tag            @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/tag/search?%@"

#define Send_ActivitySum                                @""kSchemeURLPath"/%@/campus/activity/%@/activity_sum"     //  GET: /{user_id}/campus/activity/{group_id}/activity_sum
#define Send_ActivitySomeType                           @""kSchemeURLPath"/%@/campus/activity/%@/%@?after=1&limit=30"
#define Send_ActivitySomeTypeBefore                     @""kSchemeURLPath"/%@/campus/activity/%@/%@?before=%@&limit=30"
#define Send_ActivityMembers      @""kSchemeURLPath"/%@/campus/activity/%@/%@/users?after=1&limit=1000"  //    GET: /{user_id}/campus/activity/{group_id}/{activity_id}/users
#define Send_ActivityRealTime     @""kSchemeURLPath"/%@/campus/activity/%@/%@/realtime_info"  // GET: /{user_id}/campus/activity/{group_id}/{activity_id}/realtime_info

#define Send_InformationType      @""kSchemeURLPath"/%@/information/type"  //{user_id}/information/type

#define Send_NormalGroups         @""kSchemeURLPath"/%@/enterprise/%d/group?after=1&limit=30" // GET: /{user_id}/enterprise/{enterprise_id}/group     get myself normal groups.
#define Send_GroupsSpaceMsgType   @""kSchemeURLPath"/%@/enterprise/%d/group/%@/spacemessage/%d?after=1&limit=20" // GET: /{user_id}/enterprise/{enterprise_id}/group/{group_id}/spacemessage/{message_type}

#define Send_Support              @""kSchemeURLPath"/%@/support"
#define Send_GroupNotice_Request  @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/%@/response/%@"
#define Send_GroupNotice_Response @""kSchemeURLPath"/%@/enterprise/"kLoochaDefaultEnterpriseId"/group/%@/response-invite/%@"
#define Send_UnLockRelation       @""kSchemeURLPath"/%@/campus/relation/unlock?credit=%d"

#define Send_Promote_Group_Member @""kSchemeURLPath"/%@/enterprise/%@/group/%@/member/promote?credit=%d"

#define Send_BuyTitle             @""kSchemeURLPath"/%@/commodity/%@/buy?credit=%d"
#define Send_BuyGift              @""kSchemeURLPath"/%@/commodity/gift/%@/buy?credit=%d" 
#define Send_PutTitle             @""kSchemeURLPath"/%@/commodity/%@/put"
#define Send_LevelUp              @""kSchemeURLPath"/%@/credit/level"
#define Send_RefreshToTop         @""kSchemeURLPath"/%@/myspace/top/homepage/%@?credit=%d"
#define Send_GetCredits           @""kSchemeURLPath"/%@/credit/receive/%@"
#define Send_GetAllCredits        @""kSchemeURLPath"/%@/credit/receive/all?credit=%d"
#define Send_openChest            @""kSchemeURLPath"/%@/credit/%@/chest"
#define Send_Gift                 @""kSchemeURLPath"/%@/commodity/gift/%@/to/%@"

#define Request_AllRank               @""kSchemeURLPath"/%@/campus/rank?after=1&limit=30"
#define Request_OwnSchoolRank         @""kSchemeURLPath"/%@/campus/rank/%@?after=1&limit=30"   //GET:/{user_id}/campus/rank/{group_id}
#define Request_honoraryByLimit       @""kSchemeURLPath"/%@/commodity/honorary/canbuy?limit_1=%d&limit_2=%d"
#define Request_itemByLimit           @""kSchemeURLPath"/%@/commodity/prop/canbuy?limit_1=%d&limit_2=%d"
#define Request_giftByLimit           @""kSchemeURLPath"/%@/commodity/gift/canbuy?limit_1=%d&limit_2=%d"
#define Request_AllMineTitles         @""kSchemeURLPath"/%@/commodity/honorary?after=1&limit=500"
#define Request_AllMineItems          @""kSchemeURLPath"/%@/commodity/emo?after=1&limit=500"
#define Request_AllMyGifts            @""kSchemeURLPath"/%@/commodity/gift/mine?after=1&limit=500"
#define Request_ALLNotHaveTitles      @""kSchemeURLPath"/%@/commodity/honorary/nothave?after=1&limit=500"
#define Request_ALLNotHaveItems       @""kSchemeURLPath"/%@/commodity/prop/nothave?after=1&limit=500"
#define Request_ALLNotHaveGifts       @""kSchemeURLPath"/%@/commodity/gift/all?after=1&limit=500"
#define Request_requestSpaceByType    @""kSchemeURLPath"/%@/myspace/%@/messages/%d?after=1&limit=50"

//Game
#define Request_GameTests                                  @""kSchemeURLPath"/%@/test/tests?after=1&limit=30"  //{user_id}/test/tests
#define Request_GameTestsBefore                            @""kSchemeURLPath"/%@/test/tests?before=%@&limit=30"  //{user_id}/test/tests
#define Request_GameTestResult                             @""kSchemeURLPath"/%@/test/%@/conclusion?answer=%@"   //{user_id}/test/{test_id}/conclusion
#define Request_GameTestShareResult                             @""kSchemeURLPath"/%@/test/%@/share/conclusion?answer=%@"   //{user_id}/test/{test_id}/share/conclusion
#define Request_GameTest_Comments     @""kSchemeURLPath"/%@/test/space/%@/%@/comment?after=1&limit=50"       ///{user_id}/test/space/{space_owner_id}/{message_id}/comment
#define Send_GameTest_Comment         @""kSchemeURLPath"/%@/test/space/%@/%@/comment"       ///{user_id}/test/space/{space_owner_id}/{message_id}/comment

//邀请好友 新

#define Request_InviteRecords                               @""kSchemeURLPath"/%@/invite/record?after=1"   //("/#user_id#/invite/record",
#define Send_InviteRecord                      @""kSchemeURLPath"/%@/invite/record"  // INVITE_SMS_RECORD = new UrlConstant("/#user_id#/invite/record", HttpMethod.POST);



//Token
#define send_PushToken             @""kSchemeURLPath"/%@/applepush/update/token?token=%@&client_type=%@&switches=%@&client_ver=%@"          //    POST /{user_id}/applepush/update/token/{token}{client_type}/{switches}/{client_ver}


//Telecom flow
#define Request_TelecomFlow      @""kSchemeURLPath"/%@/telecom"  //{user_id}/telecom



//setting
#define send_modifyPasswd       @""kSchemeURLPath"/%@"

#define kSyncFileAfter                      @"%@SyncFileAfter"
#define kPMAfter                            @"%@PMAfter"
#define kPMSMSAfter                         @"%@PMSMSAfter"
#define kAdressBookAfter                    @"%@AdressbookAfter"
#define kSyncFiletmpAfter                   @"%@SyncFileAfterTmp"
#define MyGroupChatAfter                    @"%@GroupChatAfter"


#define kHttpLoginDefaultsKey @"username"
#define kHttpPasswordDefaultsKey @"password"
#define kUserIDDefaultsKey @"userID"
#define kDeviceTokenDefaultsKey @"token"
#define kSpaceURLDefaultsKey @"spaceURL"

#define kIsShake @"isShake"
#define kIsOpenSound @"isOpenSound"
#define kOnlineStatus @"onlineStatus"
#define kIsFirstUse @"isFirstUse"
#define kUserXMPPJIDDefaultsKey @"userXMPPJID"
#define kPinYinDefaultsKey @"pinyin"
#define kCameraTypeKey @"CameraType"




#pragma mark content type
#define TYPE_MESSAGE 0
#define TYPE_CARD_UDPATE  1
#define TYPE_CARD  2
#define TYPE_FRIEND_REQUEST  4
#define TYPE_FRIEND_RESPONSE  5
#define TYPE_FILE  7
#define TYPE_MISS_CALL  10
#define TYPE_CALL  11
#define TYPE_MESSAGE_TITLE  12



#define MAIN_PAGE_NEWS      @"main_page"
#define NOVEL_NEWS      @"novel_news"

#define MAJOR_ACTIVITY      @"major_activity"

typedef enum
{
    storageNewFolder   = -1,//新建文件夹
    soorageUnknown     = 0, //
    storageFolder      = 1, //
    storageFile        = 2, //
    storagePhoto       = 3, //
    storageMusic       = 4, //
    storageVideo       = 5, //
    storageVoice       = 6  //
}StorageDataType;



typedef enum {
    HOME_PAGE_NEWS_CAMPUS_HALL      = 0,        //校园大厅
    HOME_PAGE_NEWS_ENTERTAINMENT    = 30,       //娱乐(ENTERTAINMENT)
    HOME_PAGE_NEWS_SPORTS           = 31,       //体育(SPORTS)
    HOME_PAGE_NEWS_HUMORS           = 32,       //(HUMORS)
    HOME_PAGE_NEWS_CONSTELLATION    = 33,       //星座(CONSTELLATION)
    HOME_PAGE_NEWS_HOT_TOPIC        = 34,       //热点(HOT_TOPIC)
    HOME_PAGE_NEWS_JOBS             = 35,       //兼职(JOBS)
    HOME_PAGE_NEWS_STUDY_ABROAD     = 36,       //出国留学(STUDY_ABROAD)
    HOME_PAGE_NEWS_NOVEL            = 442,      //猎奇(NOVEL)
    HOME_PAGE_NEWS_BEAUTY           = 435,      //美女图片(BEAUTY)
    HOME_PAGE_NEWS_NOVELTY          = 441,      
    HOME_PAGE_NEWS_ASHAMED          = 442,      //糗事
    HOME_PAGE_NEWS_PHOTOGRAPHY      = 453,
    HOME_PAGE_NEWS_CRAFTS           = 465,
    HOME_PAGE_NEWS_TELEVISION       = 466,
    HOME_PAGE_NEWS_ANIMATION        = 467,
    HOME_PAGE_NEWS_MOVIE            = 468,
    HOME_PAGE_NEWS_SERIES           = 469,
    HOME_PAGE_NEWS_PET              = 470,
    HOME_PAGE_NEWS_FUNNY            = 471,
    HOME_PAGE_NEWS_GAME             = 600,
    HOME_PAGE_NEWS_HUMOR            = 610,
    HOME_PAGE_NEWS_TRAVEL           = 620,
    HOME_PAGE_NEWS_TECHNOLOGY       = 630,
    HOME_PAGE_NEWS_WORK             = 640,
    HOME_PAGE_NEWS_SPORT_ENTERTAIMENT = 650,
    HOME_PAGE_NEWS_LEISURE_OHTER    = 660,
    HOME_PAGE_NEWS_FOOD             = 100000        
} HomePageNewsType;



#pragma mark resource status
typedef enum
{
    RESOURCE_STATUS_NORMAL  = 0,
    RESOURCE_STATUS_UPLOADING,
    RESOURCE_STATUS_DELETING,
    RESOURCE_STATUS_DOWNLOADING,
    
    
    
    
    RESOURCE_STATUS_BE_BASE = 100,
    RESOURCE_STATUS_BE_UPLOADED,
    RESOURCE_STATUS_BE_DOWNLOADED,
    
    
    RESOURCE_STATUS_FAILEDBASE = 200,
    RESOURCE_STATUS_UPLOADFAILED,
    RESOURCE_STATUS_DELETEFAILED,
    RESOURCE_STATUS_DOWNLOADFAILED,
    
    RESOURCE_STATUS_MAX
} ResourceStatus;


#pragma mark - start  Student Basic info
#define kbasicInfStudentName    @"basicInfStudentName"
#define kbasicInfStudentSex     @"basicInfStudentSex"
#define kbasicInfCollege        @"basicInfCollege"
#define kbasicInfBirthCity      @"basicInfBirthdayCity"
#define kbasicInfBirthProvince  @"basicInfBirthdayProvince"
#define kbasicInfHometown       @"basicInfHometown"
#define kbaaicinfSchoolType     @"basicInfSchoolType"
#define kbasicInfDepartment     @"basicInfDepartment"
#define kbasicInfEnrollmentTime @"basicInfEnrollmentTime"
#define kbasicInfAvtarImg       @"basicInfAvtarImg"
#define kbasicInfAvtarURL       @"basicInfAvtarURL"

#define kbasicInfoPhone       @"basicInfoPhone"
#define kbasicInfoSex       @"basicInfoSex"
#define kbasicInfoBirthday       @"basicInfoBirthday"
#define kbasicInfoMobile       @"basicInfoMobile"
#define kbasicInfoClass     @"basicInfoClass"


#pragma mark - end  Student Basic info



//type=5: 大学； type=4: 中专技校； type=3: 高中
#define kSCHOOLL_TYPE_COLLEGE       5
#define kSCHOOLL_TYPE_SECONDARY     4
#define kSCHOOLL_TYPE_MIDDLE        3


#define kCameraTypeKey   @"CameraType"


//默认图片的的名字
#define kDefaultAvater @"defaultAvatar"   //头像
#define kDefaultImg  @""     // 图片
#define kDefaultVideo  @""   //视频
#define kDefaultRecord  @""  //录音
#define kDefaultMusic  @""  //

#define kTipsViewHeight 38
#define kMaxRichTextHeight 80
#define kMaxContentAreaWidth 286 // 320 - kDashMarginDefault*2

#define CAMERA_TYPE_LOCALPIC        @"localPic"
#define CAMERA_TYPE_LOCALMOV        @"localMov"
#define CAMERA_TYPE_LOCALLibrary    @"localLib"
#define CARMER_TYPE_TAKEPHOTO       @"image"
#define CARMER_TYPE_MOVIE           @"movie"

#define kcameraVideoSuffix       @".3gp"
#define kAppDefaultColor        RCColorWithRGB(244, 244, 244)

//活动的类型
//public final static int TYPE_MIN = 0;
//public final static int TYPE_SPORTS = TYPE_MIN;
//public final static int TYPE_MUSIC = TYPE_MIN + 1;
//public final static int TYPE_GAME = TYPE_MIN + 2;
//public final static int TYPE_CLUB = TYPE_MIN + 3;
//public final static int TYPE_TELECOM = TYPE_MIN + 4;
//public final static int TYPE_OTHER = TYPE_MIN + 5;
//public final static int TYPE_SHOW = TYPE_MIN + 6;
//public final static int TYPE_MAX = 20;
#define kActivityTypeSport  @"0"
#define kActivityTypeMusic  @"1"
#define kActivityTypeGame   @"2"
#define kActivityTypeClub   @"3"
#define kActivityTypeTrip   @"123"
#define kActivityTypeChat   @"4"


#define IMAGE_DEFAULT_FOLDER        @"storage_folder"
#define IMAGE_DEFAULT_PHOTO         @"default_image"
#define IMAGE_DEFAULT_MUSIC         @"default_music"
#define IMAGE_DEFAULT_VIDEO         @"default_video"
#define IMAGE_DEFAULT_FILE          @"storage_default_file"
#define IMAGE_DEFAULT_VOICE         @"default_music"
#define IMAGE_DEFAULT_NEW_FOLDER    @"storage_new_folder"
#define IMAGE_DEFAULT_GROUP_LOGO    @"default_group_Logo"

// Push2Talk Push Type and Value
typedef enum {
    kPush2TalkCallRemote,
    kPush2TalkRemoteMsg,
    kPush2TalkQuit
} Push2TalkPushType;

#define kPush2TalkPushKey   @"Push2TalkPush"
#define kPush2TalkPushType  @"kPush2TalkPushType"
#define kPush2TalkPushValue @"kPush2TalkPushValue"


//news show Type

#define kNewsShowTypeNone            @"0"
#define kNewsShowTypeOneText         @"1"
#define kNewsShowTypeTwoText         @"2"
#define kNewsShowTypeOneImg          @"3"
#define kNewsShowTypeTwoImg          @"4"
#define kNewsShowTypeImgTiltle       @"5"
#define kNewsShowTypeHeader          @"6"



//头像晃动通知
#define ShakeAvatar @"ShakeAvatarNotification"
#define shakeStatusKey @"shakeStatus"
#define shakeControlerKey @"stakeControlerClass"



//小组
// 组类型 (0-public完全开放,1-open半开放,2-hide封闭)
#define GroupTypePublice    @"0"
#define GroupTypeOpen       @"1"
#define GroupTypeHide       @"2"

//菜单
#define MENU_MY_SPACE @"我的空间"
#define MENU_MYPM @"好友私聊"
#define MENU_FRIEND_NEWS @"朋友新事"
#define MENU_GROUP @"我的小组"
#define MENU_CRASH @"我暗恋Ta"
#define MENU_CAMPUS_SPACE @"校园大厅"
#define MENU_SEARCH @"去找朋友"
#define MENU_ACTIVE @"校园活动"
#define MENU_NEWS @"新闻娱乐"
#define MENU_JOB @"我要兼职"
#define MENU_PHONE @"免费电话"
#define MENU_STORAGE @"我的云盘"
#define MENU_INVITE_FRIEND @"邀请好友"
#define MENU_ADVICE @"软件建议"
#define MENU_ABOUT @"关于班级云"
#define MENU_HAND_COLLEGE @"掌上大学"
#define MENU_LOGOUT @"注销登陆"
#define MENU_SETTING @"系统设置"





//show到首页 的标签 类型
//陈中银
//public final static int TYPE_INFORMATION_NOVEL = 442;
//public final static int TYPE_INFORMATION_BEAUTY = 435;
//public final static int TYPE_INFORMATION_CUTE = 470;
//public final static int TYPE_INFORMATION_NEWS = 30;
//public final static int TYPE_INFORMATION_FOOD = 483;
//public final static int TYPE_INFORMATION_MOVIE = 453;
//public final static int TYPE_INFOARMTION_PARTTIME = 35;
//
//public final static int TYPE_INFOARMTION_GAME = 600;
//public final static int TYPE_INFOARMTION_HUMOR = 610;
//public final static int TYPE_INFOARMTION_TRAVEL = 620;
//public final static int TYPE_INFOARMTION_TECHNOLOGY = 630;
//public final static int TYPE_INFOARMTION_WORK = 640;
//public final static int TYPE_INFOARMTION_SPORT_ENTERTAIMENT = 650;
//public final static int TYPE_INFOARMTION_LEISURE_OHTER = 660;


#define MainPageDefaultBackgroundColor [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f]


#define KATTTNodeNotification               @"ATTTNodeNotification"
#define kBrowerResourceFromPreViewBar       @"BrowerResourceFromPreViewBar"

#define kGiftDownload                       @"GiftDownload"
#define kTTImageframe                       @"TTImageframe"


#define OPEN_CHEST_NOTIFY       @"OpenChestNotify"


//SMSStatus
#define SMSStatus_UNINIT    @"0"
#define SMSStatus_PADDING   @"1"
#define SMSStatus_ACCEPT    @"2"
#define SMSStatus_REJECT    @"3"

#endif
