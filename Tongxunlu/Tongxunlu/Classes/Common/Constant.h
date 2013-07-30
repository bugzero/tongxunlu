//
//  Constant.h
//  Tongxunlu
//
//  Created by kongkong on 13-6-11.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#ifndef Tongxunlu_Constant_h
#define Tongxunlu_Constant_h

/// layout
#define SCREEN_HEIGHT               [[UIScreen mainScreen] bounds].size.height
#define STATUSBAR_HEIGHT            [[UIApplication sharedApplication] statusBarFrame].size.height
#define FULL_WIDTH                  [[UIScreen mainScreen] bounds].size.width
#define FULL_HEIGHT                 SCREEN_HEIGHT - STATUSBAR_HEIGHT
#define IS_IPHONE5                  (SCREEN_HEIGHT == 568)

#define NAVBAR_HEIGHT               49.f
#define CONTENT_HEIGHT              (FULL_HEIGHT - NAVBAR_HEIGHT)
#define CONTENT_VIEW_FRAME          CGRectMake(0, NAVBAR_HEIGHT, FULL_WIDTH, CONTENT_HEIGHT)
#define FULL_VIEW_FRAME             CGRectMake(0, 0, FULL_WIDTH, FULL_HEIGHT)

/// constant values
#define EZ_ANIMATION_DURATION       0.4f

#define K_NAVIGATIONCTL             @"txlNavigationViewController"
#define K_SETTING                   @"txlSetting"
#define K_TXL_BASE_PATH             @"txlBasePath"
#define K_DBMANAGER                 @"databaseManager"

#define USER_NAME                   @"u_name"
#define USER_PWD                    @"u_password"
#define USER_COMP_CODE              @"comp_code"
#define USER_COMP_ID                @"comp_id"

#define COMP_USER_CACHE_DATAS       @"compCacheKey"
#define COMP_DEPT_CACHE_DATAS       @"compDeptCacheKey"
#define SHARE_ALLIANCE_CACHE_DATAS  @"shareAllianceCacheKey"
#define SHARE_DETAIL_CACHE_DATAS    @"shareDetailCacheKey"

#define kColorDrowpDownFirstRow [UIColor whiteColor]
#define kColorDrowpDownSecondRow [UIColor colorWithRed:243.0f/255.0f green:247.0f/255.0f blue:250.0f/255.0f alpha:1.0f]
#define kColorDrowpDownLastRow [UIColor colorWithRed:27.0f/255.0f green:192.0f/255.0f blue:158.0f/255.0f alpha:1.0f]
#define kColorDrowpDownLastRowText [UIColor colorWithRed:24.0f/255.0f green:158.0f/255.0f blue:131.0f/255.0f alpha:1.0f]

///view tagg
#define TAG_TITLELB     -(1<<2)

#define isEmptyStr(str) (!str|| [str.trim isEqualToString:@""])

#endif
