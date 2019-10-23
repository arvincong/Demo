//
//  HeaderCommon.h
//  JALearnOC
//
//  Created by jason on 8/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#ifndef HeaderCommon_h
#define HeaderCommon_h

//常用宏
#define SCREEN_HEIGHTL [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTHL [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#define Height_StatusBar [[UIApplication sharedApplication] statusBarFrame].size.height
#define STATUS_BAR_BIGGER_THAN_20 [UIApplication sharedApplication].statusBarFrame.size.height > 20
#define Height_NavBar self.navigationController.navigationBar.frame.size.height
#define Height_TopBar (Height_StatusBar+Height_NavBar)
#define KIsIphone5 CGRectGetHeight([UIScreen mainScreen].bounds) == 568 ? YES:NO
#define KIsiPhoneX ((int)((SCREEN_HEIGHTL/SCREEN_WIDTHL)*100) == 216)?YES:NO
#define isIphoneX_XS (kScreenWidth == 375.f && kScreenHeight == 812.f ? YES : NO)
#define isIphoneXR_XSMax (kScreenWidth == 414.f && kScreenHeight == 896.f ? YES : NO)
#define KFullScreen (isIphoneX_XS || isIphoneXR_XSMax)


#define KNavBgColor [UIColor colorWithHexString:@"#292930"]

#define KNormalBgColor [UIColor colorWithHexString:@"#1E1F22"]


// 防止多次调用
#define kPreventRepeatClickTime(_seconds_) \
static BOOL shouldPrevent; \
if (shouldPrevent) return; \
shouldPrevent = YES; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_seconds_) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
shouldPrevent = NO; \
}); \

#endif /* HeaderCommon_h */
