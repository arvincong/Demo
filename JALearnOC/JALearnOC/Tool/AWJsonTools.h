//
//  AWJsonTools.h
//  NewEasyLoan
//
//  Created by arvin wang on 2018/11/23.
//  Copyright © 2018 arvin wang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AWJsonTools : NSObject

+ (NSString *)convertToString:(id)objc;

+ (NSDictionary *)stringConverToDict:(id)string;

//对象转字典
+ (NSDictionary*)getObjectData:(id)obj;

@end

