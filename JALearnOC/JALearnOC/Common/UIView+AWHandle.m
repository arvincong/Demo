//
//  UIView+AWHandle.m
//  NewEasyLoan
//
//  Created by arvin wang on 2018/11/19.
//  Copyright © 2018 arvin wang. All rights reserved.
//

#import "UIView+AWHandle.h"
#import <objc/runtime.h>

@implementation UIView (AWHandle)
static char ActionTag;

-(void)addAction:(HandleActionBlock)block
{
    self.userInteractionEnabled = YES;
    objc_setAssociatedObject(self, &ActionTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMethod:)];
    [self addGestureRecognizer:tapGes];
}


-(void)clickMethod:(UITapGestureRecognizer *)tap
{
    //防止多次点击
    kPreventRepeatClickTime(0.5);
    
   HandleActionBlock blockAction = (HandleActionBlock)objc_getAssociatedObject(self, &ActionTag);

    if (blockAction){
        blockAction(self);
    }
}
@end
