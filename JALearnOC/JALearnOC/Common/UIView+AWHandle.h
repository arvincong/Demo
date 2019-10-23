//
//  UIView+AWHandle.h
//  NewEasyLoan
//
//  Created by arvin wang on 2018/11/19.
//  Copyright © 2018 arvin wang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HandleActionBlock)(id sender);

@interface UIView (AWHandle)

//封装点击的block
-(void)addAction:(HandleActionBlock)block;


@end

NS_ASSUME_NONNULL_END
