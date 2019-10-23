//
//  SVProgressHUD+AWLoading.h
//  NewEasyLoan
//
//  Created by arvin wang on 2018/12/12.
//  Copyright © 2018 arvin wang. All rights reserved.

//  加载gif 封装

#import "SVProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVProgressHUD (AWLoading)

//在window上显示
+(void)showLoadingHUDInWindow:(NSString *)message;

//在view上显示
+(void)showLoadingHUDInView:(UIView *)targetView message:(NSString*)message;


@end

NS_ASSUME_NONNULL_END
