//
//  NSString+AWTool.h
//  JALearnOC
//
//  Created by jason on 5/6/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (AWTool)

-(BOOL)isJudgeChinese;

/**
 *返回值是该字符串所占的大小(width, height)
 *font : 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
 *maxSize : 为限制改字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
 */

-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


/**
 取出字符串中的数字
 */
-(NSInteger)getNumberMethod;

@end

NS_ASSUME_NONNULL_END
