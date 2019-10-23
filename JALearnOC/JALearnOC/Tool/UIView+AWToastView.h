//
//  UIView+AWToastView.h
//  JALearnOC
//
//  Created by jason on 27/5/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Toast.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompleteBlock)(void);

@interface UIView (AWToastView)

/*
 * toast 带图片的封装
 */
-(void)showToastWithMessage:(NSString *)message withImage:(NSString *)iconName withTime:(NSTimeInterval)timeInterval withComplete:(CompleteBlock)block;

@end

NS_ASSUME_NONNULL_END
