//
//  DatabaseTablesSingleton.m
//  LoochaUtilities
//
//  Created by hh k on 12-9-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DatabaseTablesSingleton.h"
static DatabaseTablesSingleton *sharedInstance;


@implementation DatabaseTablesSingleton
@synthesize TablesMap = _TablesMap;
@synthesize TablesInsertSQLMap = _TablesInsertSQLMap;
@synthesize TablesInsertDicMap = _TablesInsertDicMap;



+ (DatabaseTablesSingleton *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DatabaseTablesSingleton alloc] init];
    });
    return sharedInstance;
}


+ (void)releaseInstance
{
    [sharedInstance release];
}



-(id)init
{
    if(self = [super init])
    {
        _TablesMap = [[NSMutableDictionary alloc] init];
        _TablesInsertSQLMap = [[NSMutableDictionary alloc] init];
        _TablesInsertDicMap = [[NSMutableDictionary alloc] init];
        
        NSArray *accountTable = [NSArray arrayWithObjects:ACCOUNT_USER_ID,ACCOUNT_USER_MOBILE,ACCOUNT_LOGIN_TIME,ACCOUNT_PASSWORD,ACCOUNT_ISAUTOLOGIN,nil];
        [self setMap:TABLE_NAME_ACCOUNT Value:accountTable];
        
        NSArray *taskTable = [NSArray arrayWithObjects:TASK_ID, TASK_TYPE ,TASK_STATUS ,TASK_TABLENAME ,TASK_USERID,nil];
        [self setMap:TABLE_NAME_TASK Value:taskTable];
        
        NSArray *jobTable = [NSArray arrayWithObjects:JOB_ID, JOB_TASK_ID,JOB_COMMAND,JOB_URL,JOB_JSON,JOB_HEADER,JOB_FILE_PATH,JOB_IS_MAIN,JOB_STATUS, nil];
        [self setMap:TABLE_NAME_JOB Value:jobTable];
        
        NSArray *studentTable = [NSArray arrayWithObjects:
                                 STUDENT_USER_ID,
                                 STUDENT_ID,
                                 STUDENT_NAME,
                                 STUDENT_AVATAR,
                                 STUDENT_SAVATAR,
                                 STUDENT_UPDATE_TIME,
                                 STUDENT_PRIVILEGE,
                                 STUDENT_DATA ,
                                 STUDENT_PDATA,
                                 STUDENT_FDATA,
                                 STUDENT_GROUP_ID ,
                                 STUDENT_DATA_TYPE ,
                                 STUDENT_SCHOOL_GROUP_ID,
                                 STUDENT_CITY_NAME,
                                 STUDENT_VISIBLE,
                                 STUDENT_COVERRESID,
                                 STUDENT_COVERURL,
                                 STUDENT_SCHOOL_LOGO_URL,
                                 STUDENT_TITLE,
                                 STUDENT_LEVEL,
                                 STUDENT_STATUS,
                                 nil];
        [self setMap:TABLE_NAME_STUDENT Value:studentTable];
        
        
        NSArray *provinceTable = [NSArray arrayWithObjects:
                                  PROVINCE_ID ,
                                  PROVINCE_NAME,
                                  PROVINCE_CITY,
                                  PROVINCE_CITY_UPDATE_TIME ,
                                  PROVINCE_COLLEGE_UPDATE_TIME,
                                  nil];
        [self setMap:TABLE_NAME_PROVINCE Value:provinceTable];
        
        NSArray *collegeTable = [NSArray arrayWithObjects:
                                 COLLEGE_ID,
                                 COLLEGE_PROVINCE_ID,
                                 COLLEGE_CITY_ID,
                                 COLLEGE_SCHOOL_TYPE,
                                 COLLEGE_GROUP_ID ,
                                 COLLEGE_NAME,
                                 nil];
        [self setMap:TABLE_NAME_COLLEGE Value:collegeTable];
        
        
        NSArray *cityTable = [NSArray arrayWithObjects:
                              CITY_ID ,
                              CITY_PROVINCE_ID ,
                              CITY_TIME ,
                              CITY_NAME ,
                              nil];
        [self setMap:TABLE_NAME_CITY Value:cityTable];
        
        
        NSArray *departmentTable = [NSArray arrayWithObjects:
                                    DEPARTMENT_ID,
                                    DEPARTMENT_NAME ,
                                    DEPARTMENT_SCHOOL_ID ,
                                    nil];
        [self setMap:TABLE_NAME_DEPARTMENT Value:departmentTable];
        
        
        NSArray *pmTable = [NSArray arrayWithObjects:PM_ID,
                            PM_TYPE        ,
                            PM_CONTENT_TYPE,
                            PM_TEXT        ,
                            PM_DELETE      ,
                            PM_DIRECTION   ,
                            PM_OTHER_ID    ,
                            PM_IS_READ     ,
                            PM_ATTACHEMENT ,
                            PM_TIME ,
                            PM_USERID,
                            PM_MOBILE,
                            PM_STATUS,
                            PM_SPECIAL_EMO,
                            nil];
        [self setMap:TABLE_NAME_PERSONAL_MESSAGES Value:pmTable];
        
        
        NSArray *pmSMSTable = [NSArray arrayWithObjects:PM_ID,
                            PMSMS_TYPE        ,
                            PMSMS_CONTENT_TYPE,
                            PMSMS_TEXT        ,
                            PMSMS_DELETE      ,
                            PMSMS_DIRECTION   ,
                            PMSMS_OTHER_ID    ,
                            PMSMS_IS_READ     ,
                            PMSMS_ATTACHEMENT ,
                            PMSMS_TIME ,
                            PMSMS_USERID,
                            PMSMS_MOBLEL,
                            PMSMS_STATUS,
                            PMSMS_SPECIAL_EMO,
                            nil];

        [self setMap:TABLE_NAME_PERSONAL_MESSAGES_SMS Value:pmSMSTable];
        
        NSArray *personalSpaceTable = [NSArray arrayWithObjects:PERSONAL_SPACE_ID,
                                       PERSONAL_SPACE_OWNER,
                                       PERSONAL_SPACE_NAME,
                                       PERSONAL_SPACE_AVATAR,
                                       PERSONAL_SPACE_CONTENT,
                                       PERSONAL_SPACE_TIME,
                                       PERSONAL_SPACE_UPDATE,
                                       PERSONAL_SPACE_MONTH,
                                       PERSONAL_SPACE_COMMENT_COUNT,
                                       PERSONAL_SPACE_COMMENDATION_COUNT,
                                       PERSONAL_SPACE_SHARE_COUNT,
                                       PERSONAL_SPACE_ATTACHMENT,
                                       PERSONAL_SPACE_IS_SHARED,
                                       PERSONAL_SPACE_IS_HOME,
                                       PERSONAL_SPACE_STATUS,
                                       PERSONAL_SPACE_SPECIAL_EMO,
                                       PERSONAL_SPACE_MESSAGE_TYPE,
                                       PERSONAL_SPACE_EXTEND_INFO,
                                       nil];
        [self setMap:TABLE_NAME_PERSONAL_SPACE Value:personalSpaceTable];
        
        NSArray *photoWall = [NSArray arrayWithObjects:PHOTO_WALL_ID,
                              PHOTO_WALL_PUBLISHER,
                              PHOTO_WALL_SUB_URL,
                              PHOTO_WALL_URL,
                              PHOTO_WALL_TIME,
                              PHOTO_WALL_STATUS,    nil];
        [self setMap:TABLE_NAME_PHOTO_WALL Value:photoWall];
        
        
        NSArray *spaceComments = [NSArray arrayWithObjects:SPACE_COMMENTS_ID,
                                  SPACE_COMMENTS_MESSAGE_ID,
                                  SPACE_COMMENTS_CONTENT_MESSAGE,
                                  SPACE_COMMENTS_AVATAR,
                                  SPACE_COMMENTS_PUBLISHER,
                                  SPACE_COMMENTS_NAME,
                                  SPACE_COMMENTS_TIME ,
                                  SPACE_COMMENTS_ATTACHMENT,
                                  SPACE_COMMENTS_STATUS     ,
                                  SPACE_COMMENTS_SPECIAL_EMO,nil    ];
        [self setMap:TABLE_NAME_SPACE_COMMENTS Value:spaceComments];
        
        NSArray *campusSpace = [NSArray arrayWithObjects:
                                CAMPUS_SPACE_ID,
                                CAMPUS_SPACE_OWNER,
                                CAMPUS_SPACE_CONTENT,
                                CAMPUS_SPACE_TIME,
                                CAMPUS_SPACE_UPDATE,
                                CAMPUS_SPACE_COMMENT_COUNT,
                                CAMPUS_SPACE_COMMENDATION_COUNT,
                                CAMPUS_SPACE_SHARE_COUNT,
                                CAMPUS_SPACE_ATTACHMENT,
                                CAMPUS_SPACE_IS_SHARED,
                                CAMPUS_SPACE_STATUS,
                                CAMPUS_SPACE_PUBLISHER,
                                CAMPUS_SPACE_NAME,
                                CAMPUS_SPACE_AVATAR,
                                CAMPUS_SPACE_SPECIAL_EMO,
                                CAMPUS_SPACE_DEPART_NAME,
                                CAMPUS_SPACE_SCHOOL_NAME,
                                nil];
        [self setMap:TABLE_NAME_CAMPUS_SPACE Value:campusSpace];
        
        
        NSArray *friend = [NSArray arrayWithObjects:FRIEND_ID,
                           FRIEND_AVATAR,
                           FRIEND_FRIEND,
                           FRIEND_MOBILE,
                           FRIEND_NAME   ,
                           FRIEND_UPDATE  ,
                           FRIEND_FSTATE  ,
                           FRIEND_USTATE  ,
                           FRIEND_USER    ,
                           FRIEND_STATUS, nil];
        [self setMap:TABLE_NAME_FRIENDS Value:friend];
        
        NSArray *relation = [NSArray arrayWithObjects:RELATION_ID,
                             RELATION_AVATAR,
                             RELATION_NAME,
                             RELATION_UPDATE,
                             RELATION_STATE   ,
                             RELATION_USER_ID  ,
                             RELATION_OWNER  ,
                             RELATION_STATUS,
                             RELATION_COUNT,
                             RELATION_ALL_CREDIT, nil];
        [self setMap:TABLE_NAME_RELATION Value:relation];
        
        NSArray *concernedSchool = [NSArray arrayWithObjects:
                                    CONCERNED_SCHOOL_USER_ID,
                                    CONCERNED_SCHOOL_GROUP_ID,
                                    CONCERNED_SCHOOL_SCHOOL_NAME,
                                    CONCERNED_SCHOOL_STUDENT_COUNT,
                                    CONCERNED_SCHOOL_PROVINCE_NAME,
                                    CONCERNED_SCHOOL_MESSAGE_COUNT,
                                    CONCERNED_SCHOOL_TYPE,
                                    CONCERNED_SCHOOL_FIELD, nil];
        [self setMap:TABLE_NAME_CONCERNED_SCHOOL Value:concernedSchool];
        
        
        
        NSArray *activity = [NSArray arrayWithObjects:
                             ACTIVITY_ID ,
                             ACTIVITY_NAME  ,
                             ACTIVITY_ADDRESS  ,
                             ACTIVITY_SCHOOL_GROUP_ID ,
                             ACTIVITY_GROUP_ID ,
                             ACTIVITY_DESCRIPTION   ,
                             ACTIVITY_TYPE  ,
                             ACTIVITY_LOGO ,
                             ACTIVITY_START_TIME ,
                             ACTIVITY_END_TIME  ,
                             ACTIVITY_OUT_TIME  ,
                             ACTIVITY_ENTERPRISE_ID  ,
                             ACTIVITY_TIME   ,
                             ACTIVITY_UPDATE_TIME ,
                             ACTIVITY_OWNER_AVATAR  ,
                             ACTIVITY_OWNER_ENTERPRISEID,
                             ACTIVITY_OWNER_ID ,
                             ACTIVITY_OWNER_NAME,
                             ACTIVITY_PAGE_LOGO  ,
                             ACTIVITY_USER_SUM    ,
                             ACTIVITY_TELECOM_FLAG ,
                             ACTIVITY_DESABLED,
                             ACTIVITY_ENTER_FLAG,
                             ACTIVITY_STATUS,
                             ACTIVITY_ATTRIBUTE,
                             ACTIVITY_TEMPLATE,
                             ACTIVITY_MAJOR_TYPE_NAME,
                             ACTIVITY_INTERACTING_END,
                             ACTIVITY_HOME_PAGE,
                             ACTIVITY_STATE,
                             ACTIVITY_ONLY_SCHOOL,
                             ACTIVITY_PARISE_FLAG,nil];
        [self setMap:TABLE_NAME_ACTIVITY Value:activity];
        
        
        NSArray *activityType =[NSArray arrayWithObjects:
                                ACTIVITY_TYPE_ID ,
                                ACTIVITY_TYPE_COUNT ,            
                                ACTIVITY_TYPE_NAME,              
                                ACTIVITY_TYPE_CRENTD_USER_ID ,   
                                ACTIVITY_TYPE_GROUP_ID ,         
                                ACTIVITY_TYPE_SCHOOL_GROUP_ID  , 
                                nil];
        [self setMap:TABLE_NAME_ACTIVITY_TYPE Value:activityType];
        
        NSArray *activityJoin = [NSArray arrayWithObjects:
                                 ACTIVITY_JOIN_ACTIVITI_USER_ID     
                                 ACTIVITY_JOIN_ACTIVITI_ACTIVITY_ID 
                                 ACTIVITY_JOIN_ACTIVITI_ISJOIN      , nil];
        [self setMap:TABLE_NAME_ACTIVITY_JOIN Value:activityJoin];
        
        NSArray *syncfile = [NSArray arrayWithObjects:
                             SYNC_FILE_ID,
                             SYNC_FILE_ENTERPRISEID,
                             SYNC_FILE_DISABLE,
                             SYNC_FILE_LOCALDATE,
                             SYNC_FILE_LOCALURI,
                             SYNC_FILE_METADATA,
                             SYNC_FILE_NAME,
                             SYNC_FILE_PARENTID,
                             SYNC_FILE_TYPE,
                             SYNC_FILE_UPDATETIME  ,
                             SYNC_FILE_TIME    ,
                             SYNC_FILE_URI     ,
                             SYNC_FILE_SUBURI   ,
                             SYNC_FILE_USER     ,
                             SYNC_FILE_STATUS  ,
                             SYNC_FILE_LOCATE   ,
                             SYNC_FILE_FOLDER_TYPE ,
                             EXTENDS_1         ,
                             EXTENDS_2         ,
                             EXTENDS_3             , nil];
        [self setMap:TABLE_NAME_SYNC_FILES Value:syncfile];
        
        
        NSArray *newsFile = [NSArray arrayWithObjects: NEWS_ENTERTAINMENT_ID,
                             NEWS_ENTERTAINMENT_CID,
                             NEWS_ENTERTAINMENT_IMAGE,
                             NEWS_ENTERTAINMENT_MD_H,
                             NEWS_ENTERTAINMENT_MD_W,
                             NEWS_ENTERTAINMENT_SM_H,
                             NEWS_ENTERTAINMENT_SM_W,
                             NEWS_ENTERTAINMENT_SUMMARY,
                             NEWS_ENTERTAINMENT_TIME,
                             NEWS_ENTERTAINMENT_TITLE,
                             NEWS_ENTERTAINMENT_SHOW_TYPE,
                             NEWS_ENTERTAINMENT_COMMENDATION_COUNT,
                             NEWS_ENTERTAINMENT_COMMENT_COUNT,
                             NEWS_ENTERTAINMENT_SHARE_COUNT,
                             EXTENDS_1,
                             EXTENDS_2,
                             EXTENDS_3,                  nil];
        [self setMap:TABLE_NAME_NEWS_ENTERTAINMENT Value:newsFile];
        
        NSArray *newsCommentFile = [NSArray arrayWithObjects:
                             NEWS_COMMENTS_ID,
                             NEWS_COMMENTS_MESSAGE_ID,
                             NEWS_COMMENTS_CONTENT_MESSAGE,
                             NEWS_COMMENTS_AVATAR,
                             NEWS_COMMENTS_PUBLISHER,
                             NEWS_COMMENTS_NAME,
                             NEWS_COMMENTS_TIME,
                             NEWS_COMMENTS_ATTACHMENT,
                             NEWS_COMMENTS_STATUS,
                             NEWS_COMMENTS_SPECIAL_EMO,
                             EXTENDS_1,
                             EXTENDS_2,
                             EXTENDS_3,nil];
        [self setMap:TABLE_NAME_NEWS_COMMENTS Value:newsCommentFile];
        
        NSArray *groupSpaceFile = [NSArray arrayWithObjects:
                                    GROUP_SPACE_MESSAGE_ID,
                                    GROUP_SPACE_CONTENT_MESSAGE,
                                    GROUP_SPACE_AVATAR,
                                    GROUP_SPACE_PUBLISHER,
                                    GROUP_SPACE_NAME,
                                    GROUP_SPACE_TIME,
                                    GROUP_SPACE_ATTACHMENT,
                                    GROUP_SPACE_SPECIAL_EMO,
                                    GROUP_SPACE_STATUS,
                                   GROUP_SPACE_COMMENT_COUNT,
                                   GROUP_SPACE_COMMENDATION_COUNT,
                                   GROUP_SPACE_SHARE_COUNT,
                                   GROUP_SPACE_DELETE,
                                   GROUP_SPACE_ENTERTAINMENT_ID,
                                   GROUP_SPACE_MESSAGE_TYPE,
                                   GROUP_SPACE_OWNER,
                                   GROUP_SPACE_SPACE_TYPE,
                                   
                                    EXTENDS_1,
                                    EXTENDS_2,
                                    EXTENDS_3,nil];
        [self setMap:TABLE_NAME_GROUP_SPACE Value:groupSpaceFile];
        
        
        NSArray *md5 = [NSArray arrayWithObjects:FILE_MD5_ID,
                        FILE_MD5_MD5,
                        FILE_MD5_LOCATE, FILE_MD5_LOCALURL,
                        nil];
        [self setMap:TABLE_NAME_SYNCFILE_MD5 Value:md5];
        
        NSArray *parttimeJob = [NSArray arrayWithObjects:
                                PARTTIME_JOB_INFO_ID,
                                PARTTIME_JOB_TITLE,
                                PARTTIME_JOB_CITY,
                                PARTTIME_JOB_SUMMARY,
                                PARTTIME_JOB_ADDTIME,
                                PARTTIME_JOB_COMPANY_NAME,
                                PARTTIME_JOB_COMPANY_INS,
                                PARTTIME_JOB_COMPANY_TYPE,
                                PARTTIME_JOB_COMPANY_SIZE,
                                PARTTIME_JOB_JOB_NAME,
                                PARTTIME_JOB_SALARY,
                                PARTTIME_JOB_EDUCATION,
                                PARTTIME_JOB_WORK_EXP,
                                PARTTIME_JOB_RECRUIT_COUNT,
                                PARTTIME_JOB_WORK_PLACE,
                                PARTTIME_JOB_WORK_TIME,
                                PARTTIME_JOB_JOB_DES,
                                PARTTIME_JOB_CONTACT,
                                PARTTIME_JOB_CONTACT_NUMBER,
                                PARTTIME_JOB_COMPANY_ADDRESS,
                                PARTTIME_JOB_COMPANY_INTRODUCE,
                                PARTTIME_JOB_PUBTIME,
                                nil];
        [self setMap:TABLE_NAME_PARTTIME_JOB Value:parttimeJob];
        
        NSArray *notice = [NSArray arrayWithObjects:
                           TABLE_NAME_NOTICE_NOTICE_ID,
                           TABLE_NAME_NOTICE_USER_ID,
                           TABLE_NAME_NOTICE_NAME,
                           TABLE_NAME_NOTICE_AVATAR,
                           TABLE_NAME_NOTICE_ENTERPRISE_ID,
                           TABLE_NAME_NOTICE_TIME,
                           TABLE_NAME_NOTICE_MESSAGE,
                           TABLE_NAME_NOTICE_TYPE,
                           TABLE_NAME_NOTICE_READ,
                           TABLE_NAME_NOTICE_MESSAGEID,
                           TABLE_NAME_NOTICE_MESSAGE_OBJ_TYPE,
                           TABLE_NAME_NOTICE_OBJECT_JSON,
                           TABLE_NAME_NOTICE_COMMENDATION_COUNT,
                           TABLE_NAME_NOTICE_COMMENT_COUNT,
                           TABLE_NAME_NOTICE_SHARE_COUNT,
                           TABLE_NAME_NOTICE_CURRENTUSERID,
                           nil];
        [self setMap:TABLE_NAME_NOTICE Value:notice];
        
        
        NSArray *group = [NSArray arrayWithObjects:GROUP_ID,
                          GROUP_ENTERPRISE_ID,
                          GROUP_ATTRUBUTE,
                          GROUP_DESCRIPTION,
                          GROUP_DISABLED,
                          GROUP_LOGO,
                          GROUP_NAME,
                          GROUP_OWNER_ID,
                          GROUP_TAGS    ,
                          GROUP_TIME   ,
                          GROUP_USER_ID      ,
                          GROUP_TYPE          ,
                          GROUP_USERID        ,
                          GROUP_MANAGER_AVATAR,
                          GROUP_MANAGER_ID    ,
                          GROUP_MANAGER_NAME  ,
                          GROUP_STATUS,
                          GROUP_COVER,
                          GROUP_SIGNATURE,
                          GROUP_MEMBER_COUNT,
                          GROUP_MAX_MEMBER,
                          nil];
        [self setMap:TABLE_NAME_GROUPS Value:group];
        
        
        NSArray *groupChat = [NSArray arrayWithObjects:GROUP_CHAT_ID,
                              GROUP_CHAT_CONTENT,
                              GROUP_CHAT_DELETE,
                              GROUP_CHAT_OWNER,
                              GROUP_CHAT_TIME,
                              GROUP_CHAT_ATTACHEMENT ,
                              GROUP_CHAT_AVATAR      ,
                              GROUP_CHAT_PUBLISHER   ,
                              GROUP_CHAT_NAME        ,
                              GROUP_CHAT_STATUS      ,
                              GROUP_CHAT_SPECIAL_EMO ,nil];
        [self setMap:TABLE_NAME_GROUPS_CHAT Value:groupChat];
        
        
        NSArray *groupMember = [NSArray arrayWithObjects:GROUP_MEMBER_ID,
                                GROUP_MEMBER_GROUP_ID,
                                GROUP_MEMBER_PRIVILEGE,
                                GROUP_MEMBER_AVATAR,
                                GROUP_MEMBER_USERID,
                                GROUP_MEMBER_NAME,
                                GROUP_MEMBER_STATUS, nil];
        [self setMap:TABLE_NAME_GROUP_MEMBERS Value:groupMember];
        
        
        
        NSArray *friendNews = [NSArray arrayWithObjects:FRIEND_NEWS_ID,
                               FRIEND_NEWS_TYPE,
                               FRIEND_NEWS_UPDATE_TIME,
                               FRIEND_NEWS_TIME,
                               FRIEND_NEWS_NAME,
                               FRIEND_NEWS_PUBLISHER,
                               FRIEND_NEWS_AVATAR,
                               FRIEND_NEWS_OBJECTDATA,
                               FRIEND_NEWS_USERID       ,
                               FRIEND_NEWS_COMMENT_COUNT  ,
                               FRIEND_NEWS_COMMENDATION_COUNT,
                               FRIEND_NEWS_SHARE_COUNT  ,nil     ];
        [self setMap:TABLE_NAME_FRIEND_NEWS Value:friendNews];
        
        
        NSArray *groupNotice = [NSArray arrayWithObjects:GROUP_NOTICE_NOTICE_ID,
                                GROUP_NOTICE_USER_ID,
                                GROUP_NOTICE_NAME,
                                GROUP_NOTICE_AVATAR,
                                GROUP_NOTICE_TIME,
                                GROUP_NOTICE_MESSAGE,
                                GROUP_NOTICE_TYPE,
                                GROUP_NOTICE_READ       ,
                                GROUP_NOTICE_LOGO       ,
                                GROUP_NOTICE_GROUP_NAME ,
                                GROUP_NOTICE_GROUP_OLD_NAME,
                                GROUP_NOTICE_GROUP_ID   ,
                                GROUP_NOTICE_GROUP_TYPE ,
                                GROUP_NOTICE_USERID  ,
                                GROUP_NOTICE_STATUS   , nil];
        [self setMap:TABLE_NAME_GROUP_NOTICE Value:groupNotice];
        
        
        
        
        NSArray *groupCount = [NSArray arrayWithObjects:GROUP_COUNT_ID,
                               GROUP_COUNT_COUNT,
                               GROUP_COUNT_USERID,
                               GROUP_COUNT_ISENTER,nil];
        [self setMap:TABLE_NAME_GROUPS_COUNT Value:groupCount];
        
        
        NSArray *creditsAction = [NSArray arrayWithObjects: CREDITS_ACTION_ID,
                                  CREDITS_ACTION_ADDMAX,
                                  CREDITS_ACTION_ADDMIN,
                                  CREDITS_ACTION_TYPE,
                                  CREDITS_ACTION_DECMIN,
                                  CREDITS_ACTION_DECMAX, nil];
        [self setMap:TABLE_NAME_CREDITS_ACTION Value:creditsAction];
        
        
        
        NSArray *Goods = [NSArray arrayWithObjects:GOOD_ID,
                            GOOD_NAME,
                            GOOD_TYPE,GOOD_SRC,GOOD_DISABLED,GOOD_USERID,GOOD_COUNT, nil];
        [self setMap:TABLE_NAME_GOODS Value:Goods];
        
        NSArray *inviteRecords = [NSArray arrayWithObjects:
                                  INVITE_RECORD_MOBILE,
                                  INVITE_RECORD_COUNT,
                                  INVITE_RECORD_MONEY,
                                  INVITE_RECORD_RECEIVE,
                                  INVITE_RECORD_AVATAR,
                                  INVITE_RECORD_USER_ID,
                                  INVITE_RECORD_NAME,
                                  INVITE_RECORD_STATUS,
                                  INVITE_RECORD_CURRENTUSER,nil];
        [self setMap:TABLE_NAME_INVITE_RECORD Value:inviteRecords];
        
        
        NSArray *smsStatus = [NSArray arrayWithObjects:
                              SMS_MOBILE,
                              SMS_USER_ID,
                              SMS_ACCEPT,
                              SMS_TIME,
                              SMS_CURRENTUSERID,
                              SMS_STATUS,nil];
        [self setMap:TABLE_NAME_SMS_STATUS Value:smsStatus];
        
        NSArray *competeComments = [NSArray arrayWithObjects:
                                    COMPETE_COMMENTS_ID,
                                    COMPETE_COMMENTS_COMPETE_ID,
                                    COMPETE_COMMENTS_CONTENT_MESSAGE,
                                    COMPETE_COMMENTS_AVATAR,
                                    COMPETE_COMMENTS_NAME,
                                    COMPETE_COMMENTS_PUBLISHER,
                                    COMPETE_COMMENTS_TIME,
                                    COMPETE_COMMENTS_ATTACHMENT,
                                    COMPETE_COMMENTS_STATUS,
                                    COMPETE_COMMENTS_SPECIAL_EMO,
                                    nil];
        [self setMap:TABLE_NAME_COMPETE_COMMENTS Value:competeComments];
        
        
        
        NSArray *gifts = [NSArray arrayWithObjects:
                                          GIFT_ID,
                                          GIFT_ITEM_ID,
                                          GIFT_SRC,
                                          GIFT_TYPE,
                                          GIFT_MESSAGE      ,
                                          GIFT_OWNER      ,
                                          GIFT_SENDER_ID    ,
                                          GIFT_SENDER_AVATAR,
                                          GIFT_SENDER_NAME,
                                          GIFT_NAME,
                                    nil];
        [self setMap:TABLE_NAME_RECEIVED_GIFT Value:gifts];
        
        
    }
    return self;
}

-(void)setMap:(NSString*) tableName Value:(NSArray *)value
{
    
    NSString *columns = @"";
    NSString *dicColumns = @"";
    for(NSString *string in value)
    {
        columns = [columns stringByAppendingFormat:@"%@,",string];
        dicColumns = [dicColumns stringByAppendingFormat:@":%@,",string];
    }
    columns = [columns substringToIndex:[columns length] -1];
    dicColumns = [dicColumns substringToIndex:[dicColumns length]-1];
    
    [_TablesMap setValue:value forKey:tableName];
    [_TablesInsertSQLMap setValue:columns forKey:tableName];
    [_TablesInsertDicMap setValue:dicColumns forKey:tableName];
}


-(void)dealloc
{
    [_TablesMap release];
    [_TablesInsertSQLMap release];
    [_TablesInsertDicMap release];
    [super dealloc];
}



@end
