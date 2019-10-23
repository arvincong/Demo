//
//  AWFadeColor.h
//  JALearnOC
//
//  Created by jason on 13/5/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到下
    GradientTypeLeftToRight = 1,//从左到右
};

NS_ASSUME_NONNULL_BEGIN

@interface AWFadeColor : NSObject

+ (UIImage *)getGradientImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;

@end

NS_ASSUME_NONNULL_END
