//
//  DatabaseConstants.h
//  fmdbtest
//
//  Created by hh k on 12-9-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef fmdbtest_DatabaseConstants_h
#define fmdbtest_DatabaseConstants_h


	
#define DATABASE_VERSION  0


#pragma mark TableName
#define DATABASE_NAME  @"db_campus_cloud.db"
    	
#define TABLE_NAME_ACCOUNT  @"_account"
#define TABLE_NAME_STUDENT  @"_student"
#define TABLE_NAME_PROVINCE @"_province"
#define TABLE_NAME_COLLEGE  @"_college"
#define TABLE_NAME_DEPARTMENT @"_department"
#define TABLE_NAME_CITY @"_city"
#define TABLE_NAME_ACTIVITY  @"_activity"
#define TABLE_NAME_ACTIVITY_TYPE @"_activity_type"
#define TABLE_NAME_ACTIVITY_JOIN    @"_activity_join" 

#define TABLE_NAME_FRIENDS  @"_friends"
#define TABLE_NAME_RELATION  @"_relation"

#define TABLE_NAME_CONTACTS  @"_contacts"
#define TABLE_NAME_USER_PROFILES  @"_user_profiles"

#define TABLE_NAME_PHONE_NUMBERS  @"_phone_numbers"
#define TABLE_NAME_NOTIFICATIONS  @"_notifications"
#define TABLE_NAME_CONVERSATIONS  @"_conversations"
#define TABLE_NAME_PERSONAL_MESSAGES  @"_personal_messages"
#define TABLE_NAME_PERSONAL_MESSAGES_SMS @"_personal_messages_sms"
#define TABLE_NAME_SMS_STATUS    @"_sms_status"
#define TABLE_NAME_PERSONAL_SPACE  @"_space_personal"
#define TABLE_NAME_SPACE_COMMENTS  @"_space_comments"
#define TABLE_NAME_NEWS_COMMENTS  @"_news_comments"
#define TABLE_NAME_COMPETE_COMMENTS  @"_compete_comments"
#define TABLE_NAME_CAMPUS_SPACE    @"_space_campus"
#define TABLE_NAME_SYNC_FILES  @"_sync_files"
#define TABLE_NAME_SYNC_MD5    @"_sync_files_md5"
#define TABLE_NAME_GROUPS  @"_groups"
#define TABLE_NAME_GROUPS_CHAT      @"_groups_chat"
#define TABLE_NAME_GROUP_MEMBERS  @"_group_members"
#define TABLE_NAME_SETTINGS  @"_settings"
#define TABLE_NAME_SYNC_TIMES  @"_sync_times"
#define TABLE_NAME_UPLOADS  @"_uploads"
#define TABLE_NAME_PUSH_CALL_LOG  @"_push_call_log"

#define TABLE_NAME_ENTERPRISES  @"_enterprises"
#define TABLE_NAME_DEPARTMENTS  @"_departments"
#define TABLE_NAME_BLOG_FOLLOWS  @"_follows"
#define TABLE_NAME_MEETINGS  @"_meetings"
#define TABLE_NAME_MEETING_ROOMS  @"_meeting_rooms"
#define TABLE_NAME_MEETING_ATTENDANTS  @"_meeting_attendants"
#define TABLE_NAME_CUSTOMERS  @"_customers"
#define TABLE_NAME_CUSTOMER_BUSINESS  @"_customer_business"
#define TABLE_NAME_SPACE_HOT_SCORE  @"_space_hot_score"

#define TABLE_NAME_NEWS_ENTERTAINMENT  @"_entertainment"
#define TABLE_NAME_PARTTIME_JOB        @"_parttime_job"
#define TABLE_NAME_GROUP_SPACE         @"_group_space"

// campus cloud.
#define TABLE_NAME_PROVINCE  @"_province"
#define TABLE_NAME_SCHOOL  @"_school"
#define TABLE_NAME_FACULTY  @"_faculty"
#define TABLE_NAME_STUDENT  @"_student"

#define TABLE_NAME_SECRET_CRUSH  @"_secret_crush"
#define TABLE_NAME_PROPOSERS  @"_proposers"
#define TABLE_NAME_INFORMATION_SETTING  @"_information_setting"
#define TABLE_NAME_PHOTO_WALL       @"_photo_wall"

// tmp Table
#define TABLE_NAME_GROUPS_TMP  @"_groups_tmp"

// group count
#define TABLE_NAME_GROUPS_COUNT @"_groups_count"

#define TABLE_NAME_INFORMATION  @"_information"
#define TABLE_NAME_PARTTIME_JOB  @"_parttime_job"
#define TABLE_NAME_WATERFALLS  @"_waterfall"
//visitor table
#define TABLE_NAME_VISITOR  @"_visitor"

//concerned school Table
#define TABLE_NAME_CONCERNED_SCHOOL @"_concerned_school"

//notice
#define TABLE_NAME_NOTICE @"_notice"
#define TABLE_NAME_GROUP_NOTICE @"_group_notice"
#define TABLE_NAME_FRIEND_NEWS  @"_friend_news"


//credtis action
#define TABLE_NAME_CREDITS_ACTION @"_credits_action"
#define TABLE_NAME_GOODS       @"_goods"

//gift
#define TABLE_NAME_RECEIVED_GIFT   @"_received_gift"


#define TABLE_NAME_INVITE_RECORD @"_invite_record"

#define EXTENDS_1   @"_extend1"
#define EXTENDS_2   @"_extend2"
#define EXTENDS_3   @"_extend3"

#define USERID      @"_userId"


#define SPECIAL_EMO @"_special_emo"


#pragma mark Account
#define ACCOUNT_USER_ID     @""TABLE_NAME_ACCOUNT"_id"
#define ACCOUNT_USER_MOBILE @""TABLE_NAME_ACCOUNT"_mobile"
#define ACCOUNT_LOGIN_TIME  @""TABLE_NAME_ACCOUNT"_loginTime"
#define ACCOUNT_PASSWORD    @""TABLE_NAME_ACCOUNT"_password"
#define ACCOUNT_ISAUTOLOGIN @""TABLE_NAME_ACCOUNT"_isAutoLogin"
#define CREATE_TABLE_ACCOUNT @"CREATE TABLE " TABLE_NAME_ACCOUNT                                            \
                                "("                                                                         \
                                ACCOUNT_USER_ID                 " TEXT PRIMARY KEY,"                        \
                                ACCOUNT_USER_MOBILE             " TEXT,"                                    \
                                ACCOUNT_LOGIN_TIME              " TEXT,"                                    \
                                ACCOUNT_ISAUTOLOGIN             " TEXT,"                                    \
                                ACCOUNT_PASSWORD                " TEXT,"                                    \
                                EXTENDS_1                       " TEXT,"                                    \
                                EXTENDS_2                       " TEXT,"                                    \
                                EXTENDS_3                       " TEXT"                                     \
                                ")"




#pragma mark PM
#define PM_ID           @""TABLE_NAME_PERSONAL_MESSAGES"_message"
#define PM_TYPE         @""TABLE_NAME_PERSONAL_MESSAGES"_message_type"
#define PM_CONTENT_TYPE @""TABLE_NAME_PERSONAL_MESSAGES"_content_type"
#define PM_TEXT         @""TABLE_NAME_PERSONAL_MESSAGES"_text"
#define PM_DELETE       @""TABLE_NAME_PERSONAL_MESSAGES"_delete"
#define PM_DIRECTION    @""TABLE_NAME_PERSONAL_MESSAGES"_dir"
#define PM_OTHER_ID     @""TABLE_NAME_PERSONAL_MESSAGES"_other"
#define PM_IS_READ      @""TABLE_NAME_PERSONAL_MESSAGES"_read"
#define PM_ATTACHEMENT  @""TABLE_NAME_PERSONAL_MESSAGES"_attachment"
#define PM_TIME         @""TABLE_NAME_PERSONAL_MESSAGES"_time"
#define PM_USERID       @""TABLE_NAME_PERSONAL_MESSAGES"_userId"
#define PM_MOBILE       @""TABLE_NAME_PERSONAL_MESSAGES"_mobile"
#define PM_STATUS       @""TABLE_NAME_PERSONAL_MESSAGES"_status"
#define PM_SPECIAL_EMO  @""TABLE_NAME_PERSONAL_MESSAGES""SPECIAL_EMO


#define CREATE_TABLE_PM @"CREATE TABLE " TABLE_NAME_PERSONAL_MESSAGES                                       \
                                "("                                                                         \
                                    PM_ID                       " TEXT PRIMARY KEY,"                        \
                                    PM_TYPE                     " TEXT,"                                    \
                                    PM_CONTENT_TYPE             " TEXT,"                                    \
                                    PM_TEXT                     " TEXT,"                                    \
                                    PM_DELETE                   " TEXT,"                                    \
                                    PM_DIRECTION                " TEXT,"                                    \
                                    PM_OTHER_ID                 " TEXT,"                                    \
                                    PM_IS_READ                  " TEXT,"                                    \
                                    PM_ATTACHEMENT                 " TEXT,"                                    \
                                    PM_TIME                     " TEXT,"                                     \
                                    PM_USERID                   " TEXT,"                                    \
                                    PM_MOBILE                   " TEXT,"                                    \
                                    PM_STATUS                   " TEXT,"                                     \
                                    PM_SPECIAL_EMO              " TEXT,"                                        \
                                    EXTENDS_1                       " TEXT,"                                    \
                                    EXTENDS_2                       " TEXT,"                                    \
                                    EXTENDS_3                       " TEXT"                                     \
                                ");"
#define CREATE_TABLE_PM_INDEX @"CREATE index pm_otherId_index on "TABLE_NAME_PERSONAL_MESSAGES"("PM_OTHER_ID");"



#pragma mark PMSMS
#define PMSMS_ID           @""TABLE_NAME_PERSONAL_MESSAGES_SMS"_message"
#define PMSMS_TYPE         @""TABLE_NAME_PERSONAL_MESSAGES_SMS"_message_type"
#define PMSMS_CONTENT_TYPE @""TABLE_NAME_PERSONAL_MESSAGES_SMS"_content_type"
#define PMSMS_TEXT         @""TABLE_NAME_PERSONAL_MESSAGES_SMS"_text"
#define PMSMS_DELETE       @""TABLE_NAME_PERSONAL_MESSAGES_SMS"_delete"
#define PMSMS_DIRECTION    @""TABLE_NAME_PERSONAL_MESSAGES_SMS"_dir"
#define PMSMS_OTHER_ID     @""TABLE_NAME_PERSONAL_MESSAGES_SMS"_other"
#define PMSMS_IS_READ      @""TABLE_NAME_PERSONAL_MESSAGES_SMS"_read"
#define PMSMS_ATTACHEMENT  @""TABLE_NAME_PERSONAL_MESSAGES_SMS"_attachment"
#define PMSMS_TIME         @""TABLE_NAME_PERSONAL_MESSAGES_SMS"_time"
#define PMSMS_USERID       @""TABLE_NAME_PERSONAL_MESSAGES_SMS"_userId"
#define PMSMS_MOBLEL       @""TABLE_NAME_PERSONAL_MESSAGES_SMS"_mobile"
#define PMSMS_STATUS       @""TABLE_NAME_PERSONAL_MESSAGES_SMS"_status"
#define PMSMS_SPECIAL_EMO  @""TABLE_NAME_PERSONAL_MESSAGES_SMS""SPECIAL_EMO


#define CREATE_TABLE_PMSMS @"CREATE TABLE " TABLE_NAME_PERSONAL_MESSAGES_SMS                                       \
"("                                                                         \
PMSMS_ID                       " TEXT PRIMARY KEY,"                        \
PMSMS_TYPE                     " TEXT,"                                    \
PMSMS_CONTENT_TYPE             " TEXT,"                                    \
PMSMS_TEXT                     " TEXT,"                                    \
PMSMS_DELETE                   " TEXT,"                                    \
PMSMS_DIRECTION                " TEXT,"                                    \
PMSMS_OTHER_ID                 " TEXT,"                                    \
PMSMS_IS_READ                  " TEXT,"                                    \
PMSMS_ATTACHEMENT                 " TEXT,"                                    \
PMSMS_TIME                     " TEXT,"                                     \
PMSMS_USERID                   " TEXT,"                                    \
PMSMS_MOBLEL                   " TEXT,"                                     \
PMSMS_STATUS                   " TEXT,"                                     \
PMSMS_SPECIAL_EMO              " TEXT,"                                        \
EXTENDS_1                       " TEXT,"                                    \
EXTENDS_2                       " TEXT,"                                    \
EXTENDS_3                       " TEXT"                                     \
");"
#define CREATE_TABLE_PMSMS_INDEX @"CREATE index pm_otherId_index on "TABLE_NAME_PERSONAL_MESSAGES_SMS"("PMSMS_OTHER_ID");"



//SMS status
#pragma mark SMS STATUS
#define SMS_USER_ID           @""TABLE_NAME_SMS_STATUS"_user_id"
#define SMS_MOBILE            @""TABLE_NAME_SMS_STATUS"_mobile"
#define SMS_ACCEPT            @""TABLE_NAME_SMS_STATUS"_accept"
#define SMS_TIME         @""TABLE_NAME_SMS_STATUS"_time"
#define SMS_CURRENTUSERID       @""TABLE_NAME_SMS_STATUS"_current_user_id"
#define SMS_STATUS            @""TABLE_NAME_SMS_STATUS"_status"

#define CREATE_TABLE_SMSSTATUS @"CREATE TABLE " TABLE_NAME_SMS_STATUS                                       \
"("                                                                         \
SMS_MOBILE                       " TEXT, "                        \
SMS_USER_ID                     " TEXT,"                                    \
SMS_ACCEPT                       " TEXT,"                                    \
SMS_TIME                        " TEXT,"                                    \
SMS_CURRENTUSERID                " TEXT,"                                 \
SMS_STATUS                      " TEXT,"                                    \
EXTENDS_1                       " TEXT,"                                    \
EXTENDS_2                       " TEXT,"                                    \
EXTENDS_3                       " TEXT, "                                     \
"PRIMARY KEY ("SMS_MOBILE")"  ");"







#pragma mark photo wall
#define PHOTO_WALL_ID               @""TABLE_NAME_PHOTO_WALL"_message"
#define PHOTO_WALL_PUBLISHER        @""TABLE_NAME_PHOTO_WALL"_publisher"
#define PHOTO_WALL_SUB_URL          @""TABLE_NAME_PHOTO_WALL"_sub_uri"
#define PHOTO_WALL_URL              @""TABLE_NAME_PHOTO_WALL"_uri"
#define PHOTO_WALL_TIME             @""TABLE_NAME_PHOTO_WALL"_time"
#define PHOTO_WALL_STATUS           @""TABLE_NAME_PHOTO_WALL"_status"
#define PHOTO_WALL_ATTACHMENT       @""TABLE_NAME_PHOTO_WALL"_attachment"
#define CREATE_TABLE_PHOTO_WALL @"CREATE TABLE " TABLE_NAME_PHOTO_WALL              \
                                "("                                                 \
                                    PHOTO_WALL_ID           " TEXT PRIMARY KEY,"      \
                                    PHOTO_WALL_PUBLISHER    " TEXT,"                \
                                    PHOTO_WALL_SUB_URL      " TEXT,"                \
                                    PHOTO_WALL_URL          " TEXT,"                \
                                    PHOTO_WALL_TIME         " TEXT,"                \
                                    PHOTO_WALL_STATUS       " INTEGER,"             \
                                    EXTENDS_1                       " TEXT,"                                    \
                                    EXTENDS_2                       " TEXT,"                                    \
                                    EXTENDS_3                       " TEXT"                                     \
                                ")"



////-----------------------------

#pragma mark Student
#define STUDENT_USER_ID @""TABLE_NAME_STUDENT"_user_id"
#define STUDENT_ID   @""TABLE_NAME_STUDENT"_id"
#define STUDENT_NAME   @""TABLE_NAME_STUDENT"_name"
#define STUDENT_AVATAR   @""TABLE_NAME_STUDENT"_avatar"
#define STUDENT_SAVATAR   @""TABLE_NAME_STUDENT"_savatar"
#define STUDENT_UPDATE_TIME   @""TABLE_NAME_STUDENT"_update_time"
#define STUDENT_PRIVILEGE   @""TABLE_NAME_STUDENT"_privilege"
#define STUDENT_DATA   @""TABLE_NAME_STUDENT"_data"
#define STUDENT_PDATA   @""TABLE_NAME_STUDENT"_pdata"
#define STUDENT_FDATA   @""TABLE_NAME_STUDENT"_fdata"
#define STUDENT_GROUP_ID   @""TABLE_NAME_STUDENT"_group_id"
#define STUDENT_DATA_TYPE   @""TABLE_NAME_STUDENT"_data_type"
#define STUDENT_SCHOOL_GROUP_ID   @""TABLE_NAME_STUDENT"_school_group_id"
#define STUDENT_CITY_NAME   @""TABLE_NAME_STUDENT"_city_name"
#define STUDENT_VISIBLE   @""TABLE_NAME_STUDENT"_visible"
#define STUDENT_COVERRESID   @""TABLE_NAME_STUDENT"_coverResId"
#define STUDENT_COVERURL   @""TABLE_NAME_STUDENT"_coverUrl"
#define STUDENT_SCHOOL_LOGO_URL   @""TABLE_NAME_STUDENT"_school_logo_url"
#define STUDENT_TITLE             @""TABLE_NAME_STUDENT"_honorary_title"
#define STUDENT_LEVEL             @""TABLE_NAME_STUDENT"_level"
#define STUDENT_STATUS            @""TABLE_NAME_STUDENT"_status"


#define CREATE_TABLE_STUDENT  @"CREATE TABLE " TABLE_NAME_STUDENT       \
"("                                     \
STUDENT_USER_ID     " TEXT PRIMARY KEY," \
STUDENT_ID          " TEXT,"            \
STUDENT_NAME          " TEXT,"            \
STUDENT_AVATAR          " TEXT,"            \
STUDENT_SAVATAR          " TEXT,"            \
STUDENT_UPDATE_TIME          " TEXT,"            \
STUDENT_PRIVILEGE          " TEXT,"            \
STUDENT_DATA          " TEXT,"            \
STUDENT_PDATA          " TEXT,"            \
STUDENT_FDATA          " TEXT,"            \
STUDENT_GROUP_ID          " TEXT,"            \
STUDENT_DATA_TYPE          " TEXT,"            \
STUDENT_SCHOOL_GROUP_ID          " TEXT,"            \
STUDENT_CITY_NAME          " TEXT,"            \
STUDENT_VISIBLE          " TEXT,"            \
STUDENT_COVERRESID          " TEXT,"            \
STUDENT_COVERURL          " TEXT,"            \
STUDENT_SCHOOL_LOGO_URL          " TEXT,"            \
STUDENT_TITLE                   " TEXT,"            \
STUDENT_LEVEL                   " TEXT,"            \
STUDENT_STATUS                   " TEXT,"            \
EXTENDS_1                       " TEXT,"                                    \
EXTENDS_2                       " TEXT,"                                    \
EXTENDS_3                       " TEXT"                                     \
")"


//---------------------------

#pragma ---province
//-----------------province------
#define PROVINCE_ID         @""TABLE_NAME_PROVINCE"_id"
#define PROVINCE_NAME       @""TABLE_NAME_PROVINCE"_name"
#define PROVINCE_CITY       @""TABLE_NAME_PROVINCE"_provinCity"
#define PROVINCE_CITY_UPDATE_TIME  @""TABLE_NAME_PROVINCE"_cityUpdateTime"
#define PROVINCE_COLLEGE_UPDATE_TIME  @""TABLE_NAME_PROVINCE"_collegeUpdateTime"

#define CREATE_TABLE_PROVINCE @"CREATE TABLE " TABLE_NAME_PROVINCE                                            \
"("                                                                         \
PROVINCE_ID                     " TEXT PRIMARY KEY,"                        \
PROVINCE_NAME                   " TEXT,"                                    \
PROVINCE_CITY                   " TEXT,"                                    \
PROVINCE_CITY_UPDATE_TIME       " TEXT,"     \
PROVINCE_COLLEGE_UPDATE_TIME    " TEXT,"     \
EXTENDS_1                       " TEXT,"                                    \
EXTENDS_2                       " TEXT,"                                    \
EXTENDS_3                       " TEXT"                                     \
")"


//----------------------

#pragma ---college table
//-----------college table ------
#define COLLEGE_ID          @""TABLE_NAME_COLLEGE"_id"
#define COLLEGE_PROVINCE_ID @""TABLE_NAME_COLLEGE"_college_provinceId"
#define COLLEGE_CITY_ID @""TABLE_NAME_COLLEGE"_city_id"
#define COLLEGE_SCHOOL_TYPE @""TABLE_NAME_COLLEGE"_type"
#define COLLEGE_GROUP_ID    @""TABLE_NAME_COLLEGE"_group_id"
#define COLLEGE_NAME        @""TABLE_NAME_COLLEGE"_name"

#define CREATE_TABLE_COLLEGE @"CREATE TABLE " TABLE_NAME_COLLEGE                                            \
"("                                                                         \
COLLEGE_ID                 " TEXT PRIMARY KEY,"                        \
COLLEGE_PROVINCE_ID        "  TEXT,"                                \
COLLEGE_CITY_ID        "  TEXT,"                                \
COLLEGE_SCHOOL_TYPE        "  TEXT,"                                \
COLLEGE_GROUP_ID               " TEXT,"                                    \
COLLEGE_NAME               " TEXT,"                                    \
EXTENDS_1                       " TEXT,"                                    \
EXTENDS_2                       " TEXT,"                                    \
EXTENDS_3                       " TEXT"                                     \
")"

//---------------------------------



#pragma ---city table
//-----------------city-----------
#define CITY_ID          @""TABLE_NAME_CITY"_id"
#define CITY_PROVINCE_ID @""TABLE_NAME_CITY"_city_provinceId"
#define CITY_TIME        @""TABLE_NAME_CITY"_time"
#define CITY_NAME        @""TABLE_NAME_CITY"_name"

#define CREATE_TABLE_CIYT @"CREATE TABLE " TABLE_NAME_CITY                                            \
"("                                                                         \
CITY_ID                 " TEXT PRIMARY KEY,"                        \
CITY_PROVINCE_ID        "  TEXT,"                                \
CITY_TIME               " TEXT,"                                    \
CITY_NAME               " TEXT,"                                    \
EXTENDS_1                       " TEXT,"                                    \
EXTENDS_2                       " TEXT,"                                    \
EXTENDS_3                       " TEXT"                                     \
")"



//-------------------------------


#pragma DEPARTMENT
//------------deapartment ---
#define DEPARTMENT_ID          @""TABLE_NAME_DEPARTMENT"_id"
#define DEPARTMENT_NAME        @""TABLE_NAME_DEPARTMENT"_name"
#define DEPARTMENT_SCHOOL_ID   @""TABLE_NAME_DEPARTMENT"_school_id"

#define CREATE_TABLE_DEPARTMENT @"CREATE TABLE " TABLE_NAME_DEPARTMENT                                            \
"("                                                                         \
DEPARTMENT_ID                 " TEXT PRIMARY KEY,"                        \
DEPARTMENT_NAME               " TEXT,"                                    \
DEPARTMENT_SCHOOL_ID               " TEXT,"                                    \
EXTENDS_1                       " TEXT,"                                    \
EXTENDS_2                       " TEXT,"                                    \
EXTENDS_3                       " TEXT"                                     \
")"

//----------------

#pragma mark friends



#define FRIEND_ID           @""TABLE_NAME_FRIENDS"_id"
#define FRIEND_AVATAR       @""TABLE_NAME_FRIENDS"_avatar"
#define FRIEND_FRIEND       @""TABLE_NAME_FRIENDS"_friend"
#define FRIEND_MOBILE       @""TABLE_NAME_FRIENDS"_mobile"
#define FRIEND_NAME         @""TABLE_NAME_FRIENDS"_name"
#define FRIEND_UPDATE       @""TABLE_NAME_FRIENDS"_update"
#define FRIEND_FSTATE       @""TABLE_NAME_FRIENDS"_fstate"
#define FRIEND_USTATE       @""TABLE_NAME_FRIENDS"_ustate"
#define FRIEND_USER         @""TABLE_NAME_FRIENDS"_user"
#define FRIEND_STATUS       @""TABLE_NAME_FRIENDS"_status"
#define CREATE_TABLE_FRIENDS     @"CREATE TABLE "TABLE_NAME_FRIENDS                   \
                                                "("                                                         \
                                                FRIEND_ID                       " TEXT PRIMARY KEY,"         \
                                                FRIEND_AVATAR                   " TEXT,"                     \
                                                FRIEND_FRIEND                   " TEXT,"                     \
                                                FRIEND_MOBILE                   " TEXT,"                     \
                                                FRIEND_NAME                     " TEXT,"                     \
                                                FRIEND_UPDATE                   " TEXT,"            \
                                                FRIEND_FSTATE                   " TEXT,"            \
                                                FRIEND_USTATE                   " TEXT,"                    \
                                                FRIEND_USER                     " TEXT,"                 \
                                                FRIEND_STATUS                   " TEXT,"                    \
                                                EXTENDS_1                       " TEXT,"                    \
                                                EXTENDS_2                       " TEXT,"                    \
                                                EXTENDS_3                       " TEXT"                     \
                                                ")"

#pragma mark Relation
#define RELATION_ID           @""TABLE_NAME_RELATION"_id"
#define RELATION_AVATAR       @""TABLE_NAME_RELATION"_avatar"
#define RELATION_NAME         @""TABLE_NAME_RELATION"_name"
#define RELATION_UPDATE       @""TABLE_NAME_RELATION"_update"
#define RELATION_STATE        @""TABLE_NAME_RELATION"_state"
#define RELATION_USER_ID       @""TABLE_NAME_RELATION"_user_id"
#define RELATION_OWNER         @""TABLE_NAME_RELATION"_owner"
#define RELATION_STATUS         @""TABLE_NAME_RELATION"_status"

#define RELATION_COUNT       @""TABLE_NAME_RELATION"_count"
#define RELATION_ALL_CREDIT       @""TABLE_NAME_RELATION"_all_credit"

#define CREATE_TABLE_RELATION     @"CREATE TABLE "TABLE_NAME_RELATION                   \
                                "("                                                         \
                                RELATION_ID                       " TEXT PRIMARY KEY,"         \
                                RELATION_AVATAR                   " TEXT,"                     \
                                RELATION_NAME                   " TEXT,"                     \
                                RELATION_UPDATE                   " TEXT,"                     \
                                RELATION_STATE                     " TEXT,"                     \
                                RELATION_USER_ID                   " TEXT,"            \
                                RELATION_OWNER                   " TEXT,"            \
                                RELATION_STATUS                   " INTEGER,"            \
                                RELATION_COUNT                      " TEXT,"              \
                                RELATION_ALL_CREDIT                 " TEXT,"              \
                                EXTENDS_1                       " TEXT,"                    \
                                EXTENDS_2                       " TEXT,"                    \
                                EXTENDS_3                       " TEXT"                     \
                                ")"



#pragma mark Space comments
#define SPACE_COMMENTS_ID               @""TABLE_NAME_SPACE_COMMENTS"_id"
#define SPACE_COMMENTS_MESSAGE_ID       @""TABLE_NAME_SPACE_COMMENTS"_message"
#define SPACE_COMMENTS_CONTENT_MESSAGE  @""TABLE_NAME_SPACE_COMMENTS"_content_message"
#define SPACE_COMMENTS_AVATAR           @""TABLE_NAME_SPACE_COMMENTS"_avatar"
#define SPACE_COMMENTS_NAME             @""TABLE_NAME_SPACE_COMMENTS"_name"
#define SPACE_COMMENTS_PUBLISHER        @""TABLE_NAME_SPACE_COMMENTS"_publisher"
#define SPACE_COMMENTS_TIME             @""TABLE_NAME_SPACE_COMMENTS"_time"
#define SPACE_COMMENTS_ATTACHMENT       @""TABLE_NAME_SPACE_COMMENTS"_attachment"
#define SPACE_COMMENTS_STATUS           @""TABLE_NAME_SPACE_COMMENTS"_status"
#define SPACE_COMMENTS_SPECIAL_EMO      @""TABLE_NAME_SPACE_COMMENTS""SPECIAL_EMO
#define CREATE_TABLE_SPACE_COMMENTS         @"CREATE TABLE "TABLE_NAME_SPACE_COMMENTS                   \
                                            "("                                                         \
                                            SPACE_COMMENTS_ID                       " TEXT PRIMARY KEY,"         \
                                            SPACE_COMMENTS_MESSAGE_ID               " TEXT,"                     \
                                            SPACE_COMMENTS_CONTENT_MESSAGE          " TEXT,"                     \
                                            SPACE_COMMENTS_AVATAR                   " TEXT,"                     \
                                            SPACE_COMMENTS_PUBLISHER                " TEXT,"                     \
                                            SPACE_COMMENTS_NAME                     " TEXT,"            \
                                            SPACE_COMMENTS_TIME                     " TEXT,"            \
                                            SPACE_COMMENTS_ATTACHMENT       " TEXT,"                    \
                                            SPACE_COMMENTS_STATUS           " INTEGER,"                 \
                                            SPACE_COMMENTS_SPECIAL_EMO      " TEXT,"                    \
                                            EXTENDS_1                       " TEXT,"                    \
                                            EXTENDS_2                       " TEXT,"                    \
                                            EXTENDS_3                       " TEXT"                     \
                                            ")"



#pragma mark personal space
#define PERSONAL_SPACE_ID                   @""TABLE_NAME_PERSONAL_SPACE"_message"
#define PERSONAL_SPACE_OWNER                @""TABLE_NAME_PERSONAL_SPACE"_owner"
#define PERSONAL_SPACE_NAME                 @""TABLE_NAME_PERSONAL_SPACE"_name"
#define PERSONAL_SPACE_AVATAR               @""TABLE_NAME_PERSONAL_SPACE"_avatar"
#define PERSONAL_SPACE_CONTENT              @""TABLE_NAME_PERSONAL_SPACE"_content"
#define PERSONAL_SPACE_TIME                 @""TABLE_NAME_PERSONAL_SPACE"_time"
#define PERSONAL_SPACE_UPDATE               @""TABLE_NAME_PERSONAL_SPACE"_update"
#define PERSONAL_SPACE_MONTH                @""TABLE_NAME_PERSONAL_SPACE"_month"
#define PERSONAL_SPACE_COMMENT_COUNT        @""TABLE_NAME_PERSONAL_SPACE"_comment_count"
#define PERSONAL_SPACE_COMMENDATION_COUNT   @""TABLE_NAME_PERSONAL_SPACE"_commendation_count"
#define PERSONAL_SPACE_SHARE_COUNT          @""TABLE_NAME_PERSONAL_SPACE"_share_count"
#define PERSONAL_SPACE_ATTACHMENT           @""TABLE_NAME_PERSONAL_SPACE"_attachment"
#define PERSONAL_SPACE_IS_SHARED            @""TABLE_NAME_PERSONAL_SPACE"_isShared"
#define PERSONAL_SPACE_IS_HOME              @""TABLE_NAME_PERSONAL_SPACE"_home"
#define PERSONAL_SPACE_STATUS               @""TABLE_NAME_PERSONAL_SPACE"_status"
#define PERSONAL_SPACE_SPECIAL_EMO          @""TABLE_NAME_PERSONAL_SPACE""SPECIAL_EMO
#define PERSONAL_SPACE_MESSAGE_TYPE         @""TABLE_NAME_PERSONAL_SPACE"_message_type"
#define PERSONAL_SPACE_EXTEND_INFO          @""TABLE_NAME_PERSONAL_SPACE"_extend_info"

#define CREATE_TABLE_PERSONAL_SPACE         @"CREATE TABLE "TABLE_NAME_PERSONAL_SPACE                   \
                                            "("                                                         \
                                            PERSONAL_SPACE_ID              " TEXT PRIMARY KEY,"         \
                                            PERSONAL_SPACE_OWNER           " TEXT,"                     \
                                            PERSONAL_SPACE_NAME            " TEXT,"                     \
                                            PERSONAL_SPACE_AVATAR          " TEXT,"                     \
                                            PERSONAL_SPACE_CONTENT         " TEXT,"                     \
                                            PERSONAL_SPACE_TIME            " TEXT,"                     \
                                            PERSONAL_SPACE_UPDATE                   " TEXT,"            \
                                            PERSONAL_SPACE_MONTH                    " TEXT,"            \
                                            PERSONAL_SPACE_COMMENT_COUNT            " TEXT,"            \
                                            PERSONAL_SPACE_COMMENDATION_COUNT       " TEXT,"            \
                                            PERSONAL_SPACE_SHARE_COUNT              " TEXT,"            \
                                            PERSONAL_SPACE_ATTACHMENT               " TEXT,"            \
                                            PERSONAL_SPACE_IS_SHARED                " INTEGER,"         \
                                            PERSONAL_SPACE_IS_HOME                  " TEXT,"            \
                                            PERSONAL_SPACE_STATUS                   " INTEGER,"         \
                                            PERSONAL_SPACE_SPECIAL_EMO              " TEXT,"            \
                                            PERSONAL_SPACE_MESSAGE_TYPE             " TEXT,"            \
                                            PERSONAL_SPACE_EXTEND_INFO              " TEXT,"            \
                                            EXTENDS_1                       " TEXT,"                    \
                                            EXTENDS_2                       " TEXT,"                    \
                                            EXTENDS_3                       " TEXT"                     \
                                            ")"

#pragma mark - campus space
#define CAMPUS_SPACE_ID                    @""TABLE_NAME_CAMPUS_SPACE"_message"
#define CAMPUS_SPACE_OWNER                 @""TABLE_NAME_CAMPUS_SPACE"_owner"
#define CAMPUS_SPACE_CONTENT               @""TABLE_NAME_CAMPUS_SPACE"_content"
#define CAMPUS_SPACE_TIME                  @""TABLE_NAME_CAMPUS_SPACE"_time"
#define CAMPUS_SPACE_UPDATE                @""TABLE_NAME_CAMPUS_SPACE"_update"
#define CAMPUS_SPACE_COMMENT_COUNT         @""TABLE_NAME_CAMPUS_SPACE"_comment_count"
#define CAMPUS_SPACE_COMMENDATION_COUNT    @""TABLE_NAME_CAMPUS_SPACE"_commendation_count"
#define CAMPUS_SPACE_SHARE_COUNT           @""TABLE_NAME_CAMPUS_SPACE"_share_count"
#define CAMPUS_SPACE_ATTACHMENT            @""TABLE_NAME_CAMPUS_SPACE"_attachment"
#define CAMPUS_SPACE_IS_SHARED             @""TABLE_NAME_CAMPUS_SPACE"_isShared"
#define CAMPUS_SPACE_STATUS                @""TABLE_NAME_CAMPUS_SPACE"_status"
#define CAMPUS_SPACE_PUBLISHER             @""TABLE_NAME_CAMPUS_SPACE"_publisher"
#define CAMPUS_SPACE_NAME                  @""TABLE_NAME_CAMPUS_SPACE"_name"
#define CAMPUS_SPACE_AVATAR                @""TABLE_NAME_CAMPUS_SPACE"_avatar"
#define CAMPUS_SPACE_DEPART_NAME           @""TABLE_NAME_CAMPUS_SPACE"_depart_name"
#define CAMPUS_SPACE_SCHOOL_NAME           @""TABLE_NAME_CAMPUS_SPACE"_school_name"
#define CAMPUS_SPACE_SPECIAL_EMO           @""TABLE_NAME_CAMPUS_SPACE""SPECIAL_EMO
//useless
//#define CAMPUS_SPACE_SCHOOL_TYPE          @""TABLE_NAME_CAMPUS_SPACE"_school_type"
//#define CAMPUS_SPACE_SCHOOL_YEAR          @""TABLE_NAME_CAMPUS_SPACE"_school_year"

#define CREATE_TABLE_CAMPUS_SPACE          @"CREATE TABLE "TABLE_NAME_CAMPUS_SPACE                   \
                                          "("                                                        \
                                           CAMPUS_SPACE_ID              " TEXT PRIMARY KEY,"         \
                                           CAMPUS_SPACE_OWNER           " TEXT,"                     \
                                           CAMPUS_SPACE_CONTENT         " TEXT,"                     \
                                           CAMPUS_SPACE_TIME            " TEXT,"                     \
                                           CAMPUS_SPACE_UPDATE                   " TEXT,"            \
                                           CAMPUS_SPACE_COMMENT_COUNT            " TEXT,"            \
                                           CAMPUS_SPACE_COMMENDATION_COUNT       " TEXT,"            \
                                           CAMPUS_SPACE_SHARE_COUNT              " TEXT,"            \
                                           CAMPUS_SPACE_ATTACHMENT               " TEXT,"            \
                                           CAMPUS_SPACE_IS_SHARED                " INTEGER,"         \
                                           CAMPUS_SPACE_STATUS                   " INTEGER,"         \
                                           CAMPUS_SPACE_DEPART_NAME      " TEXT,"                    \
                                           CAMPUS_SPACE_SCHOOL_NAME      " TEXT,"                    \
                                           CAMPUS_SPACE_PUBLISHER        " TEXT,"                    \
                                           CAMPUS_SPACE_NAME             " TEXT,"                    \
                                           CAMPUS_SPACE_AVATAR           " TEXT,"                    \
                                           CAMPUS_SPACE_SPECIAL_EMO      " TEXT,"                    \
                                           EXTENDS_1                     " TEXT,"                    \
                                           EXTENDS_2                     " TEXT,"                    \
                                           EXTENDS_3                     " TEXT"                     \
                                           ")"


#pragma mark - News and Entertainment  

#define NEWS_ENTERTAINMENT_CID                      @""TABLE_NAME_NEWS_ENTERTAINMENT"_cid"
#define NEWS_ENTERTAINMENT_ID                       @""TABLE_NAME_NEWS_ENTERTAINMENT"_id"
#define NEWS_ENTERTAINMENT_IMAGE                    @""TABLE_NAME_NEWS_ENTERTAINMENT"_image"
#define NEWS_ENTERTAINMENT_MD_H                     @""TABLE_NAME_NEWS_ENTERTAINMENT"_md_h"
#define NEWS_ENTERTAINMENT_MD_W                     @""TABLE_NAME_NEWS_ENTERTAINMENT"_md_w"
#define NEWS_ENTERTAINMENT_SM_H                     @""TABLE_NAME_NEWS_ENTERTAINMENT"_sm_h"
#define NEWS_ENTERTAINMENT_SM_W                     @""TABLE_NAME_NEWS_ENTERTAINMENT"_sm_w"
#define NEWS_ENTERTAINMENT_SUMMARY                  @""TABLE_NAME_NEWS_ENTERTAINMENT"_summary"
#define NEWS_ENTERTAINMENT_TIME                     @""TABLE_NAME_NEWS_ENTERTAINMENT"_time"
#define NEWS_ENTERTAINMENT_TITLE                    @""TABLE_NAME_NEWS_ENTERTAINMENT"_title"
#define NEWS_ENTERTAINMENT_SHOW_TYPE                @""TABLE_NAME_NEWS_ENTERTAINMENT"_show_type"
#define NEWS_ENTERTAINMENT_COMMENDATION_COUNT       @""TABLE_NAME_NEWS_ENTERTAINMENT"_commendation_count"
#define NEWS_ENTERTAINMENT_COMMENT_COUNT            @""TABLE_NAME_NEWS_ENTERTAINMENT"_comment_count"
#define NEWS_ENTERTAINMENT_SHARE_COUNT              @""TABLE_NAME_NEWS_ENTERTAINMENT"_share_count"

#define CREATE_TABLE_NEWS_ENTERTAINMENT          @"CREATE TABLE "TABLE_NAME_NEWS_ENTERTAINMENT            \
                                                "("                                                       \
                                                NEWS_ENTERTAINMENT_ID              " TEXT PRIMARY KEY,"   \
                                                NEWS_ENTERTAINMENT_CID           " TEXT,"                 \
                                                NEWS_ENTERTAINMENT_IMAGE         " TEXT,"                 \
                                                NEWS_ENTERTAINMENT_MD_H            " TEXT,"                     \
                                                NEWS_ENTERTAINMENT_MD_W                   " TEXT,"            \
                                                NEWS_ENTERTAINMENT_SM_H            " TEXT,"            \
                                                NEWS_ENTERTAINMENT_SM_W       " TEXT,"            \
                                                NEWS_ENTERTAINMENT_SUMMARY              " TEXT,"            \
                                                NEWS_ENTERTAINMENT_TIME               " TEXT,"            \
                                                NEWS_ENTERTAINMENT_TITLE                " TEXT,"         \
                                                NEWS_ENTERTAINMENT_SHOW_TYPE          " TEXT,"         \
                                                NEWS_ENTERTAINMENT_COMMENDATION_COUNT " TEXT,"         \
                                                NEWS_ENTERTAINMENT_COMMENT_COUNT      " TEXT,"         \
                                                NEWS_ENTERTAINMENT_SHARE_COUNT        " TEXT,"         \
                                                EXTENDS_1                     " TEXT,"                    \
                                                EXTENDS_2                     " TEXT,"                    \
                                                EXTENDS_3                     " TEXT"                     \
                                                ")"

#pragma mark - News Comments

#define NEWS_COMMENTS_ID               @""TABLE_NAME_NEWS_COMMENTS"_id"
#define NEWS_COMMENTS_MESSAGE_ID       @""TABLE_NAME_NEWS_COMMENTS"_message"
#define NEWS_COMMENTS_CONTENT_MESSAGE  @""TABLE_NAME_NEWS_COMMENTS"_content_message"
#define NEWS_COMMENTS_AVATAR           @""TABLE_NAME_NEWS_COMMENTS"_avatar"
#define NEWS_COMMENTS_NAME             @""TABLE_NAME_NEWS_COMMENTS"_name"
#define NEWS_COMMENTS_PUBLISHER        @""TABLE_NAME_NEWS_COMMENTS"_publisher"
#define NEWS_COMMENTS_TIME             @""TABLE_NAME_NEWS_COMMENTS"_time"
#define NEWS_COMMENTS_ATTACHMENT       @""TABLE_NAME_NEWS_COMMENTS"_attachment"
#define NEWS_COMMENTS_STATUS           @""TABLE_NAME_NEWS_COMMENTS"_status"
#define NEWS_COMMENTS_SPECIAL_EMO      @""TABLE_NAME_NEWS_COMMENTS""SPECIAL_EMO
#define CREATE_TABLE_NEWS_COMMENTS     @"CREATE TABLE "TABLE_NAME_NEWS_COMMENTS                   \
                                        "("                                                         \
                                                NEWS_COMMENTS_ID                       " TEXT PRIMARY KEY,"         \
                                                NEWS_COMMENTS_MESSAGE_ID               " TEXT,"                     \
                                                NEWS_COMMENTS_CONTENT_MESSAGE          " TEXT,"                     \
                                                NEWS_COMMENTS_AVATAR                   " TEXT,"                     \
                                                NEWS_COMMENTS_PUBLISHER                " TEXT,"                     \
                                                NEWS_COMMENTS_NAME                     " TEXT,"            \
                                                NEWS_COMMENTS_TIME                     " TEXT,"            \
                                                NEWS_COMMENTS_ATTACHMENT       " TEXT,"                    \
                                                NEWS_COMMENTS_STATUS           " INTEGER,"                 \
                                                NEWS_COMMENTS_SPECIAL_EMO      " TEXT,"                    \
                                                EXTENDS_1                       " TEXT,"                    \
                                                EXTENDS_2                       " TEXT,"                    \
                                                EXTENDS_3                       " TEXT"                     \
                                        ")"

#pragma mark - Compete Space

#define COMPETE_COMMENTS_ID               @""TABLE_NAME_COMPETE_COMMENTS"_id"
#define COMPETE_COMMENTS_COMPETE_ID       @""TABLE_NAME_COMPETE_COMMENTS"_compete_id"
#define COMPETE_COMMENTS_CONTENT_MESSAGE  @""TABLE_NAME_COMPETE_COMMENTS"_content_message"
#define COMPETE_COMMENTS_AVATAR           @""TABLE_NAME_COMPETE_COMMENTS"_avatar"
#define COMPETE_COMMENTS_NAME             @""TABLE_NAME_COMPETE_COMMENTS"_name"
#define COMPETE_COMMENTS_PUBLISHER        @""TABLE_NAME_COMPETE_COMMENTS"_publisher"
#define COMPETE_COMMENTS_TIME             @""TABLE_NAME_COMPETE_COMMENTS"_time"
#define COMPETE_COMMENTS_ATTACHMENT       @""TABLE_NAME_COMPETE_COMMENTS"_attachment"
#define COMPETE_COMMENTS_STATUS           @""TABLE_NAME_COMPETE_COMMENTS"_status"
#define COMPETE_COMMENTS_SPECIAL_EMO      @""TABLE_NAME_COMPETE_COMMENTS""SPECIAL_EMO
#define CREATE_TABLE_COMPETE_COMMENTS     @"CREATE TABLE "TABLE_NAME_COMPETE_COMMENTS                          \
                                         "("                                                                   \
                                              COMPETE_COMMENTS_ID                  " TEXT PRIMARY KEY,"        \
                                              COMPETE_COMMENTS_COMPETE_ID          " TEXT,"                    \
                                              COMPETE_COMMENTS_CONTENT_MESSAGE     " TEXT,"                    \
                                              COMPETE_COMMENTS_AVATAR              " TEXT,"                    \
                                              COMPETE_COMMENTS_NAME                " TEXT,"                    \
                                              COMPETE_COMMENTS_PUBLISHER           " TEXT,"                    \
                                              COMPETE_COMMENTS_TIME                " TEXT,"                    \
                                              COMPETE_COMMENTS_ATTACHMENT          " TEXT,"                    \
                                              COMPETE_COMMENTS_STATUS              " INTEGER,"                 \
                                              COMPETE_COMMENTS_SPECIAL_EMO         " TEXT,"                    \
                                              EXTENDS_1                            " TEXT,"                    \
                                              EXTENDS_2                            " TEXT,"                    \
                                              EXTENDS_3                            " TEXT"                     \
                                         ")"

#pragma mark - Group Space

#define GROUP_SPACE_MESSAGE_ID              @""TABLE_NAME_GROUP_SPACE"_message"
#define GROUP_SPACE_CONTENT_MESSAGE         @""TABLE_NAME_GROUP_SPACE"_content_message"
#define GROUP_SPACE_AVATAR                  @""TABLE_NAME_GROUP_SPACE"_avatar"
#define GROUP_SPACE_NAME                    @""TABLE_NAME_GROUP_SPACE"_name"
#define GROUP_SPACE_PUBLISHER               @""TABLE_NAME_GROUP_SPACE"_publisher"
#define GROUP_SPACE_TIME                    @""TABLE_NAME_GROUP_SPACE"_time"
#define GROUP_SPACE_ATTACHMENT              @""TABLE_NAME_GROUP_SPACE"_attachment"
#define GROUP_SPACE_STATUS                  @""TABLE_NAME_GROUP_SPACE"_status"
#define GROUP_SPACE_SPECIAL_EMO             @""TABLE_NAME_GROUP_SPACE""SPECIAL_EMO
#define GROUP_SPACE_COMMENT_COUNT           @""TABLE_NAME_GROUP_SPACE"_comment_count"
#define GROUP_SPACE_COMMENDATION_COUNT      @""TABLE_NAME_GROUP_SPACE"_commendation_count"
#define GROUP_SPACE_SHARE_COUNT             @""TABLE_NAME_GROUP_SPACE"_share_count"
#define GROUP_SPACE_DELETE                  @""TABLE_NAME_GROUP_SPACE"_delete"
#define GROUP_SPACE_ENTERTAINMENT_ID        @""TABLE_NAME_GROUP_SPACE"_enterprise_id"
#define GROUP_SPACE_MESSAGE_TYPE            @""TABLE_NAME_GROUP_SPACE"_message_type"
#define GROUP_SPACE_OWNER                   @""TABLE_NAME_GROUP_SPACE"_owner"
#define GROUP_SPACE_SPACE_TYPE              @""TABLE_NAME_GROUP_SPACE"_space_type"

#define CREATE_TABLE_GROUP_SPACE     @"CREATE TABLE "TABLE_NAME_GROUP_SPACE                             \
                                    "("                                                                 \
                                        GROUP_SPACE_MESSAGE_ID               " TEXT PRIMARY KEY,"       \
                                        GROUP_SPACE_CONTENT_MESSAGE          " TEXT,"                   \
                                        GROUP_SPACE_AVATAR                   " TEXT,"                   \
                                        GROUP_SPACE_PUBLISHER                " TEXT,"                   \
                                        GROUP_SPACE_NAME                     " TEXT,"                   \
                                        GROUP_SPACE_TIME                     " TEXT,"                   \
                                        GROUP_SPACE_ATTACHMENT              " TEXT,"                    \
                                        GROUP_SPACE_SPECIAL_EMO             " TEXT,"                    \
                                        GROUP_SPACE_STATUS                  " TEXT,"                    \
                                        GROUP_SPACE_COMMENT_COUNT           " TEXT,"                    \
                                        GROUP_SPACE_COMMENDATION_COUNT      " TEXT,"                    \
                                        GROUP_SPACE_SHARE_COUNT             " TEXT,"                    \
                                        GROUP_SPACE_DELETE              " TEXT,"                        \
                                        GROUP_SPACE_ENTERTAINMENT_ID              " TEXT,"              \
                                        GROUP_SPACE_MESSAGE_TYPE              " TEXT,"                  \
                                        GROUP_SPACE_OWNER              " TEXT,"                         \
                                        GROUP_SPACE_SPACE_TYPE              " TEXT,"                    \
                                        EXTENDS_1                           " TEXT,"                    \
                                        EXTENDS_2                           " TEXT,"                    \
                                        EXTENDS_3                           " TEXT"                     \
                                    ")"




#define SYNC_FILE_ID                @""TABLE_NAME_SYNC_FILES"_file_id"
#define SYNC_FILE_ENTERPRISEID      @""TABLE_NAME_SYNC_FILES"_enterprise_id"
#define SYNC_FILE_DISABLE           @""TABLE_NAME_SYNC_FILES"_disable"
#define SYNC_FILE_LOCALDATE         @""TABLE_NAME_SYNC_FILES"_local_date"
#define SYNC_FILE_LOCALURI          @""TABLE_NAME_SYNC_FILES"_local_uri"
#define SYNC_FILE_METADATA          @""TABLE_NAME_SYNC_FILES"_meta_data"
#define SYNC_FILE_NAME              @""TABLE_NAME_SYNC_FILES"_name"
#define SYNC_FILE_PARENTID          @""TABLE_NAME_SYNC_FILES"_parent_id"
#define SYNC_FILE_TYPE              @""TABLE_NAME_SYNC_FILES"_type"
#define SYNC_FILE_UPDATETIME        @""TABLE_NAME_SYNC_FILES"_update_time"
#define SYNC_FILE_TIME              @""TABLE_NAME_SYNC_FILES"_time"
#define SYNC_FILE_URI               @""TABLE_NAME_SYNC_FILES"_uri"
#define SYNC_FILE_SUBURI            @""TABLE_NAME_SYNC_FILES"_sub_uri"
#define SYNC_FILE_USER              @""TABLE_NAME_SYNC_FILES"_user_id"
#define SYNC_FILE_STATUS            @""TABLE_NAME_SYNC_FILES"_status"
#define SYNC_FILE_LOCATE            @""TABLE_NAME_SYNC_FILES"_locate"
#define SYNC_FILE_FOLDER_TYPE       @""TABLE_NAME_SYNC_FILES"_folder_type"
#define SYNC_FILE_LOCALID           @"_localId"         //非数据库使用


#define TABLE_NAME_SYNCFILE_MD5              @"_file_md5"
#define FILE_MD5_ID                          @""TABLE_NAME_SYNCFILE_MD5"_file_id"
#define FILE_MD5_MD5                         @""TABLE_NAME_SYNCFILE_MD5"_md5"
#define FILE_MD5_LOCATE                      @""TABLE_NAME_SYNCFILE_MD5"_loacate"
#define FILE_MD5_LOCALURL                    @""TABLE_NAME_SYNCFILE_MD5"_local_url"
#define CREATE_TABLE_SYNCFILE_MD5            @"CREATE TABLE "TABLE_NAME_SYNCFILE_MD5        \
                                              "("                                           \
                                                FILE_MD5_ID          " TEXT PRIMARY KEY,"    \
                                                FILE_MD5_MD5         " TEXT ,"    \
                                                FILE_MD5_LOCATE      " TEXT,"    \
                                                FILE_MD5_LOCALURL    " TEXT"     \
                                              ")"


#define CREATE_TABLE_SYNC_FILE         @"CREATE TABLE "TABLE_NAME_SYNC_FILES                   \
                                        "("                                                        \
                                        SYNC_FILE_ID              " TEXT PRIMARY KEY,"         \
                                        SYNC_FILE_ENTERPRISEID          " TEXT,"                     \
                                        SYNC_FILE_DISABLE               " TEXT,"       \
                                        SYNC_FILE_LOCALDATE             " TEXT,"       \
                                        SYNC_FILE_LOCALURI              " TEXT,"       \
                                        SYNC_FILE_METADATA              " TEXT,"       \
                                        SYNC_FILE_NAME                  " TEXT,"       \
                                        SYNC_FILE_PARENTID              " TEXT,"       \
                                        SYNC_FILE_TYPE                  " TEXT,"       \
                                        SYNC_FILE_UPDATETIME            " TEXT,"       \
                                        SYNC_FILE_TIME                  " TEXT,"       \
                                        SYNC_FILE_URI                   " TEXT,"       \
                                        SYNC_FILE_SUBURI                " TEXT,"       \
                                        SYNC_FILE_USER                  " TEXT,"       \
                                        SYNC_FILE_STATUS                " TEXT,"       \
                                        SYNC_FILE_LOCATE                " TEXT,"       \
                                        SYNC_FILE_FOLDER_TYPE           " TEXT,"       \
                                        EXTENDS_1                       " TEXT,"                    \
                                        EXTENDS_2                       " TEXT,"                    \
                                        EXTENDS_3                       " TEXT"                     \
                                        ")"








#pragma mark - Concerned Schools (TABLE_NAME_CONCERNED_SCHOOL)
#define CONCERNED_SCHOOL_USER_ID            @""TABLE_NAME_CONCERNED_SCHOOL"_user_id"
#define CONCERNED_SCHOOL_GROUP_ID           @""TABLE_NAME_CONCERNED_SCHOOL"_group_id"
#define CONCERNED_SCHOOL_SCHOOL_NAME        @""TABLE_NAME_CONCERNED_SCHOOL"_school_name"
#define CONCERNED_SCHOOL_STUDENT_COUNT      @""TABLE_NAME_CONCERNED_SCHOOL"_student_count"
#define CONCERNED_SCHOOL_PROVINCE_NAME      @""TABLE_NAME_CONCERNED_SCHOOL"_province_name"
#define CONCERNED_SCHOOL_MESSAGE_COUNT      @""TABLE_NAME_CONCERNED_SCHOOL"_message_count"
#define CONCERNED_SCHOOL_TYPE               @""TABLE_NAME_CONCERNED_SCHOOL"_type"
#define CONCERNED_SCHOOL_FIELD              @""TABLE_NAME_CONCERNED_SCHOOL"_field"

#define CREATE_TABLE_CONCERNED_SCHOOL       @"CREATE TABLE " TABLE_NAME_CONCERNED_SCHOOL                 \
                                            "("                                                          \
                                            CONCERNED_SCHOOL_USER_ID                          " TEXT,"   \
                                            CONCERNED_SCHOOL_GROUP_ID                         " TEXT,"   \
                                            CONCERNED_SCHOOL_SCHOOL_NAME                      " TEXT,"   \
                                            CONCERNED_SCHOOL_STUDENT_COUNT                 " INTEGER,"   \
                                            CONCERNED_SCHOOL_PROVINCE_NAME                    " TEXT,"   \
                                            CONCERNED_SCHOOL_MESSAGE_COUNT                 " INTEGER,"   \
                                            CONCERNED_SCHOOL_TYPE                          " INTEGER,"   \
                                            CONCERNED_SCHOOL_FIELD                         " INTEGER,"   \
                                            EXTENDS_1                       " TEXT,"                                    \
                                            EXTENDS_2                       " TEXT,"                                    \
                                            EXTENDS_3                       " TEXT,"                                     \
                                            "PRIMARY KEY ("                                              \
                                            CONCERNED_SCHOOL_USER_ID "," CONCERNED_SCHOOL_GROUP_ID "," CONCERNED_SCHOOL_FIELD    ")"  \
                                            ")"



#define KEY_STATUS @"resourceStatus" 





#pragma mark - activityInfo

#define ACTIVITY_ID                 @""TABLE_NAME_ACTIVITY"_id"
#define ACTIVITY_NAME               @""TABLE_NAME_ACTIVITY"_name"
#define ACTIVITY_SCHOOL_GROUP_ID    @""TABLE_NAME_ACTIVITY"_school_group_id"
#define ACTIVITY_GROUP_ID           @""TABLE_NAME_ACTIVITY"_group_id"
#define ACTIVITY_DESCRIPTION        @""TABLE_NAME_ACTIVITY"_description"
#define ACTIVITY_TYPE               @""TABLE_NAME_ACTIVITY"_type"
#define ACTIVITY_ADDRESS            @""TABLE_NAME_ACTIVITY"_address"
#define ACTIVITY_LOGO               @""TABLE_NAME_ACTIVITY"_logo"
#define ACTIVITY_START_TIME         @""TABLE_NAME_ACTIVITY"_start_time"
#define ACTIVITY_END_TIME           @""TABLE_NAME_ACTIVITY"_end_time"
#define ACTIVITY_OUT_TIME           @""TABLE_NAME_ACTIVITY"_out_time"
#define ACTIVITY_ENTERPRISE_ID      @""TABLE_NAME_ACTIVITY"_enterprise_id"
#define ACTIVITY_TIME               @""TABLE_NAME_ACTIVITY"_time"
#define ACTIVITY_UPDATE_TIME        @""TABLE_NAME_ACTIVITY"_update_time"
#define ACTIVITY_OWNER_AVATAR       @""TABLE_NAME_ACTIVITY"_avatar"
#define ACTIVITY_OWNER_ENTERPRISEID @""TABLE_NAME_ACTIVITY"_owner_enterprise_id"
#define ACTIVITY_OWNER_ID           @""TABLE_NAME_ACTIVITY"_owner_id"
#define ACTIVITY_OWNER_NAME         @""TABLE_NAME_ACTIVITY"_owner_name"
#define ACTIVITY_PAGE_LOGO          @""TABLE_NAME_ACTIVITY"_page_logo"
#define ACTIVITY_USER_SUM           @""TABLE_NAME_ACTIVITY"_user_sum"
#define ACTIVITY_ENTER_FLAG         @""TABLE_NAME_ACTIVITY"_enter_flag"
#define ACTIVITY_TELECOM_FLAG       @""TABLE_NAME_ACTIVITY"_telecom_flag"
#define ACTIVITY_DESABLED           @""TABLE_NAME_ACTIVITY"_disabled"
#define ACTIVITY_STATUS             @""TABLE_NAME_ACTIVITY"_status"

#define ACTIVITY_ATTRIBUTE          @""TABLE_NAME_ACTIVITY"_attribute"
#define ACTIVITY_TEMPLATE           @""TABLE_NAME_ACTIVITY"_template"
#define ACTIVITY_MAJOR_TYPE_NAME    @""TABLE_NAME_ACTIVITY"_type_name"
#define ACTIVITY_INTERACTING_END    @""TABLE_NAME_ACTIVITY"_interacting_end"
#define ACTIVITY_HOME_PAGE          @""TABLE_NAME_ACTIVITY"_home_page"
#define ACTIVITY_STATE              @""TABLE_NAME_ACTIVITY"_state"
#define ACTIVITY_ONLY_SCHOOL        @""TABLE_NAME_ACTIVITY"_only_school"

#define ACTIVITY_PARISE_FLAG        @""TABLE_NAME_ACTIVITY"_parise_flag"

#define CREATE_TABLE_ACTIVIT        @"CREATE TABLE "TABLE_NAME_ACTIVITY                   \
                                    "("                                                        \
                                    ACTIVITY_ID                  " TEXT PRIMARY KEY,"         \
                                    ACTIVITY_NAME                " TEXT,"                     \
                                    ACTIVITY_ADDRESS             " TEXT,"                     \
                                    ACTIVITY_SCHOOL_GROUP_ID            " TEXT,"                     \
                                    ACTIVITY_GROUP_ID                   " TEXT,"            \
                                    ACTIVITY_DESCRIPTION            " TEXT,"            \
                                    ACTIVITY_TYPE                   " TEXT,"            \
                                    ACTIVITY_LOGO               " TEXT,"            \
                                    ACTIVITY_START_TIME               " TEXT,"            \
                                    ACTIVITY_END_TIME                " TEXT,"         \
                                    ACTIVITY_OUT_TIME            " TEXT,"                    \
                                    ACTIVITY_ENTERPRISE_ID        " TEXT,"                    \
                                    ACTIVITY_TIME                " TEXT,"                    \
                                    ACTIVITY_UPDATE_TIME           " TEXT,"                    \
                                    ACTIVITY_OWNER_AVATAR          " TEXT,"  \
                                    ACTIVITY_OWNER_ENTERPRISEID    " TEXT,"   \
                                    ACTIVITY_OWNER_ID              " TEXT,"   \
                                    ACTIVITY_OWNER_NAME            " TEXT,"  \
                                    ACTIVITY_PAGE_LOGO              " TEXT,"  \
                                    ACTIVITY_USER_SUM              " TEXT,"  \
                                    ACTIVITY_TELECOM_FLAG           " TEXT,"            \
                                    ACTIVITY_ENTER_FLAG           " TEXT,"  \
                                    ACTIVITY_DESABLED             "  TEXT," \
                                    ACTIVITY_STATUS               "  TEXT," \
                                    ACTIVITY_ATTRIBUTE               "  TEXT," \
                                    ACTIVITY_TEMPLATE               "  TEXT," \
                                    ACTIVITY_MAJOR_TYPE_NAME       "  TEXT," \
                                    ACTIVITY_INTERACTING_END               "  TEXT," \
                                    ACTIVITY_HOME_PAGE               "  TEXT," \
                                    ACTIVITY_STATE               "  TEXT," \
                                    ACTIVITY_ONLY_SCHOOL               "  TEXT," \
                                    ACTIVITY_PARISE_FLAG          "  TEXT," \
                                    EXTENDS_1                     " TEXT,"                    \
                                    EXTENDS_2                     " TEXT,"                    \
                                    EXTENDS_3                     " TEXT"                     \
                                    ")"






//活动类型及数目标

#define ACTIVITY_TYPE_ID             @""TABLE_NAME_ACTIVITY_TYPE"_id"
#define ACTIVITY_TYPE_COUNT          @""TABLE_NAME_ACTIVITY_TYPE"_count"
#define ACTIVITY_TYPE_NAME           @""TABLE_NAME_ACTIVITY_TYPE"_name"
#define ACTIVITY_TYPE_CRENTD_USER_ID @""TABLE_NAME_ACTIVITY_TYPE"_currentUserId"
#define ACTIVITY_TYPE_GROUP_ID       @""TABLE_NAME_ACTIVITY_TYPE"_group_id"
#define ACTIVITY_TYPE_SCHOOL_GROUP_ID @""TABLE_NAME_ACTIVITY_TYPE"_school_group_id"

#define CREATE_TABLE_ACTIVIT_TYPE   @"CREATE TABLE "TABLE_NAME_ACTIVITY_TYPE                   \
                                    "("                                                        \
                                    ACTIVITY_TYPE_ID                  " TEXT, "  \
                                    ACTIVITY_TYPE_COUNT               "  TEXT," \
                                    ACTIVITY_TYPE_NAME                  " TEXT," \
                                    ACTIVITY_TYPE_CRENTD_USER_ID       " TEXT," \
                                    ACTIVITY_TYPE_GROUP_ID             " TEXT," \
                                    ACTIVITY_TYPE_SCHOOL_GROUP_ID      " TEXT," \
                                    EXTENDS_1                          " TEXT," \
                                    EXTENDS_2                          " TEXT," \
                                    EXTENDS_3                          " TEXT, "\
                                    "primary key ( "ACTIVITY_TYPE_ID" , "ACTIVITY_TYPE_SCHOOL_GROUP_ID")" \
                                    ")"





//活动参与关系表    TABLE_NAME_ACTIVITY_JOIN
#define ACTIVITY_JOIN_ACTIVITI_ID               @""TABLE_NAME_ACTIVITY_JOIN"_id"
#define ACTIVITY_JOIN_ACTIVITI_USER_ID          @""TABLE_NAME_ACTIVITY_JOIN"_userId"
#define ACTIVITY_JOIN_ACTIVITI_ACTIVITY_ID      @""TABLE_NAME_ACTIVITY_JOIN"_activityId"
#define ACTIVITY_JOIN_ACTIVITI_ISJOIN           @""TABLE_NAME_ACTIVITY_JOIN"_isJoin"

// ACTIVITY_JOIN_ACTIVITI_ID                  " INTEGER PRIMARY KEY AUTOINCREMENT "  \

#define CREATE_TABLE_ACTIVITY_JOIN   @"CREATE TABLE "TABLE_NAME_ACTIVITY_JOIN                   \
                                        "("                                                        \
                                        ACTIVITY_JOIN_ACTIVITI_USER_ID               "  TEXT," \
                                        ACTIVITY_JOIN_ACTIVITI_ACTIVITY_ID                  " TEXT," \
                                        ACTIVITY_JOIN_ACTIVITI_ISJOIN               " TEXT," \
                                        EXTENDS_1                                   " TEXT," \
                                        EXTENDS_2                                   " TEXT," \
                                        EXTENDS_3                                   " TEXT "\
                                        ")"








#pragma mark - part-time job
// TABLE_NAME_PARTTIME_JOB
#define PARTTIME_JOB_INFO_ID               @""TABLE_NAME_PARTTIME_JOB"_info_id"
#define PARTTIME_JOB_TITLE                 @""TABLE_NAME_PARTTIME_JOB"_title"
#define PARTTIME_JOB_CITY                  @""TABLE_NAME_PARTTIME_JOB"_city"
#define PARTTIME_JOB_SUMMARY               @""TABLE_NAME_PARTTIME_JOB"_summary"
#define PARTTIME_JOB_ADDTIME               @""TABLE_NAME_PARTTIME_JOB"_addtime"
#define PARTTIME_JOB_COMPANY_NAME          @""TABLE_NAME_PARTTIME_JOB"_company_name"
#define PARTTIME_JOB_COMPANY_INS           @""TABLE_NAME_PARTTIME_JOB"_company_ins"
#define PARTTIME_JOB_COMPANY_TYPE          @""TABLE_NAME_PARTTIME_JOB"_company_type"
#define PARTTIME_JOB_COMPANY_SIZE          @""TABLE_NAME_PARTTIME_JOB"_company_size"
#define PARTTIME_JOB_JOB_NAME              @""TABLE_NAME_PARTTIME_JOB"_job_name"
#define PARTTIME_JOB_SALARY                @""TABLE_NAME_PARTTIME_JOB"_salary"
#define PARTTIME_JOB_EDUCATION             @""TABLE_NAME_PARTTIME_JOB"_education"
#define PARTTIME_JOB_WORK_EXP              @""TABLE_NAME_PARTTIME_JOB"_work_exp"
#define PARTTIME_JOB_RECRUIT_COUNT         @""TABLE_NAME_PARTTIME_JOB"_recruit_count"
#define PARTTIME_JOB_WORK_PLACE            @""TABLE_NAME_PARTTIME_JOB"_work_place"
#define PARTTIME_JOB_WORK_TIME             @""TABLE_NAME_PARTTIME_JOB"_work_time"
#define PARTTIME_JOB_JOB_DES               @""TABLE_NAME_PARTTIME_JOB"_job_des"
#define PARTTIME_JOB_CONTACT               @""TABLE_NAME_PARTTIME_JOB"_contact"
#define PARTTIME_JOB_CONTACT_NUMBER        @""TABLE_NAME_PARTTIME_JOB"_contact_number"
#define PARTTIME_JOB_COMPANY_ADDRESS       @""TABLE_NAME_PARTTIME_JOB"_company_address"
#define PARTTIME_JOB_COMPANY_INTRODUCE     @""TABLE_NAME_PARTTIME_JOB"_company_introduce"
#define PARTTIME_JOB_PUBTIME               @""TABLE_NAME_PARTTIME_JOB"_pubtime"

#define CREATE_TABLE_PARTTIME_JOB                         \
@"CREATE TABLE "TABLE_NAME_PARTTIME_JOB                   \
 "("                                                      \
 @""PARTTIME_JOB_INFO_ID             " TEXT PRIMARY KEY," \
 @""PARTTIME_JOB_TITLE               " TEXT,"             \
 @""PARTTIME_JOB_CITY                " TEXT,"             \
 @""PARTTIME_JOB_SUMMARY             " TEXT,"             \
 @""PARTTIME_JOB_ADDTIME             " TEXT,"             \
 @""PARTTIME_JOB_COMPANY_NAME        " TEXT,"             \
 @""PARTTIME_JOB_COMPANY_INS         " TEXT,"             \
 @""PARTTIME_JOB_COMPANY_TYPE        " TEXT,"             \
 @""PARTTIME_JOB_COMPANY_SIZE        " TEXT,"             \
 @""PARTTIME_JOB_JOB_NAME            " TEXT,"             \
 @""PARTTIME_JOB_SALARY              " TEXT,"             \
 @""PARTTIME_JOB_EDUCATION           " TEXT,"             \
 @""PARTTIME_JOB_WORK_EXP            " TEXT,"             \
 @""PARTTIME_JOB_RECRUIT_COUNT       " TEXT,"             \
 @""PARTTIME_JOB_WORK_PLACE          " TEXT,"             \
 @""PARTTIME_JOB_WORK_TIME           " TEXT,"             \
 @""PARTTIME_JOB_JOB_DES             " TEXT,"             \
 @""PARTTIME_JOB_CONTACT             " TEXT,"             \
 @""PARTTIME_JOB_CONTACT_NUMBER      " TEXT,"             \
 @""PARTTIME_JOB_COMPANY_ADDRESS     " TEXT,"             \
 @""PARTTIME_JOB_COMPANY_INTRODUCE   " TEXT,"             \
 @""PARTTIME_JOB_PUBTIME             " TEXT"              \
 ")"

#pragma mark - notice

#define TABLE_NAME_NOTICE_NOTICE_ID               @""TABLE_NAME_NOTICE"_notice_id"
#define TABLE_NAME_NOTICE_USER_ID                 @""TABLE_NAME_NOTICE"_user_id"
#define TABLE_NAME_NOTICE_NAME                    @""TABLE_NAME_NOTICE"_name"
#define TABLE_NAME_NOTICE_AVATAR                  @""TABLE_NAME_NOTICE"_avatar"
#define TABLE_NAME_NOTICE_ENTERPRISE_ID           @""TABLE_NAME_NOTICE"_enterprise_id"
#define TABLE_NAME_NOTICE_TIME                    @""TABLE_NAME_NOTICE"_time"
#define TABLE_NAME_NOTICE_MESSAGE                 @""TABLE_NAME_NOTICE"_message"
#define TABLE_NAME_NOTICE_TYPE                    @""TABLE_NAME_NOTICE"_type"
#define TABLE_NAME_NOTICE_READ                    @""TABLE_NAME_NOTICE"_read"
#define TABLE_NAME_NOTICE_MESSAGEID               @""TABLE_NAME_NOTICE"_messageid"
#define TABLE_NAME_NOTICE_MESSAGE_OBJ_TYPE        @""TABLE_NAME_NOTICE"_message_obj_type"
#define TABLE_NAME_NOTICE_OBJECT_JSON             @""TABLE_NAME_NOTICE"_object_json"
#define TABLE_NAME_NOTICE_COMMENDATION_COUNT      @""TABLE_NAME_NOTICE"_commendation_count"
#define TABLE_NAME_NOTICE_COMMENT_COUNT           @""TABLE_NAME_NOTICE"_comment_count"
#define TABLE_NAME_NOTICE_SHARE_COUNT             @""TABLE_NAME_NOTICE"_share_count"
#define TABLE_NAME_NOTICE_CURRENTUSERID           @""TABLE_NAME_NOTICE"_current_user_id"


#define CREATE_TABLE_NOTICE                                     \
@"CREATE TABLE "TABLE_NAME_NOTICE                               \
"("                                                             \
@""TABLE_NAME_NOTICE_NOTICE_ID           " TEXT PRIMARY KEY,"   \
@""TABLE_NAME_NOTICE_USER_ID             " TEXT,"               \
@""TABLE_NAME_NOTICE_NAME                " TEXT,"               \
@""TABLE_NAME_NOTICE_AVATAR              " TEXT,"               \
@""TABLE_NAME_NOTICE_ENTERPRISE_ID       " TEXT,"               \
@""TABLE_NAME_NOTICE_TIME                " TEXT,"               \
@""TABLE_NAME_NOTICE_MESSAGE             " TEXT,"               \
@""TABLE_NAME_NOTICE_TYPE                " INTEGER,"            \
@""TABLE_NAME_NOTICE_READ                " INTEGER,"            \
@""TABLE_NAME_NOTICE_MESSAGEID           " TEXT,"               \
@""TABLE_NAME_NOTICE_MESSAGE_OBJ_TYPE    " INTEGER,"            \
@""TABLE_NAME_NOTICE_OBJECT_JSON         " TEXT,"               \
@""TABLE_NAME_NOTICE_COMMENDATION_COUNT  " INTEGER,"            \
@""TABLE_NAME_NOTICE_COMMENT_COUNT       " INTEGER,"            \
@""TABLE_NAME_NOTICE_SHARE_COUNT         " INTEGER,"            \
@""TABLE_NAME_NOTICE_CURRENTUSERID       " TEXT,"               \
EXTENDS_1                       " TEXT,"                                    \
EXTENDS_2                       " TEXT,"                                    \
EXTENDS_3                       " TEXT"                                     \
")"

#endif



#pragma mark database table for group Notice
#define GROUP_NOTICE_NOTICE_ID               @""TABLE_NAME_GROUP_NOTICE"_id"
#define GROUP_NOTICE_USER_ID                 @""TABLE_NAME_GROUP_NOTICE"_user_id"
#define GROUP_NOTICE_NAME                    @""TABLE_NAME_GROUP_NOTICE"_user_name"
#define GROUP_NOTICE_AVATAR                  @""TABLE_NAME_GROUP_NOTICE"_avatar"
#define GROUP_NOTICE_TIME                    @""TABLE_NAME_GROUP_NOTICE"_time"
#define GROUP_NOTICE_MESSAGE                 @""TABLE_NAME_GROUP_NOTICE"_message"
#define GROUP_NOTICE_TYPE                    @""TABLE_NAME_GROUP_NOTICE"_type"
#define GROUP_NOTICE_READ                    @""TABLE_NAME_GROUP_NOTICE"_read"
#define GROUP_NOTICE_LOGO                    @""TABLE_NAME_GROUP_NOTICE"_logo"
#define GROUP_NOTICE_GROUP_NAME              @""TABLE_NAME_GROUP_NOTICE"_name"
#define GROUP_NOTICE_GROUP_OLD_NAME          @""TABLE_NAME_GROUP_NOTICE"_old_name"
#define GROUP_NOTICE_GROUP_ID                @""TABLE_NAME_GROUP_NOTICE"_group_id"
#define GROUP_NOTICE_GROUP_TYPE              @""TABLE_NAME_GROUP_NOTICE"_objType"
#define GROUP_NOTICE_USERID                  @""TABLE_NAME_GROUP_NOTICE"_userID"
#define GROUP_NOTICE_STATUS                  @""TABLE_NAME_GROUP_NOTICE"_status"

#define CREATE_TABLE_GROUP_NOTICE                                     \
@"CREATE TABLE "TABLE_NAME_GROUP_NOTICE                               \
"("                                                             \
@""GROUP_NOTICE_NOTICE_ID           " TEXT PRIMARY KEY,"   \
@""GROUP_NOTICE_USER_ID             " TEXT,"               \
@""GROUP_NOTICE_NAME                " TEXT,"               \
@""GROUP_NOTICE_AVATAR              " TEXT,"               \
@""GROUP_NOTICE_TIME                " TEXT,"               \
@""GROUP_NOTICE_MESSAGE             " TEXT,"               \
@""GROUP_NOTICE_TYPE                " TEXT,"            \
@""GROUP_NOTICE_READ                " TEXT,"            \
@""GROUP_NOTICE_LOGO                " TEXT,"            \
@""GROUP_NOTICE_GROUP_NAME          " TEXT,"               \
@""GROUP_NOTICE_GROUP_OLD_NAME      " TEXT,"            \
@""GROUP_NOTICE_GROUP_ID            " TEXT,"            \
@""GROUP_NOTICE_GROUP_TYPE          " TEXT,"            \
@""GROUP_NOTICE_USERID              " TEXT,"            \
@""GROUP_NOTICE_STATUS              " TEXT,"             \
EXTENDS_1                       " TEXT,"                                    \
EXTENDS_2                       " TEXT,"                                    \
EXTENDS_3                       " TEXT"                                     \
")"






#pragma mark database table for group
#define GROUP_ID                @""TABLE_NAME_GROUPS"_id"
#define GROUP_ENTERPRISE_ID     @""TABLE_NAME_GROUPS"_enterprise_id"
#define GROUP_ATTRUBUTE         @""TABLE_NAME_GROUPS"_attribute"
#define GROUP_DESCRIPTION       @""TABLE_NAME_GROUPS"_description"
#define GROUP_DISABLED          @""TABLE_NAME_GROUPS"_disabled"
#define GROUP_LOGO              @""TABLE_NAME_GROUPS"_logo"
#define GROUP_NAME              @""TABLE_NAME_GROUPS"_name"
#define GROUP_OWNER_ID          @""TABLE_NAME_GROUPS"_owner_id"
#define GROUP_TAGS              @""TABLE_NAME_GROUPS"_tags"
#define GROUP_TIME              @""TABLE_NAME_GROUPS"_time"
#define GROUP_USER_ID           @""TABLE_NAME_GROUPS"_user_id"
#define GROUP_TYPE              @""TABLE_NAME_GROUPS"_type"
#define GROUP_USERID            @""TABLE_NAME_GROUPS""USERID
#define GROUP_MANAGER_AVATAR    @""TABLE_NAME_GROUPS"_manager_avatar"
#define GROUP_MANAGER_ID        @""TABLE_NAME_GROUPS"_manager_id"
#define GROUP_MANAGER_NAME      @""TABLE_NAME_GROUPS"_manager_name"
#define GROUP_COVER             @""TABLE_NAME_GROUPS"_cover"
#define GROUP_SIGNATURE         @""TABLE_NAME_GROUPS"_signature"
#define GROUP_MEMBER_COUNT      @""TABLE_NAME_GROUPS"_member_count"
#define GROUP_MAX_MEMBER      @""TABLE_NAME_GROUPS"_max_member"
#define GROUP_STATUS            @""TABLE_NAME_GROUPS"_status"


#define CREATE_TABLE_GROUPS     @"CREATE TABLE " TABLE_NAME_GROUPS                \
                                    "("                                             \
                                    GROUP_ID                " TEXT PRIMARY KEY,"        \
                                    GROUP_ENTERPRISE_ID     " TEXT,"                     \
                                    GROUP_ATTRUBUTE         " TEXT,"                     \
                                    GROUP_DESCRIPTION       " TEXT,"                     \
                                    GROUP_DISABLED          " TEXT,"                     \
                                    GROUP_LOGO              " TEXT,"                     \
                                    GROUP_NAME              " TEXT,"                     \
                                    GROUP_OWNER_ID          " TEXT,"                     \
                                    GROUP_TAGS              " TEXT,"                     \
                                    GROUP_TIME              " TEXT,"                     \
                                    GROUP_USER_ID           " TEXT,"                     \
                                    GROUP_TYPE              " TEXT,"                     \
                                    GROUP_USERID            " TEXT,"                     \
                                    GROUP_MANAGER_AVATAR    " TEXT,"                     \
                                    GROUP_MANAGER_ID        " TEXT,"                     \
                                    GROUP_MANAGER_NAME      " TEXT,"                      \
                                    GROUP_STATUS            " TEXT,"                        \
                                    GROUP_COVER             " TEXT,"                    \
                                    GROUP_SIGNATURE         " TEXT,"                    \
                                    GROUP_MEMBER_COUNT      " TEXT,"                    \
                                    GROUP_MAX_MEMBER        " TEXT,"                    \
                                    EXTENDS_1                     " TEXT,"                    \
                                    EXTENDS_2                     " TEXT,"                    \
                                    EXTENDS_3                     " TEXT"                     \
                                    ")"



#define GROUP_COUNT_ID          @""TABLE_NAME_GROUPS_COUNT"_server"
#define GROUP_COUNT_COUNT       @""TABLE_NAME_GROUPS_COUNT"_count"
#define GROUP_COUNT_USERID      @""TABLE_NAME_GROUPS_COUNT"_userId"
#define GROUP_COUNT_ISENTER     @""TABLE_NAME_GROUPS_COUNT"_isEnter"

#define CREATE_TABLE_GROUPS_COUNT     @"CREATE TABLE " TABLE_NAME_GROUPS_COUNT                \
"("                                                                         \
                GROUP_COUNT_ID                  " TEXT PRIMARY KEY,"        \
                GROUP_COUNT_COUNT               " INTEGER,"                 \
                GROUP_COUNT_USERID              " TEXT,"                    \
                GROUP_COUNT_ISENTER             " INTEGER"                  \
")"






#define GROUP_CHAT_ID               @""TABLE_NAME_GROUPS_CHAT"_message"
#define GROUP_CHAT_CONTENT          @""TABLE_NAME_GROUPS_CHAT"_text"
#define GROUP_CHAT_DELETE           @""TABLE_NAME_GROUPS_CHAT"_delete"
#define GROUP_CHAT_OWNER            @""TABLE_NAME_GROUPS_CHAT"_owner"
#define GROUP_CHAT_TIME             @""TABLE_NAME_GROUPS_CHAT"_time"
#define GROUP_CHAT_ATTACHEMENT      @""TABLE_NAME_GROUPS_CHAT"_attachment"
#define GROUP_CHAT_AVATAR           @""TABLE_NAME_GROUPS_CHAT"_avatar"
#define GROUP_CHAT_PUBLISHER        @""TABLE_NAME_GROUPS_CHAT"_publisher"
#define GROUP_CHAT_NAME             @""TABLE_NAME_GROUPS_CHAT"_name"
#define GROUP_CHAT_STATUS           @""TABLE_NAME_GROUPS_CHAT"_status"
#define GROUP_CHAT_SPECIAL_EMO      @""TABLE_NAME_GROUPS_CHAT""SPECIAL_EMO
#define CREATE_TABLE_GROUPS_CHAT     @"CREATE TABLE " TABLE_NAME_GROUPS_CHAT                \
                                    "("                                             \
                                        GROUP_CHAT_ID                           " TEXT PRIMARY KEY,"        \
                                        GROUP_CHAT_CONTENT                      " TEXT,"                     \
                                        GROUP_CHAT_DELETE                       " TEXT,"                     \
                                        GROUP_CHAT_OWNER                        " TEXT,"                     \
                                        GROUP_CHAT_TIME                         " TEXT,"                     \
                                        GROUP_CHAT_ATTACHEMENT                  " TEXT,"                     \
                                        GROUP_CHAT_AVATAR                       " TEXT,"                     \
                                        GROUP_CHAT_PUBLISHER                    " TEXT,"                     \
                                        GROUP_CHAT_NAME                         " TEXT,"                     \
                                        GROUP_CHAT_STATUS                       " TEXT,"                     \
                                        GROUP_CHAT_SPECIAL_EMO                  " TEXT,"                     \
                                        EXTENDS_1                     " TEXT,"                    \
                                        EXTENDS_2                     " TEXT,"                    \
                                        EXTENDS_3                     " TEXT"                     \
                                    ")"




#define GROUP_MEMBER_ID                 @""TABLE_NAME_GROUP_MEMBERS"_id"
#define GROUP_MEMBER_GROUP_ID           @""TABLE_NAME_GROUP_MEMBERS"_group_id"
#define GROUP_MEMBER_PRIVILEGE          @""TABLE_NAME_GROUP_MEMBERS"_privilege"
#define GROUP_MEMBER_AVATAR             @""TABLE_NAME_GROUP_MEMBERS"_avatar"
#define GROUP_MEMBER_USERID             @""TABLE_NAME_GROUP_MEMBERS"_user_id"
#define GROUP_MEMBER_NAME               @""TABLE_NAME_GROUP_MEMBERS"_name"
#define GROUP_MEMBER_STATUS             @""TABLE_NAME_GROUP_MEMBERS"_status"
#define CREATE_TABLE_GROUPS_MEMBERS     @"CREATE TABLE " TABLE_NAME_GROUP_MEMBERS                \
                                            "("                                             \
                                            GROUP_MEMBER_ID                           " TEXT PRIMARY KEY,"        \
                                            GROUP_MEMBER_GROUP_ID                      " TEXT,"                     \
                                            GROUP_MEMBER_PRIVILEGE                       " TEXT,"                     \
                                            GROUP_MEMBER_AVATAR                        " TEXT,"                     \
                                            GROUP_MEMBER_USERID                         " TEXT,"                     \
                                            GROUP_MEMBER_NAME                  " TEXT,"                     \
                                            GROUP_MEMBER_STATUS                       " TEXT,"                     \
                                            EXTENDS_1                     " TEXT,"                    \
                                            EXTENDS_2                     " TEXT,"                    \
                                            EXTENDS_3                     " TEXT"                     \
                                            ")"

    
#define FRIEND_NEWS_ID                  @""TABLE_NAME_FRIEND_NEWS"_message"
#define FRIEND_NEWS_TYPE                @""TABLE_NAME_FRIEND_NEWS"_message_type"
#define FRIEND_NEWS_UPDATE_TIME         @""TABLE_NAME_FRIEND_NEWS"_update"
#define FRIEND_NEWS_TIME                @""TABLE_NAME_FRIEND_NEWS"_time"
#define FRIEND_NEWS_NAME                @""TABLE_NAME_FRIEND_NEWS"_name"
#define FRIEND_NEWS_PUBLISHER           @""TABLE_NAME_FRIEND_NEWS"_publisher"
#define FRIEND_NEWS_AVATAR              @""TABLE_NAME_FRIEND_NEWS"_avatar"
#define FRIEND_NEWS_OBJECTDATA          @""TABLE_NAME_FRIEND_NEWS"_object_data"
#define FRIEND_NEWS_USERID              @""TABLE_NAME_FRIEND_NEWS"_userId"
#define FRIEND_NEWS_COMMENT_COUNT       @""TABLE_NAME_FRIEND_NEWS"_comment_count"
#define FRIEND_NEWS_COMMENDATION_COUNT  @""TABLE_NAME_FRIEND_NEWS"_commendation_count" 
#define FRIEND_NEWS_SHARE_COUNT         @""TABLE_NAME_FRIEND_NEWS"_share_count"



#define CREATE_TABLE_FRIEND_NEWS    @"CREATE TABLE " TABLE_NAME_FRIEND_NEWS                \
                                        "("                                             \
                                        FRIEND_NEWS_ID                              " TEXT PRIMARY KEY,"        \
                                        FRIEND_NEWS_TYPE                            " TEXT,"                     \
                                        FRIEND_NEWS_UPDATE_TIME                     " TEXT,"                     \
                                        FRIEND_NEWS_TIME                            " TEXT,"                     \
                                        FRIEND_NEWS_NAME                            " TEXT,"                     \
                                        FRIEND_NEWS_PUBLISHER                       " TEXT,"                     \
                                        FRIEND_NEWS_AVATAR                          " TEXT,"                     \
                                        FRIEND_NEWS_OBJECTDATA                      " TEXT,"                     \
                                        FRIEND_NEWS_USERID                          " TEXT,"                     \
                                        FRIEND_NEWS_COMMENT_COUNT                   " TEXT,"                     \
                                        FRIEND_NEWS_COMMENDATION_COUNT              " TEXT,"                     \
                                        FRIEND_NEWS_SHARE_COUNT                     " TEXT,"                     \
                                        EXTENDS_1                                   " TEXT,"                    \
                                        EXTENDS_2                                   " TEXT,"                    \
                                        EXTENDS_3                                   " TEXT"                     \
                                        ")"



#define CREDITS_ACTION_ID           @""TABLE_NAME_CREDITS_ACTION"_id"
#define CREDITS_ACTION_ADDMAX       @""TABLE_NAME_CREDITS_ACTION"_add_credit_max"
#define CREDITS_ACTION_ADDMIN       @""TABLE_NAME_CREDITS_ACTION"_add_credit_min"
#define CREDITS_ACTION_TYPE         @""TABLE_NAME_CREDITS_ACTION"_action_type"
#define CREDITS_ACTION_DECMIN       @""TABLE_NAME_CREDITS_ACTION"_decrease_credit_min"
#define CREDITS_ACTION_DECMAX       @""TABLE_NAME_CREDITS_ACTION"_decrease_credit_max"
#define CREATE_TABLE_CREDITS_ACTION @"CREATE TABLE " TABLE_NAME_CREDITS_ACTION                \
                                        "("                                             \
                                        CREDITS_ACTION_ID                               " TEXT PRIMARY KEY,"        \
                                        CREDITS_ACTION_ADDMAX                           " TEXT,"                     \
                                        CREDITS_ACTION_ADDMIN                           " TEXT,"                     \
                                        CREDITS_ACTION_TYPE                             " TEXT,"                     \
                                        CREDITS_ACTION_DECMIN                           " TEXT,"                     \
                                        CREDITS_ACTION_DECMAX                           " TEXT,"                     \
                                        EXTENDS_1                                       " TEXT,"                    \
                                        EXTENDS_2                                       " TEXT,"                    \
                                        EXTENDS_3                                       " TEXT"                     \
                                        ")"

#define GOOD_ID        @""TABLE_NAME_GOODS"_id"
#define GOOD_NAME      @""TABLE_NAME_GOODS"_name"
#define GOOD_TYPE      @""TABLE_NAME_GOODS"_type"
#define GOOD_SRC       @""TABLE_NAME_GOODS"_src"
#define GOOD_DISABLED  @""TABLE_NAME_GOODS"_disabled"
#define GOOD_USERID    @""TABLE_NAME_GOODS"_userId"
#define GOOD_COUNT     @""TABLE_NAME_GOODS"_count"
#define CREATE_TABLE_GOODS @"CREATE TABLE " TABLE_NAME_GOODS                \
                                    "("                                             \
                                    GOOD_ID                               " TEXT PRIMARY KEY,"        \
                                    GOOD_NAME                           " TEXT,"                     \
                                    GOOD_TYPE                           " INTEGER,"                     \
                                    GOOD_SRC                            " TEXT,"                    \
                                    GOOD_DISABLED                       " TEXT,"                    \
                                    GOOD_USERID                         " TEXT,"                    \
                                    GOOD_COUNT                          " TEXT,"                    \
                                    EXTENDS_1                                       " TEXT,"                    \
                                    EXTENDS_2                                       " TEXT,"                    \
                                    EXTENDS_3                                       " TEXT"                     \
                                    ")"



#define GIFT_ID                 @""TABLE_NAME_RECEIVED_GIFT"_message"
#define GIFT_ITEM_ID            @""TABLE_NAME_RECEIVED_GIFT"_item"
#define GIFT_SRC                @""TABLE_NAME_RECEIVED_GIFT"_src"
#define GIFT_TYPE               @""TABLE_NAME_RECEIVED_GIFT"_type"
#define GIFT_MESSAGE            @""TABLE_NAME_RECEIVED_GIFT"_gift_message"
#define GIFT_NAME               @""TABLE_NAME_RECEIVED_GIFT"_gift_name"
#define GIFT_OWNER              @""TABLE_NAME_RECEIVED_GIFT"_owner"
#define GIFT_SENDER_ID          @""TABLE_NAME_RECEIVED_GIFT"_publisher"
#define GIFT_SENDER_AVATAR      @""TABLE_NAME_RECEIVED_GIFT"_avatar"
#define GIFT_SENDER_NAME        @""TABLE_NAME_RECEIVED_GIFT"_name"
#define CREATE_TABLE_RECEIVED_GIFT @"CREATE TABLE " TABLE_NAME_RECEIVED_GIFT                \
                                        "("                                             \
                                        GIFT_ID                               " TEXT PRIMARY KEY,"        \
                                        GIFT_ITEM_ID                           " TEXT,"                     \
                                        GIFT_TYPE                           " TEXT,"                     \
                                        GIFT_SRC                            " TEXT,"                    \
                                        GIFT_MESSAGE                       " TEXT,"                    \
                                        GIFT_OWNER                         " TEXT,"                    \
                                        GIFT_SENDER_ID                          " TEXT,"                    \
                                        GIFT_SENDER_AVATAR                      " TEXT,"                    \
                                        GIFT_SENDER_NAME                        " TEXT,"                    \
                                        GIFT_NAME                               " TEXT,"                    \
                                        EXTENDS_1                                       " TEXT,"                    \
                                        EXTENDS_2                                       " TEXT,"                    \
                                        EXTENDS_3                                       " TEXT"                     \
                                        ")"






#pragma mark-- -inviteRecord
//-----------inviteRecord table ------
#define INVITE_RECORD_MOBILE            @""TABLE_NAME_INVITE_RECORD"_mobile"
#define INVITE_RECORD_COUNT             @""TABLE_NAME_INVITE_RECORD"_count"
#define INVITE_RECORD_MONEY             @""TABLE_NAME_INVITE_RECORD"_money"
#define INVITE_RECORD_RECEIVE           @""TABLE_NAME_INVITE_RECORD"_receive"
#define INVITE_RECORD_AVATAR            @""TABLE_NAME_INVITE_RECORD"_avatar"
#define INVITE_RECORD_USER_ID           @""TABLE_NAME_INVITE_RECORD"_id"
#define INVITE_RECORD_NAME              @""TABLE_NAME_INVITE_RECORD"_name"
#define INVITE_RECORD_STATUS            @""TABLE_NAME_INVITE_RECORD"_status"
#define INVITE_RECORD_CURRENTUSER       @""TABLE_NAME_INVITE_RECORD"_current_userId"

#define CREATE_TABLE_INVITE_RECORD @"CREATE TABLE " TABLE_NAME_INVITE_RECORD                                            \
"("                                                                         \
INVITE_RECORD_MOBILE                 " TEXT PRIMARY KEY,"                        \
INVITE_RECORD_COUNT        "  TEXT,"                                \
INVITE_RECORD_MONEY        "  TEXT,"                                \
INVITE_RECORD_RECEIVE        "  TEXT,"                                \
INVITE_RECORD_AVATAR          "  TEXT,"             \
INVITE_RECORD_USER_ID         "  TEXT,"   \
INVITE_RECORD_NAME             "  TEXT,"  \
INVITE_RECORD_STATUS           " TEXT," \
INVITE_RECORD_CURRENTUSER      " TEXT,"  \
EXTENDS_1                       " TEXT,"                                    \
EXTENDS_2                       " TEXT,"                                    \
EXTENDS_3                       " TEXT"                                     \
")"

//---------------------------------



//please insert table before network databse
////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark database table for network
#define TABLE_NAME_TASK     @"_task"
#define TABLE_NAME_JOB      @"_job"

#pragma mark Task
#define TASK_ID         @""TABLE_NAME_TASK"_id"
#define TASK_TYPE       @""TABLE_NAME_TASK"_type"
#define TASK_STATUS     @""TABLE_NAME_TASK"_status"
#define TASK_TABLENAME  @""TABLE_NAME_TASK"_table_name"
#define TASK_USERID     @""TABLE_NAME_TASK""USERID
#define CREATE_TABLE_TASK   @"CREATE TABLE " TABLE_NAME_TASK                \
"("                                             \
TASK_ID             " TEXT PRIMARY KEY,"        \
TASK_TYPE           " INTEGER,"                     \
TASK_STATUS         " TEXT,"                     \
TASK_TABLENAME      " TEXT,"                     \
TASK_USERID         " TEXT"                     \
")"

#pragma mark Job
#define JOB_ID          @""TABLE_NAME_JOB"_id"
#define JOB_TASK_ID     @""TABLE_NAME_JOB"_task_id"
#define JOB_COMMAND     @""TABLE_NAME_JOB"_command"
#define JOB_URL         @""TABLE_NAME_JOB"_url"
#define JOB_JSON        @""TABLE_NAME_JOB"_json"
#define JOB_HEADER      @""TABLE_NAME_JOB"_header"
#define JOB_FILE_PATH   @""TABLE_NAME_JOB"_file_path"
#define JOB_IS_MAIN     @""TABLE_NAME_JOB"_isMainJob"
#define JOB_STATUS      @""TABLE_NAME_JOB"_status"

#define CREATE_TABLE_JOB    @"CREATE TABLE " TABLE_NAME_JOB                 \
"("                                             \
JOB_ID              " INTEGER PRIMARY KEY AUTOINCREMENT,"   \
JOB_TASK_ID         " TEXT,"                    \
JOB_COMMAND         " TEXT,"                    \
JOB_URL             " TEXT,"                    \
JOB_JSON            " TEXT,"                    \
JOB_HEADER          " TEXT,"                    \
JOB_FILE_PATH       " TEXT,"                    \
JOB_IS_MAIN         " INTEGER,"                 \
JOB_STATUS          " INTEGER"                  \
")"

/////////////////不要写在我的下面//////////////////////////////////
