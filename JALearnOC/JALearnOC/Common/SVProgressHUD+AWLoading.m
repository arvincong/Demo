//
//  SVProgressHUD+AWLoading.m
//  NewEasyLoan
//
//  Created by arvin wang on 2018/12/12.
//  Copyright © 2018 arvin wang. All rights reserved.
//

#import "SVProgressHUD+AWLoading.h"


@implementation SVProgressHUD (AWLoading)

+(void)showLoadingHUDInWindow:(NSString *)message;
{
    UIImage *image = [UIImage sd_animatedGIFNamed:@"loading"];
    [SVProgressHUD showImage:image status:message];
    [SVProgressHUD setImageViewSize:CGSizeMake(105, 31)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setMinimumDismissTimeInterval:CGFLOAT_MAX];
    [SVProgressHUD setMinimumSize:CGSizeMake(105,90)];
    [SVProgressHUD setFont:[UIFont fontWithName:@"PingFang-SC-Regular" size:15]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithHexString:@"#45494d"]];
}

+(void)showLoadingHUDInView:(UIView *)targetView message:(NSString*)message;
{
    UIImage *image = [UIImage sd_animatedGIFNamed:@"loading"];
    [SVProgressHUD showImage:image status:message];
    [SVProgressHUD setImageViewSize:CGSizeMake(105, 31)];
    [SVProgressHUD setContainerView:targetView];
    UIOffset offset;
    CGFloat hx = targetView.center.y - SCREEN_HEIGHTL / 2 - (KFullScreen?(88+Height_StatusBar):(64));
    CGFloat vx = targetView.center.x - SCREEN_WIDTHL / 2;
    offset = UIOffsetMake(vx, hx);
    [SVProgressHUD setOffsetFromCenter:offset];
    
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:CGFLOAT_MAX];
     [SVProgressHUD setFont:[UIFont fontWithName:@"PingFang-SC-Regular" size:15]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithHexString:@"#45494d"]];
}

@end
