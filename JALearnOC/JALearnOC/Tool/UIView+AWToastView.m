//
//  UIView+AWToastView.m
//  JALearnOC
//
//  Created by jason on 27/5/2019.
//  Copyright © 2019 jason. All rights reserved.
//

#import "UIView+AWToastView.h"

@implementation UIView (AWToastView)

-(void)showToastWithMessage:(NSString *)message withImage:(NSString *)iconName withTime:(NSTimeInterval)timeInterval withComplete:(CompleteBlock)block
{
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CSToastStyle *styleModel = [CSToastStyle new];
        styleModel.messageFont = [UIFont systemFontOfSize:15];
        styleModel.messageColor = [UIColor whiteColor];
        UIImage *toastImage = [UIImage imageNamed:iconName];
        NSLog(@"this image size is %@",NSStringFromCGSize(toastImage.size));
        styleModel.imageSize = toastImage.size;
        styleModel.horizontalPadding = 40;
        //styleModel.verticalPadding = 10;
        
        
        [weakSelf makeToast:message duration:timeInterval position:CSToastPositionCenter title:@"" image:toastImage style:styleModel completion:^(BOOL didTap) {
            
            if(block){
                 block();
            }
        }];
    });
    
}

@end
