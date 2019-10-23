//
//  UIColor+AWHexColor.h
//  NewEasyLoan
//
//  Created by arvin wang on 2018/11/15.
//  Copyright © 2018 arvin wang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (AWHexColor)

/**
 *  将给定的十六进制色值(#FFFF00或FFFF00)字符串转为相应的颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;


+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
