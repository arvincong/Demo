//
//  HeaderApi.h
//  JALearnOC
//
//  Created by jason on 10/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#ifndef HeaderApi_h
#define HeaderApi_h

#if DEBUG

#define MLGB_API_URL @"http://203.195.174.155"

#else

#define MLGB_API_URL @"http://203.195.174.155"

#endif


#warning 相关api
//视频列表
#define VIDEO_LIST_API @"/api/v1/video/videos"

//视频详情
#define VIDEO_DETAIL_API @"/api/v1/video/details"

//视频播放地址
#define VIDEO_PLAYURL_API @"/api/v1/video/player"

//视频列表搜索接口 参数  wd type bm mj
#define VIDEO_SEARCH_API @"/api/v1/video/search"


#endif /* HeaderApi_h */
