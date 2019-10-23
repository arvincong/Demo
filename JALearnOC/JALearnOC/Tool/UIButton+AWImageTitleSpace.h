//
//  UIButton+AWImageTitleSpace.h
//  JALearnOC
//
//  Created by jason on 14/5/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AWButtonEdgeInsetsStyleTop,     //image在上，label在下
    AWButtonEdgeInsetsStyleLeft,   //image在左，label在右
    AWButtonEdgeInsetsStyleBottom, //image在下，label在上
    AWButtonEdgeInsetsStyleRight   //image在右，label在左
} AWButtonType;

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (AWImageTitleSpace)

- (void)layoutButtonWithEdgeInsetsStyle:(AWButtonType)style
                        imageTitleSpace:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
