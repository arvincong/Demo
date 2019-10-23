//
//  UIImageView+AWImageStretch.m
//  JALearnOC
//
//  Created by jason on 15/5/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "UIImageView+AWImageStretch.h"

@implementation UIImageView (AWImageStretch)

-(void)stretchImageMethod
{
    UIImage *image = self.image;
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    CGFloat top = height/2.0f - 0.5f; // 顶端盖高度
    CGFloat bottom = height/2.0f - 0.5f ; // 底端盖高度
    CGFloat left = width/2.0f - 0.5f; // 左端盖宽度
    CGFloat right = width/2.0f - 0.5f; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    self.image = [image resizableImageWithCapInsets:insets];
}
@end
