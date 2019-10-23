//
//  NSDataAdditions.h
//  TapKit
//
//  Created by jason on 24/7/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (TapKit)

/**
 生成MD5

 @return 返回MD5的字符串
 */
- (NSString *)AW_MD5HashString;
/**
 生成SHA1
 
 @return 返回SHA1的字符串
 */
- (NSString *)AW_SHA1HashString;

@end
